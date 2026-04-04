import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../services/auth.service';

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
  loginError = '';
  isLoading = false;
  
  private router = inject(Router);
  private authService = inject(AuthService);

  togglePasswordVisibility(): void {
    this.passwordVisible = !this.passwordVisible;
  }

  validateEmail(email: string): boolean {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }

  async onLogin(event: Event): Promise<void> {
    event.preventDefault();
    this.emailError = '';
    this.passwordError = '';
    this.loginError = '';
    
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
      this.isLoading = true;
      try {
        const result = await this.authService.login(this.email, this.password);
        if (result.success) {
          this.router.navigate(['/dashboard']);
        } else {
          this.loginError = result.message || 'Login failed. Please try again.';
        }
      } catch (error) {
        this.loginError = 'An unexpected error occurred. Please try again.';
      } finally {
        this.isLoading = false;
      }
    }
  }

  async forgotPassword(event: Event): Promise<void> {
    event.preventDefault();
    this.emailError = '';
    this.loginError = '';

    if (!this.email) {
      this.emailError = 'Please enter your email address above to reset your password.';
      return;
    }

    if (!this.validateEmail(this.email)) {
      this.emailError = 'Please enter a valid email address.';
      return;
    }

    try {
      await this.authService.resetPassword(this.email);
      alert('A password reset link has been sent to your email address.');
    } catch (error: any) {
      if (error.code === 'auth/user-not-found') {
        this.loginError = 'No account found with this email address.';
      } else {
        this.loginError = 'Failed to send password reset email. Please try again.';
      }
    }
  }
}
