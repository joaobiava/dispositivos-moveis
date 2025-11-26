class Recipe {
  String? id;
  String? userId;
  String name;
  String category;
  String time;
  String ingredients;
  String difficulty;
  String prepare;
  String portions;
  String? image;

  Recipe({
    this.id,
    this.userId,
    required this.name,
    required this.category,
    required this.time,
    required this.ingredients,
    required this.difficulty,
    required this.prepare,
    required this.portions,
    this.image,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "userId": userId,
      "name": name,
      "category": category,
      "time": time,
      "ingredients": ingredients,
      "difficulty": difficulty,
      "prepare": prepare,
      "portions": portions,
      "image": image,
    };
  }

  factory Recipe.fromFirestore(String docId, Map<String, dynamic> json) {
    return Recipe(
      id: docId,
      userId: json['userId'],
      name: json["name"],
      category: json["category"],
      time: json["time"],
      ingredients: json["ingredients"],
      difficulty: json["difficulty"],
      prepare: json["prepare"],
      portions: json["portions"],
      image: json["image"],
    );
  }
}
