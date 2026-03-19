import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent {
  passwordVisible = false;
  email = '';
  password = '';
  emailError = '';
  passwordError = '';
  
  private router = inject(Router);

  togglePasswordVisibility(): void {
    this.passwordVisible = !this.passwordVisible;
  }

  validateEmail(email: string): boolean {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }

  onLogin(event: Event): void {
    event.preventDefault();
    this.emailError = '';
    this.passwordError = '';
    
    let isValid = true;
    
    if (!this.email) {
      this.emailError = 'Email address is required.';
      isValid = false;
    } else if (!this.validateEmail(this.email)) {
      this.emailError = 'Please enter a valid email address.';
      isValid = false;
    }
    
    if (!this.password) {
      this.passwordError = 'Password is required.';
      isValid = false;
    }
    
    if (isValid) {
      this.router.navigate(['/dashboard']);
    }
  }
}
