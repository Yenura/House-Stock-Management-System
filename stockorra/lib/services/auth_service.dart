// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/user_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException({required this.message});
}

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore get firestore => _firestore;

  
  // Stream of user objects based on Firebase auth state
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      
      try {
        final userData = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
            
        return User.fromFirebase(firebaseUser, userData.data());
      } catch (e) {
        print('Error getting user data: $e');
        return null;
      }
    });
  }
  
  // Sign in with email and password
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final userData = await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .get();
          
      return User.fromFirebase(result.user!, userData.data());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
  
  // Sign up with email and password
  Future<User> signUpWithEmailAndPassword(
    String name,
    String email,
    String password, {
    String? dateOfBirth,
    String? country,
  }) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update user profile
      await result.user!.updateDisplayName(name);
      
      // Create user document
      final user = User(
        id: result.user!.uid,
        name: name,
        email: email,
        dateOfBirth: dateOfBirth,
        country: country,
        roles: ['user'],
      );
      
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
  
  // Create household member
  Future<User> createHouseholdMember({
    required String name,
    required String email,
    required String password,
    required String parentUserId,
    String? photoUrl,
    String? dateOfBirth,
    String? country,
    List<String>? roles,
  }) async {
    try {
      // Create the account
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update user profile
      await result.user!.updateDisplayName(name);
      
      // Create user document
      final user = User(
        id: result.user!.uid,
        name: name,
        email: email,
        photoUrl: photoUrl,
        dateOfBirth: dateOfBirth,
        country: country,
        roles: roles ?? ['user', 'household_member'],
      );
      
      // Save user in Firestore
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      
      // Add user to household
      await _firestore.collection('households').doc(parentUserId).update({
        'members': FieldValue.arrayUnion([user.id]),
      });
      
      // Sign out the newly created user to return to parent user
      await _firebaseAuth.signOut();
      
      // Sign in the parent user again
      // You may need to store parent credentials temporarily or use a different approach
      // This is just one possible approach
      
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

    // Get user details
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data()!;
      } else {
        throw AuthException(message: 'User not found');
      }
    } catch (e) {
      throw AuthException(message: 'Failed to get user details: $e');
    }
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw AuthException(message: 'Failed to update user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      // Delete user from Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Optionally delete from FirebaseAuth as well if the currently logged-in user is the same
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        await currentUser.delete();
      }
    } catch (e) {
      throw AuthException(message: 'Failed to delete user: $e');
    }
  }

  
  // Sign in with Google
  Future<User> signInWithGoogle() async {
    // Implement Google sign-in
    throw AuthException(message: 'Not implemented');
  }
  
  // Sign in with Facebook
  Future<User> signInWithFacebook() async {
    // Implement Facebook sign-in
    throw AuthException(message: 'Not implemented');
  }
  
  // Sign in with Apple
  Future<User> signInWithApple() async {
    // Implement Apple sign-in
    throw AuthException(message: 'Not implemented');
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
  
  // Handle Firebase Auth errors
  String _handleFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email is already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return e.message ?? 'An error occurred';
    }
  }
}