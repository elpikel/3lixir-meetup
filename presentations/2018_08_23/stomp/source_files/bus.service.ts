import { Injectable } from "@angular/core";
import { SessionService } from "../session/session.service";

@Injectable()
export class BusService {
  private client: any;
  private connecting: boolean = false;
  private connected: boolean = false;
  private username: string;
  private password: string;
  private hostName: string;
  private subscriptions: Map<string, (message: any) => void> = new Map<string, (message: any) => void>();

  constructor(private sessionService: SessionService) {
    this.sessionService.getBusInfo().subscribe(res => {
      this.username = res.username;
      this.password = res.password;
      this.hostName = res.hostName;
      this.establishConnection();
    });
  }

  public connect(routingKey: string, onReceive: (message: any) => void) {
    if (!this.subscriptions.has(routingKey))
      this.subscriptions.set(routingKey, onReceive);

    if (this.connected)
      this.subscribe(routingKey, onReceive);
  }

  public disconnect(routingKey: string) {
    if (!this.subscriptions.has(routingKey))
      return;

    this.subscriptions.delete(routingKey);

    if(this.client)
      this.client.unsubscribe(routingKey);
  }

  private subscribe(routingKey: string, onReceive: (message: any) => void) {
    let user = this.sessionService.getCurrentUser();
    this.client.subscribe(
      `/exchange/x.v1.to-user-${user.id}/${routingKey}`,
      onReceive,
      { id: routingKey }
    );
  }

  private establishConnection() {
    if (this.connecting)
      return;

    this.connected = false;
    this.connecting = true;

    this.client = (<any>window).Stomp.client(this.hostName);
    this.client.debug = null;
    this.client.connect(
      this.username,
      this.password,
      () => this.onConnect(),
      () => this.onError(),
      "/"
    );
  }

  private onError() {
    if (this.connecting)
      return;

    setTimeout(() => {
      this.establishConnection();
    }, 5000);
  }

  private onConnect() {
    if (!this.connecting)
      return;

    this.connecting = false;
    this.connected = true;

    for (let [routingKey, onReceive] of this.subscriptions) {
      this.subscribe(routingKey, onReceive);
    }
  }
}
