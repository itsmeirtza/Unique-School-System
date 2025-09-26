import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String _errorMessage = '';
  String? _userRole; // 'parent' or 'teacher'

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  String? get userRole => _userRole;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await _loadUserRole();
      } else {
        _userRole = null;
      }
      notifyListeners();
    });
    
    // Load saved user role
    await _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      _userRole = prefs.getString('user_role_${_user!.uid}');
    }
  }

  Future<void> _saveUserRole(String role) async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role_${_user!.uid}', role);
      _userRole = role;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Sign in with email and password
  Future<bool> signInWithEmailPassword(String email, String password, String role) async {
    try {
      _setLoading(true);
      _setError('');

      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await _saveUserRole(role);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register with email and password
  Future<bool> registerWithEmailPassword(String email, String password, String role, Map<String, dynamic> userData) async {
    try {
      _setLoading(true);
      _setError('');

      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Update display name
        if (userData['name'] != null) {
          await result.user!.updateDisplayName(userData['name']);
        }
        
        await _saveUserRole(role);
        
        // Here you would typically save additional user data to Firestore
        // await _saveUserDataToFirestore(result.user!.uid, role, userData);
        
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError('');

      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _auth.signOut();
      _userRole = null;
    } catch (e) {
      _setError('Error signing out. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  // Get user-friendly error messages
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Check if email is verified
  bool get isEmailVerified => _user?.emailVerified ?? false;

  // Send email verification
  Future<bool> sendEmailVerification() async {
    try {
      if (_user != null && !_user!.emailVerified) {
        await _user!.sendEmailVerification();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to send verification email.');
      return false;
    }
  }

  // Reload user to check email verification status
  Future<void> reloadUser() async {
    try {
      await _user?.reload();
      _user = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      // Handle error silently
    }
  }
}