String idColumn = "idColumn";
String nameColumn = "nameColumn";
String categoryColumn = "categoryColumn";
String timeColumn = "timeColumn";
String difficultyColumn = "difficultyColumn";
String ingredientsColumn = "ingredientsColumn";
String prepareColumn = "prepareColumn";
String portionsColumn = "portionsColumn";
String recipeTable = "recipeTable";

class Recipe {
  Recipe({
    this.id,
    required this.name,
    required this.category,
    required this.time,
    required this.difficulty,
    required this.ingredients,
    required this.prepare,
    required this.portions,
  });

  int? id;
  String? name;
  String? category;
  String? time;
  String? difficulty;
  String? ingredients;
  String? prepare;
  double? portions;

  Recipe.fromMap(Map<String, dynamic> map)
    : id = map[idColumn],
      name = map[nameColumn],
      category = map[categoryColumn],
      time = map[timeColumn],
      difficulty = map[difficultyColumn],
      ingredients = map[ingredientsColumn],
      prepare = map[prepareColumn],
      portions = map[portionsColumn] is double
          ? map[portionsColumn]
          : double.tryParse(map[portionsColumn].toString());

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      categoryColumn: category,
      timeColumn: time,
      difficultyColumn: difficulty,
      ingredientsColumn: ingredients,
      prepareColumn: prepare,
      portionsColumn: portions,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Concat (id: $id, name: $name, category: $category, time: $time, difficulty: $difficulty, ingredients: $ingredients, prepare: $prepare, portion: $portions)";
  }
}
