import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';

class UserException implements Exception {
  final String message;
  UserException(this.message);
}

class UserService {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  UserService({
    FirebaseFirestore? firestore,
    firebase_auth.FirebaseAuth? auth,
  }) : 
    _firestore = firestore ?? FirebaseFirestore.instance,
    _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  // Get current user data
  Future<User?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;
    
    try {
      final doc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (!doc.exists) return null;
      
      return User.fromMap(doc.data()!);
    } catch (e) {
      throw UserException('Failed to get user data');
    }
  }

  // Update user profile
  Future<User> updateProfile({
    required String userId,
    String? name,
    String? email,
    String? photoUrl,
    String? dateOfBirth,
    String? country,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw UserException('No authenticated user');
      }
      
      // Check if user is updating their own profile or has admin rights
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();
      final roles = userData?['roles'] ?? ['user'];
      
      if (userId != currentUser.uid && !(roles as List).contains('admin')) {
        throw UserException('Permission denied');
      }
      
      final updates = <String, dynamic>{};
      
      if (name != null) updates['name'] = name;
      if (dateOfBirth != null) updates['dateOfBirth'] = dateOfBirth;
      if (country != null) updates['country'] = country;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      
      // Update email in Firebase Auth if it's the current user's profile
      if (email != null && userId == currentUser.uid) {
        await currentUser.updateEmail(email);
        updates['email'] = email;
      }
      
      // Update display name in Firebase Auth if it's the current user's profile
      if (name != null && userId == currentUser.uid) {
        await currentUser.updateDisplayName(name);
      }
      
      // Update Firestore document
      await _firestore.collection('users').doc(userId).update(updates);
      
      // Get updated user data
      final updatedDoc = await _firestore.collection('users').doc(userId).get();
      return User.fromMap(updatedDoc.data()!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw UserException(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException('Failed to update profile');
    }
  }

  // Add household member (for household owners/admins)
  Future<User> addHouseholdMember({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw UserException('No authenticated user');
      }
      
      // Check if current user has admin rights
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();
      final roles = userData?['roles'] ?? ['user'];
      
      if (!(roles as List).contains('admin') && !(roles).contains('owner')) {
        throw UserException('Permission denied');
      }
      
      // Get household ID
      final householdId = userData?['householdId'];
      if (householdId == null) {
        throw UserException('No household found');
      }
      
      // Create new user in Firebase Auth
      final userCredential = await firebase_auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      
      if (userCredential.user == null) {
        throw UserException('Failed to create user');
      }
      
      // Update display name
      await userCredential.user!.updateDisplayName(name);
      
      // Create user document in Firestore
      final newUserData = {
        'id': userCredential.user!.uid,
        'name': name,
        'email': email,
        'roles': ['user'],
        'householdId': householdId,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': currentUser.uid,
      };
      
      await _firestore.collection('users').doc(userCredential.user!.uid).set(newUserData);
      
      // Add user to household members
      await _firestore.collection('households').doc(householdId).update({
        'members': FieldValue.arrayUnion([userCredential.user!.uid]),
      });
      
      // Sign back in as the original user
      await _auth.signInWithEmailAndPassword(
        email: userData?['email'],
        password: '', // We don't have the original password
      );
      
      return User.fromMap(newUserData);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw UserException(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException('Failed to add household member');
    }
  }

  // Get household members
  Future<List<User>> getHouseholdMembers() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw UserException('No authenticated user');
      }
      
      // Get current user data to find household ID
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();
      
      final householdId = userData?['householdId'];
      if (householdId == null) {
        throw UserException('No household found');
      }
      
      // Get household document
      final householdDoc = await _firestore.collection('households').doc(householdId).get();
      final householdData = householdDoc.data();
      
      if (householdData == null) {
        throw UserException('Household not found');
      }
      
      final members = householdData['members'] as List<dynamic>;
      
      // Get user documents for all members
      final userDocs = await Future.wait(
        members.map((memberId) => 
          _firestore.collection('users').doc(memberId.toString()).get()
        )
      );
      
      return userDocs
          .where((doc) => doc.exists && doc.data() != null)
          .map((doc) => User.fromMap(doc.data()!))
          .toList();
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException('Failed to get household members');
    }
  }

  // Update user role (admin only)
  Future<void> updateUserRole({
    required String userId,
    required List<String> roles,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw UserException('No authenticated user');
      }
      
      // Check if current user has admin rights
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();
      final currentRoles = userData?['roles'] ?? ['user'];
      
      if (!(currentRoles as List).contains('admin') && !(currentRoles).contains('owner')) {
        throw UserException('Permission denied');
      }
      
      // Get household ID
      final householdId = userData?['householdId'];
      if (householdId == null) {
        throw UserException('No household found');
      }
      
      // Check if target user is in the same household
      final targetUserDoc = await _firestore.collection('users').doc(userId).get();
      final targetUserData = targetUserDoc.data();
      
      if (targetUserData == null) {
        throw UserException('User not found');
      }
      
      if (targetUserData['householdId'] != householdId) {
        throw UserException('User is not in your household');
      }
      
      // Don't allow changing own role if you're the only admin
      if (userId == currentUser.uid && (currentRoles).contains('admin')) {
        // Check if there are other admins
        final usersSnapshot = await _firestore
            .collection('users')
            .where('householdId', isEqualTo: householdId)
            .where('roles', arrayContains: 'admin')
            .get();
        
        if (usersSnapshot.docs.length <= 1 && !roles.contains('admin')) {
          throw UserException('Cannot remove admin role from the only admin');
        }
      }
      
      // Update user role
      await _firestore.collection('users').doc(userId).update({
        'roles': roles,
      });
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException('Failed to update user role');
    }
  }

  // Remove household member (admin only)
  Future<void> removeHouseholdMember(String userId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw UserException('No authenticated user');
      }
      
      // Check if current user has admin rights
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();
      final roles = userData?['roles'] ?? ['user'];
      
      if (!(roles as List).contains('admin') && !(roles).contains('owner')) {
        throw UserException('Permission denied');
      }
      
      // Get household ID
      final householdId = userData?['householdId'];
      if (householdId == null) {
        throw UserException('No household found');
      }
      
      // Check if target user is in the same household
      final targetUserDoc = await _firestore.collection('users').doc(userId).get();
      final targetUserData = targetUserDoc.data();
      
      if (targetUserData == null) {
        throw UserException('User not found');
      }
      
      if (targetUserData['householdId'] != householdId) {
        throw UserException('User is not in your household');
      }
      
      // Don't allow removing yourself if you're the only admin
      if (userId == currentUser.uid && (roles).contains('admin')) {
        // Check if there are other admins
        final usersSnapshot = await _firestore
            .collection('users')
            .where('householdId', isEqualTo: householdId)
            .where('roles', arrayContains: 'admin')
            .get();
        
        if (usersSnapshot.docs.length <= 1) {
          throw UserException('Cannot remove the only admin');
        }
      }
      
      // Remove user from household
      await _firestore.collection('households').doc(householdId).update({
        'members': FieldValue.arrayRemove([userId]),
      });
      
      // Update user document
      await _firestore.collection('users').doc(userId).update({
        'householdId': null,
      });
      
      // Note: We're not deleting the user's Firebase Auth account
      // as they might want to join another household
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException('Failed to remove household member');
    }
  }

  // Map Firebase Auth error codes to user-friendly messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'requires-recent-login':
        return 'Please sign in again to update your profile';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'An unexpected error occurred';
    }
  }
}