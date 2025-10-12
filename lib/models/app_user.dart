import 'package:cloud_firestore/cloud_firestore.dart';

// class AppUser {
//   AppUser({
//     required this.uid,
//     required this.email,
//     required this.displayName,
//     this.photoUrl,
//   });

//   final String uid;
//   final String email;
//   final String displayName;
//   final String? photoUrl;

//   Map<String, dynamic> toFireStore() {
//     return {"email": email, "displayName": displayName, "photoUrl": photoUrl};
//   }

//   factory AppUser.fromFireStore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   ) {
//     //get data from snapshot
//     final data = snapshot.data()!;

//     AppUser user = AppUser(
//       uid: snapshot.id,
//       email: data["email"],
//       displayName: data["displayName"],
//       photoUrl: data["photoUrl"],
//     );

//     return user;
//   }
// }


class AppUser {
  AppUser({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.bio,
    this.location,
    this.isVerified = false,
    this.role = "user",
    Timestamp? createdAt,
    Timestamp? updatedAt,
    this.followers = const [],
    this.following = const [],
    this.favorites = const [],
    this.recipes = const [],
    this.badges = const [],
    this.preferences,
    this.stats,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? bio;
  final String? location;
  final bool isVerified;
  final String role;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  final List<String> followers;     // user IDs
  final List<String> following;     // user IDs
  final List<String> favorites;     // recipe IDs
  final List<String> recipes;       // recipe IDs created by user
  final List<String> badges;        // achievement or status icons

  final Map<String, dynamic>? preferences; // app settings (theme, notifications, etc.)
  final Map<String, dynamic>? stats;       // analytics info (views, likes, etc.)


  // ---------- Serialization ----------

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return AppUser(
      uid: snapshot.id ,
      displayName: data['displayName'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      bio: data['bio'] ,
      location: data['location'],
      isVerified: data['isVerified'] ?? false,
      role: data['role'] ?? 'user',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      favorites: List<String>.from(data['favorites'] ?? []),
      recipes: List<String>.from(data['recipes'] ?? []),
      badges: List<String>.from(data['badges'] ?? []),
      preferences: data['preferences'] != null
          ? Map<String, dynamic>.from(data['preferences'])
          : null,
      stats: data['stats'] != null
          ? Map<String, dynamic>.from(data['stats'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'location': location,
      'isVerified': isVerified,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'followers': followers,
      'following': following,
      'favorites': favorites,
      'recipes': recipes,
      'badges': badges,
      'preferences': preferences,
      'stats': stats,
    };
  }

  AppUser copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? bio,
    String? location,
    bool? isVerified,
    String? role,
    Timestamp? updatedAt,
    List<String>? followers,
    List<String>? following,
    List<String>? favorites,
    List<String>? recipes,
    List<String>? badges,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? stats,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      isVerified: isVerified ?? this.isVerified,
      role: role ?? this.role,
      createdAt: createdAt,
      updatedAt: updatedAt ?? Timestamp.now(),
      followers: followers ?? this.followers,
      following: following ?? this.following,
      favorites: favorites ?? this.favorites,
      recipes: recipes ?? this.recipes,
      badges: badges ?? this.badges,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }
}

