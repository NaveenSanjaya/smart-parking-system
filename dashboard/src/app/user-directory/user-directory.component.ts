import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SidebarComponent } from '../sidebar/sidebar.component';

interface User {
  id: string;
  name: string;
  memberType: string;
  email: string;
  phone: string;
  vehicle: string;
  status: 'Active' | 'Banned' | 'Inactive';
}

@Component({
  selector: 'app-user-directory',
  standalone: true,
  imports: [CommonModule, FormsModule, SidebarComponent],
  templateUrl: './user-directory.component.html',
  styleUrl: './user-directory.component.scss'
})
export class UserDirectoryComponent {
  searchTerm: string = '';
  
  users: User[] = [
    { id: 'USR-001', name: 'John Doe', memberType: 'Premium Member', email: 'john@example.com', phone: '+1 (555) 123-4567', vehicle: 'ABC-1234', status: 'Active' },
    { id: 'USR-002', name: 'Jane Smith', memberType: 'Standard Member', email: 'jane@example.com', phone: '+1 (555) 987-6543', vehicle: 'XYZ-9876', status: 'Active' },
    { id: 'USR-003', name: 'Robert Johnson', memberType: 'Standard Member', email: 'robert@example.com', phone: '+1 (555) 456-7890', vehicle: 'LMN-4567', status: 'Banned' },
    { id: 'USR-004', name: 'Emily Davis', memberType: 'Premium Member', email: 'emily@example.com', phone: '+1 (555) 222-3333', vehicle: 'PQR-1111', status: 'Active' },
    { id: 'USR-005', name: 'Michael Wilson', memberType: 'Standard Member', email: 'michael@example.com', phone: '+1 (555) 444-5555', vehicle: 'STU-2222', status: 'Inactive' },
    { id: 'USR-006', name: 'Sarah Brown', memberType: 'Standard Member', email: 'sarah@example.com', phone: '+1 (555) 666-7777', vehicle: 'VWX-3333', status: 'Active' },
    { id: 'USR-007', name: 'David Miller', memberType: 'Standard Member', email: 'david@example.com', phone: '+1 (555) 888-9999', vehicle: 'YZA-4444', status: 'Active' },
  ];

  get filteredUsers(): User[] {
    if (!this.searchTerm) return this.users;
    const term = this.searchTerm.toLowerCase();
    return this.users.filter(u => 
      u.name.toLowerCase().includes(term) ||
      u.id.toLowerCase().includes(term) ||
      u.email.toLowerCase().includes(term) ||
      u.vehicle.toLowerCase().includes(term)
    );
  }

  showAddUserModal = false;
  saveUserAttempted = false;
  newUser: Partial<User> = {
    memberType: 'Standard Member',
    status: 'Active'
  };

  openAddModal() {
    this.showAddUserModal = true;
    this.saveUserAttempted = false;
    this.newUser = { memberType: 'Standard Member', status: 'Active' };
  }

  closeAddModal() {
    this.showAddUserModal = false;
    this.saveUserAttempted = false;
  }

  validateEmail(email: string): boolean {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }

  saveUser() {
    this.saveUserAttempted = true;
    if (this.newUser.name && this.newUser.email && this.validateEmail(this.newUser.email)) {
      const newId = 'USR-' + String(this.users.length + 1).padStart(3, '0');
      this.users.unshift({
        id: newId,
        name: this.newUser.name,
        memberType: this.newUser.memberType || 'Standard Member',
        email: this.newUser.email,
        phone: this.newUser.phone || '',
        vehicle: this.newUser.vehicle || '',
        status: (this.newUser.status as any) || 'Active'
      });
      this.closeAddModal();
    }
  }

  deleteUser(userId: string) {
    if(confirm('Are you sure you want to delete this user?')) {
      this.users = this.users.filter(u => u.id !== userId);
    }
  }
}
