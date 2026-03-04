import { Component } from '@angular/core';
import { SidebarComponent } from '../sidebar/sidebar.component';
import { BaseChartDirective } from 'ng2-charts';
import { ChartConfiguration, ChartData, ChartType } from 'chart.js';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [SidebarComponent, BaseChartDirective],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
export class DashboardComponent {
  // Statistics data
  availableSlots = { count: 32, label: '27% available' };
  totalParking = { count: 120, label: 'Across 5 zones' };
  activeUsers = { count: 88, label: '↑ +12% vs last hour' };
  totalRevenue = { amount: 'LKR 124,550.00', label: '↑ +4% from yesterday' };
  pendingPayments = { count: 5, label: 'Awaiting processing' };

  // Chart Properties
  public barChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: false,
      }
    },
    scales: {
      y: {
        beginAtZero: true,
        max: 100,
        title: {
          display: false
        },
        ticks: {
          stepSize: 25,
          callback: function (value) {
            return value + '%';
          }
        },
        grid: {
          color: '#f1f5f9',
          tickColor: 'transparent'
        },
        border: { display: false }
      },
      x: {
        grid: { display: false },
        border: { display: false }
      }
    }
  };
  public barChartType: ChartType = 'bar';
  public barChartData: ChartData<'bar'> = {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    datasets: [
      {
        data: [65, 72, 85, 90, 95, 82, 55],
        backgroundColor: '#0d7b8a',
        borderRadius: 4,
        barPercentage: 0.6,
        hoverBackgroundColor: '#0b616d'
      }
    ]
  };

  // Recent Activity Data
  activities = [
    {
      type: 'success',
      iconUrl: '',
      title: 'ABC-1234',
      description: 'Entered at L1-A04',
      time: '2 mins ago'
    },
    {
      type: 'info',
      iconUrl: '',
      title: 'XYZ-9876',
      description: 'Paid LKR 450.00 • 2h 15m',
      time: '5 mins ago'
    },
    {
      type: 'success',
      iconUrl: '',
      title: 'LMN-4567',
      description: 'Entered at L2-B11',
      time: '12 mins ago'
    },
    {
      type: 'error',
      iconUrl: '',
      title: 'Gate 2 Malfunction',
      description: 'Status: critical',
      time: '15 mins ago'
    },
    {
      type: 'info',
      iconUrl: '',
      title: 'JKL-3322',
      description: 'Paid LKR 200.00 • 45m',
      time: '22 mins ago'
    }
  ];
}
