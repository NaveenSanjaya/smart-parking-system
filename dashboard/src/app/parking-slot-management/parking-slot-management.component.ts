import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SidebarComponent } from '../sidebar/sidebar.component';

@Component({
  selector: 'app-parking-slot-management',
  standalone: true,
  imports: [CommonModule, SidebarComponent],
  templateUrl: './parking-slot-management.component.html',
  styleUrl: './parking-slot-management.component.scss'
})
export class ParkingSlotManagementComponent {
  selectedLevel = 'Level 2';
  selectedFilter: 'All' | 'Cars' | 'Bikes' | '3-Wheel' = 'All';

  levels = ['Level 1', 'Level 2', 'Level 3', 'Level 4'];
  filters = ['All', 'Cars', 'Bikes', '3-Wheel'];

  filledCount = 11;
  emptyCount = 29;

  zones = [
    {
      id: 'A',
      name: 'Zone A',
      left: [
        { id: 'A1', type: 'car', state: 'filled-red' },
        { id: 'A2', type: 'car', state: 'empty' },
        { id: 'A3', type: 'car', state: 'empty' },
        { id: 'A4', type: 'car', state: 'empty' }
      ],
      right: [
        { id: 'A5', type: 'car', state: 'empty' },
        { id: 'A6', type: 'car', state: 'empty' },
        { id: 'A7', type: 'car', state: 'empty' },
        { id: 'A8', type: 'car', state: 'empty' }
      ]
    },
    {
      id: 'B',
      name: 'Zone B',
      left: [
        { id: 'B1', type: 'car', state: 'empty' },
        { id: 'B2', type: 'car', state: 'filled-dark' },
        { id: 'B3', type: 'car', state: 'empty' },
        { id: 'B4', type: 'car', state: 'empty' }
      ],
      right: [
        { id: 'B5', type: 'car', state: 'empty-car' },
        { id: 'B6', type: 'car', state: 'empty' },
        { id: 'B7', type: 'car', state: 'filled-dark' },
        { id: 'B8', type: 'car', state: 'filled-red' }
      ]
    },
    {
      id: 'C',
      name: 'Zone C',
      hasEntry: true,
      left: [
        { id: 'C1', type: 'car', state: 'empty' },
        { id: 'C2', type: 'car', state: 'filled-light' },
        { id: 'C3', type: 'car', state: 'empty' },
        { id: 'C4', type: 'car', state: 'empty' }
      ],
      right: [
        { id: 'C5', type: 'car', state: 'empty' },
        { id: 'C6', type: 'car', state: 'empty' },
        { id: 'C7', type: 'car', state: 'empty' },
        { id: 'C8', type: 'car', state: 'filled-dark' }
      ]
    },
    {
      id: 'D',
      name: 'Zone D',
      left: [
        { id: 'D1', type: 'car', state: 'filled-red' },
        { id: 'D2', type: 'car', state: 'empty' },
        { id: 'D3', type: '3wheel', state: 'empty-3wheel' },
        { id: 'D4', type: 'car', state: 'empty' }
      ],
      right: [
        { id: 'D5', type: 'car', state: 'empty' },
        { id: 'D6', type: 'car', state: 'empty' },
        { id: 'D7', type: 'car', state: 'empty' },
        { id: 'D8', type: 'car', state: 'empty' }
      ]
    },
    {
      id: 'E',
      name: 'Zone E',
      hasExit: true,
      left: [
        { id: 'E1', type: 'car', state: 'empty' },
        { id: 'E2', type: 'car', state: 'empty' },
        { id: 'E3', type: 'car', state: 'empty' },
        { id: 'E4', type: 'car', state: 'empty' }
      ],
      right: [
        { id: 'E5', type: 'car', state: 'empty' },
        { id: 'E6', type: 'car', state: 'empty' },
        { id: 'E7', type: 'bike', state: 'filled-bikes' },
        { id: 'E8', type: 'bike', state: 'empty-bikes' }
      ]
    }
  ];

  selectLevel(level: string) {
    this.selectedLevel = level;
    // Simulate floor swap by randomizing filled/empty slightly
    this.filledCount = Math.floor(Math.random() * 20) + 5;
    this.emptyCount = 40 - this.filledCount;
  }

  selectFilter(filter: any) {
    this.selectedFilter = filter;
  }

  isSlotVisible(slot: any): boolean {
    if (this.selectedFilter === 'All') return true;
    if (this.selectedFilter === 'Cars' && slot.type === 'car') return true;
    if (this.selectedFilter === 'Bikes' && slot.type === 'bike') return true;
    if (this.selectedFilter === '3-Wheel' && slot.type === '3wheel') return true;
    return false;
  }
}

