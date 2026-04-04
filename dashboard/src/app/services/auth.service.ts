import { Injectable, inject } from '@angular/core';
import { Router } from '@angular/router';
import { auth, db } from '../firebase.config';
import { signInWithEmailAndPassword, signOut, onAuthStateChanged, User } from 'firebase/auth';
import { doc, getDoc, query, collection, where, getDocs } from 'firebase/firestore';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private router = inject(Router);
  private userSubject = new BehaviorSubject<User | null>(null);
  user$: Observable<User | null> = this.userSubject.asObservable();

  constructor() {
    onAuthStateChanged(auth, (user) => {
      this.userSubject.next(user);
    });
  }

  async login(email: string, password: string): Promise<{ success: boolean; message?: string }> {
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const user = userCredential.user;

      // 1. Try checking by UID (standard)
      const adminDocRef = doc(db, 'admins', user.uid);
      const userDocRef = doc(db, 'users', user.uid);
      
      const [adminDoc, userDoc] = await Promise.all([
        getDoc(adminDocRef).catch(e => { console.error('Admin UID fetch error:', e); return null; }),
        getDoc(userDocRef).catch(e => { console.error('User UID fetch error:', e); return null; })
      ]);

      if (adminDoc?.exists() || userDoc?.exists()) {
        return { success: true };
      }

      // 2. If UID lookup fails, try searching by email field 
      const adminQuery = query(collection(db, 'admins'), where('email', '==', user.email));
      const userQuery = query(collection(db, 'users'), where('email', '==', user.email));
      
      const [adminSnapshot, userSnapshot] = await Promise.all([
        getDocs(adminQuery).catch(e => { console.error('Admin Email query error:', e); return null; }),
        getDocs(userQuery).catch(e => { console.error('User Email query error:', e); return null; })
      ]);

      const foundByEmail = (adminSnapshot && !adminSnapshot.empty) || (userSnapshot && !userSnapshot.empty);
      
      if (foundByEmail) {
        return { success: true };
      }

      // Still not found
      await signOut(auth);
      return { success: false, message: 'Access denied. You are not registered in our database.' };
    } catch (error: any) {
      console.error('CRITICAL LOGIN ERROR:', error);
      let message = 'An error occurred during login.';
      
      if (error.code && error.code.startsWith('auth/')) {
        if (error.code === 'auth/user-not-found' || error.code === 'auth/wrong-password' || error.code === 'auth/invalid-credential') {
          message = 'Invalid email or password.';
        } else if (error.code === 'auth/too-many-requests') {
          message = 'Too many failed login attempts. Please try again later.';
        } else {
          message = `Authentication error: ${error.message}`;
        }
      } else if (error.code === 'permission-denied') {
        message = 'Access denied. Your Firestore Security Rules are blocking access to the database.';
      } else {
        message = error.message || 'An unexpected error occurred.';
      }
      
      return { success: false, message };
    }
  }

  async logout(): Promise<void> {
    await signOut(auth);
    this.router.navigate(['/login']);
  }

  async resetPassword(email: string): Promise<void> {
    const { sendPasswordResetEmail } = await import('firebase/auth');
    try {
      await sendPasswordResetEmail(auth, email);
    } catch (error: any) {
      console.error('Password reset error:', error);
      throw error;
    }
  }

  isLoggedIn(): boolean {
    return !!this.userSubject.value;
  }

  async getAdminDetails(uid: string): Promise<any> {
    try {
      const adminDocRef = doc(db, 'admins', uid);
      const adminDoc = await getDoc(adminDocRef);
      
      if (adminDoc.exists()) {
        return adminDoc.data();
      }
      
      return null;
    } catch (error) {
      console.error('CRITICAL: Failed to fetch admin details:', error);
      return null;
    }
  }
}
