import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SidebarComponent } from '../sidebar/sidebar.component';

interface Transaction {
  id: string;
  userName: string;
  dateTime: string;
  duration: string;
  amount: number;
  paymentMethod: string;
  status: 'Success' | 'Pending' | 'Failed';
  action: 'Mark Unpaid' | 'Mark Paid';
  vehicleType: string;
}

@Component({
  selector: 'app-transaction-logs',
  imports: [CommonModule, FormsModule, SidebarComponent],
  templateUrl: './transaction-logs.component.html',
  styleUrl: './transaction-logs.component.scss'
})
export class TransactionLogsComponent {
  selectedDate: string = 'December 26th, 2025';
  selectedStatus: string = 'All Statuses';
  selectedVehicle: string = 'Vehicle Type';

  transactions: Transaction[] = [
    { id: 'TXN-7829', userName: 'John Doe', dateTime: '2023-10-24 14:30', duration: '2h 15m', amount: 450.00, paymentMethod: 'Cash', status: 'Success', action: 'Mark Unpaid', vehicleType: 'Car' },
    { id: 'TXN-7830', userName: 'Jane Smith', dateTime: '2023-10-24 13:15', duration: '45m', amount: 200.00, paymentMethod: 'Cash', status: 'Success', action: 'Mark Unpaid', vehicleType: 'Bike' },
    { id: 'TXN-7831', userName: 'Robert Johnson', dateTime: '2023-10-24 12:00', duration: '5h 00m', amount: 1000.00, paymentMethod: 'Cash', status: 'Pending', action: 'Mark Paid', vehicleType: 'Van' },
    { id: 'TXN-7832', userName: 'Emily Davis', dateTime: '2023-10-24 11:45', duration: '1h 30m', amount: 300.00, paymentMethod: 'Cash', status: 'Success', action: 'Mark Unpaid', vehicleType: 'Car' },
    { id: 'TXN-7833', userName: 'Michael Wilson', dateTime: '2023-10-24 10:20', duration: '3h 45m', amount: 750.00, paymentMethod: 'Cash', status: 'Failed', action: 'Mark Paid', vehicleType: 'Car' },
    { id: 'TXN-7834', userName: 'Sarah Brown', dateTime: '2023-10-24 09:10', duration: '8h 00m', amount: 1500.00, paymentMethod: 'Cash', status: 'Success', action: 'Mark Unpaid', vehicleType: 'Van' },
    { id: 'TXN-7835', userName: 'David Miller', dateTime: '2023-10-24 08:30', duration: '30m', amount: 100.00, paymentMethod: 'Cash', status: 'Success', action: 'Mark Unpaid', vehicleType: 'Bike' },
  ];

  get filteredTransactions() {
    return this.transactions.filter(txn => {
      const matchStatus = this.selectedStatus === 'All Statuses' || txn.status === this.selectedStatus;
      const matchVehicle = this.selectedVehicle === 'Vehicle Type' || txn.vehicleType === this.selectedVehicle;
      return matchStatus && matchVehicle;
    });
  }

  resetFilters() {
    this.selectedStatus = 'All Statuses';
    this.selectedVehicle = 'Vehicle Type';
    // Optionally reset date, but UI has it hardcoded for demo
  }
}

