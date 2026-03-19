import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { ParkingRatesComponent } from './parking-rates/parking-rates.component';
import { TransactionLogsComponent } from './transaction-logs/transaction-logs.component';
import { ReportsComponent } from './reports/reports.component';
import { ParkingSlotManagementComponent } from './parking-slot-management/parking-slot-management.component';
import { UserDirectoryComponent } from './user-directory/user-directory.component';
import { SystemSettingsComponent } from './system-settings/system-settings.component'; // Re-trigger compile

export const routes: Routes = [
  { path: '', component: LoginComponent },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'parking-rates', component: ParkingRatesComponent },
  { path: 'transaction-logs', component: TransactionLogsComponent },
  { path: 'reports', component: ReportsComponent },
  { path: 'parking-slot-management', component: ParkingSlotManagementComponent },
  { path: 'user-directory', component: UserDirectoryComponent },
  { path: 'system-settings', component: SystemSettingsComponent }
];
