using System.Linq;
using CageEye.Cloud.Data.Bus.HttpHelper;
using Newtonsoft.Json.Linq;

namespace CageEye.Cloud.Data.Bus
{
  public class BusManager : IBusManager
  {
    private readonly HttpClientHelper _httpClientHelper;
    private readonly string _virtualHost;

    public BusManager(HttpClientHelper httpClientHelper, string virtualHost)
    {
      _httpClientHelper = httpClientHelper;
      _virtualHost = virtualHost;
    }

    public JArray ListUsers()
    {
      var result = _httpClientHelper.Get("users").AsString();
      return JArray.Parse(result);
    }

    public void CreateUser(string userName, string password)
    {
      _httpClientHelper.Put($"users/{userName}", $"{{'password': '{password}', 'tags': ''}}");
    }

    public void DeleteUser(string userName)
    {
      _httpClientHelper.Delete($"users/{userName}");
    }

    public void CleanupUsers(string prefix)
    {
      ListUsers().ToList().ForEach(user =>
      {
        var name = (string)user["name"];
        if (name.StartsWith(prefix))
        {
          DeleteUser(name);
        }
      });
    }

    public void CreatePermission(string userName, string read, string write, string configure)
    {
      var body = $"{{'read': '{read}', 'write': '{write}', 'configure': '{configure}' }}";
      var path = $"permissions/{_virtualHost.Replace("/", "%2F")}/{userName}";

      _httpClientHelper.Put(path, body);
    }

    public JToken GetPermissions()
    {
      var result = _httpClientHelper.Get("permissions").AsString();
      return JToken.Parse(result);
    }

    public void SetupQueueMirroring()
    {
      const string policyName = "mirroring-policy";
      const string pattern = @"^q\.v1\.";

      var path = $"policies/{_virtualHost.Replace("/", "%2F")}/{policyName}";
      var body = $"{{'pattern': '{pattern}', 'definition': {{'ha-mode':'all', 'ha-sync-mode': 'automatic'}} }}";

      if (!_httpClientHelper.Get(path).IsSuccessStatusCode)
      {
        _httpClientHelper.Put(path, body);
      }
    }
  }
}