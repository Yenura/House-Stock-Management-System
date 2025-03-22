// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  AuthStatus _status = AuthStatus.unknown;
  User? _user;
  String? _error;
  bool _loading = false;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    // Listen to auth state changes
    _authService.user.listen((user) {
      _user = user;
      _status =
          user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get loading => _loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isUnauthenticated => _status == AuthStatus.unauthenticated;

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithEmailAndPassword(email, password);
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to sign in';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  // Sign up with email and password
  Future<bool> signUpWithEmailAndPassword(
    String name,
    String email,
    String password, {
    String? dateOfBirth,
    String? country,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signUpWithEmailAndPassword(
        name,
        email,
        password,
        dateOfBirth: dateOfBirth,
        country: country,
      );
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to sign up';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  // Add household member
  Future<bool> addHouseholdMember(User newUser, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Make sure the current user is authenticated
      if (_user == null) {
        throw AuthException(message: 'You must be logged in to add household members');
      }
      
      // Add the new user with household member role
      List<String> roles = newUser.roles ?? ['user'];
      if (!roles.contains('household_member')) {
        roles.add('household_member');
      }
      
      // Create the user account
      await _authService.createHouseholdMember(
        name: newUser.name,
        email: newUser.email,
        password: password,
        photoUrl: newUser.photoUrl,
        dateOfBirth: newUser.dateOfBirth,
        country: newUser.country,
        roles: roles,
        parentUserId: _user!.id,
      );
      
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to add household member: ${e.toString()}';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to sign in with Google';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  // Sign in with Facebook
  Future<bool> signInWithFacebook() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithFacebook();
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to sign in with Facebook';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  // Sign in with Apple
  Future<bool> signInWithApple() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithApple();
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to sign in with Apple';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to reset password';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  // Sign out
  Future<bool> signOut() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signOut();
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to sign out';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}