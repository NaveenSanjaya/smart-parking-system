import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/admin_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login
  Future<UserCredential> loginUser(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Change Password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");
      if (user.email == null) throw Exception("User has no email");
      
      // Re-authenticate user before changing password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, 
        password: currentPassword
      );
      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // Register User
  Future<UserCredential> registerUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Create user document
      if (result.user != null) {
        UserModel newUser = UserModel(
          userId: result.user!.uid,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          registrationDate: DateTime.now(),
          isActive: true,
        );
        
        await _firestore.collection('users').doc(result.user!.uid).set(newUser.toJson());
      }
      return result;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Register Admin (Optional, usually done via backend)
  Future<UserCredential> registerAdmin({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      if (result.user != null) {
        AdminModel newAdmin = AdminModel(
          adminId: result.user!.uid,
          adminName: name,
          email: email,
          role: 'admin',
          registrationDate: DateTime.now(),
        );
        
        await _firestore.collection('admins').doc(result.user!.uid).set(newAdmin.toJson());
      }
      return result;
    } catch (e) {
      throw Exception('Admin registration failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
