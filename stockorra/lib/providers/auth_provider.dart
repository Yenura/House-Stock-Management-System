// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:stockorra/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  String? _error;
  bool _loading = false;

  User? get currentUser => _currentUser;
  String? get error => _error;
  bool get loading => _loading;

  AuthProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((firebase_auth.User? firebaseUser) async {
      if (firebaseUser != null) {
        // Fetch user data from Firestore
        final doc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists && doc.data() != null) {
          _currentUser = User.fromMap({
            'id': doc.id,
            ...doc.data()!,
          });
        }
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        if (doc.exists && doc.data() != null) {
          _currentUser = User.fromMap({
            'id': doc.id,
            ...doc.data()!,
          });
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create user document in Firestore
        final user = User(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          roles: ['owner'],
        );

        await _firestore.collection('users').doc(user.id).set(user.toMap());
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserProfile(User updatedUser) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      await _firestore
          .collection('users')
          .doc(updatedUser.id)
          .update(updatedUser.toMap());
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addHouseholdMember(User newUser, String password) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      // Create auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: newUser.email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create user document in Firestore with proper type casting
        final user = User(
          id: userCredential.user!.uid,
          name: newUser.name,
          email: newUser.email,
          roles: ['household_member'],
          photoUrl: newUser.photoUrl,
          dateOfBirth: newUser.dateOfBirth,
          country: newUser.country,
        );

        // Add user to Firestore using toMap() method
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toMap());

        // Add user to household
        if (_currentUser != null) {
          await _firestore.collection('households').doc(_currentUser!.id).set({
            'owner': _currentUser!.id,
            'members': FieldValue.arrayUnion([userCredential.user!.uid]),
          }, SetOptions(merge: true));
        }

        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<List<User>> getHouseholdMembers() async {
    if (_currentUser == null) return [];

    try {
      // Get the household document
      final householdDoc =
          await _firestore.collection('households').doc(_currentUser!.id).get();

      if (!householdDoc.exists) {
        // Create household if it doesn't exist
        await _firestore.collection('households').doc(_currentUser!.id).set({
          'owner': _currentUser!.id,
          'members': [_currentUser!.id],
        });
        return [_currentUser!];
      }

      // Get member IDs from the household document
      final memberIds =
          List<String>.from(householdDoc.data()?['members'] ?? []);

      // Fetch each member's data
      final membersData = await Future.wait(
          memberIds.map((id) => _firestore.collection('users').doc(id).get()));

      // Convert to User objects
      return membersData
          .where((doc) => doc.exists && doc.data() != null)
          .map((doc) => User.fromMap({
                'id': doc.id,
                ...doc.data()!,
              }))
          .toList();
    } catch (e) {
      _error = 'Failed to fetch household members';
      notifyListeners();
      return [];
    }
  }

  // Update user details
  Future<bool> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestore.collection('users').doc(userId).update(updatedData);
      _currentUser = User.fromMap(updatedData);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update user';
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Delete user and remove from household
  Future<bool> deleteUser(String userId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Remove from household first
      if (_currentUser != null) {
        await _firestore.collection('households').doc(_currentUser!.id).update({
          'members': FieldValue.arrayRemove([userId])
        });
      }

      // Delete user document
      await _firestore.collection('users').doc(userId).delete();

      // Delete auth user (only if current user is owner)
      if (_currentUser?.roles.contains('owner') == true) {
        final user = await _auth.currentUser;
        if (user != null) {
          await user.delete();
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete user';
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
