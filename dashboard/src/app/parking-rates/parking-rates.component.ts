import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SidebarComponent } from '../sidebar/sidebar.component';

@Component({
  selector: 'app-parking-rates',
  standalone: true,
  imports: [CommonModule, FormsModule, SidebarComponent],
  templateUrl: './parking-rates.component.html',
  styleUrl: './parking-rates.component.scss'
})
export class ParkingRatesComponent {
  rates: any = {
    car: {
      type: 'Car',
      plan: 'Standard Tariff',
      status: 'Active',
      firstHour: 50,
      subsequentHour: 30,
      dailyMax: 500,
      lostTicket: 1000,
      color: 'blue'
    },
    bike: {
      type: 'Bike',
      plan: 'Standard Tariff',
      status: 'Active',
      firstHour: 20,
      subsequentHour: 10,
      dailyMax: 150,
      lostTicket: 500,
      color: 'green'
    },
    threeWheeler: {
      type: 'Three-wheeler',
      plan: 'Standard Tariff',
      status: 'Active',
      firstHour: 30,
      subsequentHour: 20,
      dailyMax: 300,
      lostTicket: 800,
      color: 'orange'
    }
  };

  settings = {
    gracePeriod: 15,
    weekendSurcharge: 0
  };

  isModalOpen = false;
  selectedVehicleKey: string = '';
  editingRate: any = {
    firstHour: 0,
    subsequentHour: 0,
    dailyMax: 0,
    lostTicket: 0
  };

  openEditModal(vehicleKey: string) {
    this.selectedVehicleKey = vehicleKey;
    // Create a shallow copy of the rate object to edit
    this.editingRate = { ...this.rates[vehicleKey] };
    this.isModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
  }

  saveRates() {
    // Update the main rates object with the edited values
    this.rates[this.selectedVehicleKey] = { ...this.editingRate };
    this.closeModal();
  }
}
