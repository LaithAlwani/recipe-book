import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/utils/dummy_data.dart';
// where your dummyRecipes and dummyUsers live

class FirestoreSeeder {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Future<void> seedData() async {
    print('🌱 Starting Firestore seeding...');

    // Seed Users
    for (final user in dummyUsers) {
      print('🌱 Starting Firestore Users...');

      await firestore.collection('users').doc(user['uid'] as String).set(user);
    }

    // 2️⃣ Seed Recipes
    final recipeBatch = firestore.batch();
    for (final recipe in dummyRecipes) {
      await firestore
          .collection('recipes')
          .doc(recipe['id'] as String)
          .set(recipe);
    }
    await recipeBatch.commit();
    print('✅ Recipes seeded!');

    print('🎉 Firestore seeding complete!');
  }
}
