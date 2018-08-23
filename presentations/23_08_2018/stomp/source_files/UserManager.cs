using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using CageEye.Cloud.Data.Bus;
using CageEye.Cloud.Data.Storage;
using CageEye.Cloud.Models;
using CageEye.Cloud.ViewModels.Account;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace CageEye.Cloud.Services.Managers
{
  public class UserManager
  {
    private readonly UserManager<User> _userManager;
    private readonly IBusFactory _busFactory;
    private readonly IConfiguration _configuration;
    private readonly StorageFactory _storageFactory;
    public string Prefix { get; set; } = string.Empty;

    public UserManager(
      UserManager<User> userManager,
      StorageFactory storageFactory,
      IBusFactory busFactory,
      IConfiguration configuration)
    {
      _busFactory = busFactory;
      _configuration = configuration;
      _storageFactory = storageFactory;
      _userManager = userManager;
    }

    public async Task<User> RegisterAsync(int farmId, string email, string password)
    {
      var newUser = new User
      {
        UserName = email,
        FarmUsers = new List<FarmUser> { new FarmUser { FarmId = farmId } }
      };

      var result = await _userManager.CreateAsync(newUser, password);
      if (!result.Succeeded) throw new Exception("Validation failed!");

      return newUser;
    }

    public async Task<UserBusInfoViewModel> GetBusInfo(string id)
    {
      using (var storageContext = _storageFactory.Create())
      {
        var user = await storageContext.Users
          .Include("FarmUsers.Farm")
          .FirstOrDefaultAsync(u => u.Id == id);

        if (string.IsNullOrEmpty(user.BusPassword))
        {
          user.BusPassword = Guid.NewGuid().ToString();

          var busManager = _busFactory.CreateManager();

          busManager.CreateUser(user.SuggestedBusUsername, user.BusPassword);
          busManager.CreatePermission(user.SuggestedBusUsername,
            read: "^" + Regex.Escape(BusFactory.ExchangeToUserPrefix + user.Id) + "|(stomp-subscription.*)$",
            write: "^stomp-subscription.*",
            configure: "^stomp-subscription.*");

          using (var busContext = _busFactory.Create())
          {
            busContext.CreateExchange(BusFactory.ExchangeToUserPrefix + user.Id);
          }

          await storageContext.SaveChangesAsync();
        }

        return new UserBusInfoViewModel
        {
          Username = user.SuggestedBusUsername,
          Password = user.BusPassword,
          HostName = _configuration["STOMP_URL"]
        };
      }
    }

    public async Task<UserInfoViewModel> Get(string id)
    {
      using (var storageContext = _storageFactory.Create())
      {
        var user = await storageContext.Users
          .Include("FarmUsers.Farm")
          .FirstOrDefaultAsync(u => u.Id == id);

        if (user == null)
          return null;

        return new UserInfoViewModel
        {
          Id = id,
          Email = user.Email,
          Env = new EnvironmentConfigModel
          {
            Ga = _configuration["GA"]
          },
          Farms = user.FarmUsers.Select(f => new FarmViewModel
          {
            Id = f.FarmId,
            Name = f.Farm.Name,
            Efi = f.Farm.Efi,
            BarentswatchId = f.Farm.BarentswatchId,
            Latitude = f.Farm.Latitude,
            Longitude = f.Farm.Longitude,
            TimeZone = f.Farm.TZName,
            ContactName = f.Farm.ContactName,
            ContactEmail = f.Farm.ContactEmail,
            CompanyName = f.Farm.CompanyName,
            Notes = f.Farm.Notes
          }).ToList()
        };
      }
    }
  }
}