import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BaseChartDirective } from 'ng2-charts';
import { ChartConfiguration, ChartData, ChartType } from 'chart.js';
import { SidebarComponent } from '../sidebar/sidebar.component';

@Component({
  selector: 'app-reports',
  imports: [CommonModule, BaseChartDirective, SidebarComponent],
  templateUrl: './reports.component.html',
  styleUrl: './reports.component.scss'
})
export class ReportsComponent {
  // Chart Properties for Revenue Overview
  public barChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false }
    },
    scales: {
      y: {
        beginAtZero: true,
        max: 60000,
        ticks: {
          stepSize: 15000,
          callback: function (value) { return 'LKR ' + value; }
        },
        grid: { color: '#f1f5f9', tickColor: 'transparent' },
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
    labels: ['Dec 19', 'Dec 20', 'Dec 21', 'Dec 22', 'Dec 23', 'Dec 24', 'Dec 25', 'Dec 26'],
    datasets: [{
      data: [45000, 33000, 24000, 14000, 48000, 38000, 31000, 37000],
      backgroundColor: '#0d7b8a',
      borderRadius: 4,
      barPercentage: 0.6,
      hoverBackgroundColor: '#0b616d'
    }]
  };
}
