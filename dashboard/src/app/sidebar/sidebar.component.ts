import { Component } from '@angular/core';
import { RouterModule, Router } from '@angular/router';

@Component({
  selector: 'app-sidebar',
  imports: [RouterModule],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.scss'
})
export class SidebarComponent {
  constructor(private router: Router) {}

  signOut(event: Event) {
    event.preventDefault();
    // Navigate back to the login page (path: '')
    this.router.navigate(['/']);
  }
}
