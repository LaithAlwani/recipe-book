import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  Map<String, dynamic> toFireStore() {
    return {"email": email, "displayName": displayName, "photoUrl": photoUrl};
  }

  factory AppUser.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    //get data from snapshot
    final data = snapshot.data()!;

    AppUser user = AppUser(
      uid: snapshot.id,
      email: data["email"],
      displayName: data["displayName"],
      photoUrl: data["photoUrl"],
    );

    return user;
  }
}
