using System;
using System.Collections.Generic;
using System.Linq;
using CageEye.Cloud.Data.Bus;
using CageEye.Cloud.Data.Storage;
using Microsoft.EntityFrameworkCore;

namespace CageEye.Cloud.Services.Bus
{
  public class CloudMessageProducer : IDisposable
  {
    private readonly StorageFactory _storageFactory;
    private readonly IBusContext _busContext;

    public CloudMessageProducer(IBusFactory busFactory, StorageFactory storageFactory)
    {
      _busContext = busFactory.Create();
      _storageFactory = storageFactory;
    }

    public void Broadcast(int farmId, string routingKey, object message)
    {
      var usersId = GetUsersId(farmId);

      foreach (var userId in usersId)
      {
        _busContext.Publish(routingKey, BusFactory.ExchangeToUserPrefix + userId, message);
      }
    }

    public void Dispose()
    {
      _busContext.Dispose();
    }

    private List<string> GetUsersId(int farmId)
    {
      using (var context = _storageFactory.Create())
        return context.FarmUsers.Include(fu => fu.User)
          .Where(fu => fu.FarmId == farmId && fu.User.BusPassword != null)
          .Select(u => u.UserId)
          .ToList();
    }
  }
}