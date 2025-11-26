import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trabalho_3/model/recipe_model.dart';

class FirestoreService {
  final CollectionReference recipes = FirebaseFirestore.instance.collection(
    'recipes',
  );

  Future<void> create(Recipe recipe) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final recipeData = recipe.toFirestore();
    recipeData['userId'] = uid;
    return recipes.add(recipeData);
  }

  Stream<List<Recipe>> read() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return recipes
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Recipe.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
        });
  }

  Future<void> update(String docID, Recipe recipe) async {
    final data = recipe.toFirestore();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    data['userId'] = uid;
    return recipes.doc(docID).update(data);
  }

  Future<void> delete(String docID) {
    return recipes.doc(docID).delete();
  }
}