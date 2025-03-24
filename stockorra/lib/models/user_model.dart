class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? dateOfBirth;
  final String? country;
  final List<String>? roles;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.dateOfBirth,
    this.country,
    this.roles,
  });

  // Create user from Firebase Auth User
  factory User.fromFirebase(dynamic firebaseUser, Map<String, dynamic>? userData) {
    return User(
      id: firebaseUser.uid,
      name: userData?['name'] ?? firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      photoUrl: userData?['photoUrl'] ?? firebaseUser.photoURL,
      dateOfBirth: userData?['dateOfBirth'],
      country: userData?['country'],
      roles: userData?['roles'] != null 
          ? List<String>.from(userData?['roles'])
          : ['user'],
    );
  }

  // Convert User to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'roles': roles,
    };
  }

  // Create User from Firestore document
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      dateOfBirth: map['dateOfBirth'],
      country: map['country'],
      roles: map['roles'] != null ? List<String>.from(map['roles']) : ['user'],
    );
  }

  // Create a copy of User with some fields updated
  User copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? dateOfBirth,
    String? country,
    List<String>? roles,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      country: country ?? this.country,
      roles: roles ?? this.roles,
    );
  }
}