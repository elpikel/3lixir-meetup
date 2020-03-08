import { Component, OnInit, OnDestroy } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { OAuthService } from 'angular-oauth2-oidc';
import { HealhStatusService } from './../../../services/health-status/health-status.service';
import { SessionService } from './../../../services/session/session.service';
import { NotificationService } from './../../../services/notification/notification.service';
import { HealthStatusInterface } from '../../../interfaces/farm-info/health-status.interface';
import { BusService } from '../../../services/bus/bus.service';
import { SystemStatusModalComponent } from '../system-status/system-status-modal.component';

@Component({
  selector: 'header',
  templateUrl: './header.component.html'
})
export class HeaderComponent implements OnInit, OnDestroy {
  public notificationListIsShown: boolean = false;
  public unseenNotificationsAmount = 0;

  public healthStatuses: HealthStatusInterface[] = [];
  public okFarmIds = new Set();
  public errorFarmIds = new Set();
  public totalErrorsNumber = 0;

  constructor(private oauthService: OAuthService,
    private healthStatusService: HealhStatusService,
    private sessionService: SessionService,
    private notificationService: NotificationService,
    private busService: BusService,
    public dialog: MatDialog) {
  }

  ngOnInit() {
    this.getHealthStatus();
    this.initUnseenNotifications();
    this.busService.connect(this.getBusEndpoint(), (_: any) => {
      this.unseenNotificationsAmount += 1
    });
  }

  ngOnDestroy() {
    this.busService.disconnect(this.getBusEndpoint());
  }

  public toggleNotifications() {
    this.unseenNotificationsAmount = 0;
    this.notificationListIsShown = !this.notificationListIsShown;
  }

  public logout() {
    this.oauthService.logOut();
  }

  private getBusEndpoint() {
    return `farm-${this.sessionService.getCurrentUser().farmId}.notifications.#`;
  }

  private initUnseenNotifications() {
    this.notificationService.getUnseenAmount(this.sessionService.getCurrentUser().farmId)
      .subscribe(res => {
        this.unseenNotificationsAmount = res || 0;
      });
  }

  private getHealthStatus() {
    this.healthStatusService.getShortStatus().subscribe(res => {
      this.healthStatuses = res;
      this.errorFarmIds = new Set();
      this.okFarmIds = new Set();

      for (let item of this.healthStatuses) {
        let hasError = false;
        if(item.integrationError) {
          hasError = true;
          this.addError(item.id);
        }
        if(item.configurationError) {
          hasError = true;
          this.addError(item.id);
        }
        if(item.hardwareError) {
          hasError = true;
          this.addError(item.id);
        }
        if(item.connectivityError) {
          hasError = true;
          this.addError(item.id);
        }

        if(!hasError)
          this.okFarmIds.add(item.id);
      }
    });
  }

  private addError(id:number) {
    this.errorFarmIds.add(id);
    this.totalErrorsNumber++;
  }

  public openDialog() {
    if (this.healthStatuses.length === 1) {
      const dialogRef = this.dialog.open(SystemStatusModalComponent, {
        id: 'system-status-modal',
        width: '500px',
        // height: '500px',
        autoFocus: false,
        data: this.healthStatuses[0]
      });
    }
  }
}
