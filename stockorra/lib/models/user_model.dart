class User {
  final String id;
  final String name;
  final String email;
  final List<String> roles;
  final String? photoUrl;
  final String? dateOfBirth;
  final String? country;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    this.photoUrl,
    this.dateOfBirth,
    this.country,
  });

  // Create user from Firebase Auth User
  factory User.fromFirebase(
      dynamic firebaseUser, Map<String, dynamic>? userData) {
    return User(
      id: firebaseUser.uid,
      name: userData?['name'] ?? firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      roles: userData?['roles'] != null
          ? List<String>.from(userData?['roles'])
          : ['user'],
      photoUrl: userData?['photoUrl'] ?? firebaseUser.photoURL,
      dateOfBirth: userData?['dateOfBirth'],
      country: userData?['country'],
    );
  }

  // Convert User to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'dateOfBirth': dateOfBirth,
      'country': country,
    };
  }

  // Create User from Firestore document
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      roles: List<String>.from(map['roles'] ?? []),
      photoUrl: map['photoUrl'],
      dateOfBirth: map['dateOfBirth'],
      country: map['country'],
    );
  }

  // Create a copy of User with some fields updated
  User copyWith({
    String? id,
    String? name,
    String? email,
    List<String>? roles,
    String? photoUrl,
    String? dateOfBirth,
    String? country,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      photoUrl: photoUrl ?? this.photoUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      country: country ?? this.country,
    );
  }
}
