import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SidebarComponent } from '../sidebar/sidebar.component';

@Component({
  selector: 'app-system-settings',
  standalone: true,
  imports: [CommonModule, FormsModule, SidebarComponent],
  templateUrl: './system-settings.component.html',
  styleUrl: './system-settings.component.scss'
})
export class SystemSettingsComponent {
  activeTab = 'general';

  settings = {
    general: {
      systemName: 'SmartPark Kandy',
      timezone: 'Asia/Colombo',
      language: 'English',
      maintenanceMode: false
    },
    notifications: {
      emailAlerts: true,
      smsAlerts: false,
      capacityThreshold: 90,
      dailyReportTime: '18:00'
    },
    security: {
      twoFactorAuth: true,
      sessionTimeout: 30,
      passwordExpiry: 90
    },
    integrations: {
      paymentGateway: 'Stripe',
      apiKey: 'sk_test_123456789',
      iotSyncInterval: 5
    }
  };

  setTab(tab: string) {
    this.activeTab = tab;
  }

  saveAttempted = false;

  isFormValid(): boolean {
    const s = this.settings;
    if (!s.general.systemName) return false;
    if (s.notifications.capacityThreshold == null || s.notifications.capacityThreshold < 0 || s.notifications.capacityThreshold > 100) return false;
    if (s.security.sessionTimeout == null || s.security.sessionTimeout < 1) return false;
    if (s.security.passwordExpiry == null || s.security.passwordExpiry < 1) return false;
    if (s.integrations.iotSyncInterval == null || s.integrations.iotSyncInterval < 1 || s.integrations.iotSyncInterval > 60) return false;
    return true;
  }

  saveSettings() {
    this.saveAttempted = true;
    if (this.isFormValid()) {
      alert('Settings saved successfully!');
      this.saveAttempted = false;
    }
  }
}

