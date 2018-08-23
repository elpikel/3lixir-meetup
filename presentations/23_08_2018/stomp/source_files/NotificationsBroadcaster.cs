using CageEye.Cloud.Models;
using CageEye.Cloud.Services.Broadcasters.Contracts;
using CageEye.Cloud.Services.Bus;

namespace CageEye.Cloud.Services.Broadcasters
{
  public class NotificationsBroadcaster : IBroadcaster<Notification>
  {
    private readonly CloudMessageProducer _cloudMessageProducer;

    public NotificationsBroadcaster(CloudMessageProducer cloudMessageProducer)
    {
      _cloudMessageProducer = cloudMessageProducer;
    }

    public void Broadcast(Notification notification)
    {
      _cloudMessageProducer.Broadcast(
        notification.FarmId,
        $"farm-{notification.FarmId}.notifications.{notification.Kind}",
        new { Text = notification.GetNotificationText() });
    }
  }
}