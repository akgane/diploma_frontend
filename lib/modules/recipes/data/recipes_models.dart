class RecipeRecommendation {
  final int spoonacularId;
  final String title;
  final String image;
  final double matchScore;

  const RecipeRecommendation({
    required this.spoonacularId,
    required this.title,
    required this.image,
    this.matchScore = 0.0,
  });

  factory RecipeRecommendation.fromJson(Map<String, dynamic> json) {
    return RecipeRecommendation(
      spoonacularId: (json['spoonacular_id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      matchScore: (json['match_score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class RecipeIngredient {
  final int id;
  final String name;
  final double amount;
  final String unit;

  const RecipeIngredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      RecipeIngredient(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: (json['name'] ?? '').toString(),
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        unit: (json['unit'] ?? '').toString(),
      );
}

class RecipeStep {
  final int number;
  final String step;

  const RecipeStep({required this.number, required this.step});

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
    number: (json['number'] as num?)?.toInt() ?? 0,
    step: (json['step'] ?? '').toString(),
  );
}

class RecipeDetail {
  final int spoonacularId;
  final String title;
  final String? image;
  final int? readyInMinutes;
  final int? servings;
  final double? calories;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  const RecipeDetail({
    required this.spoonacularId,
    required this.title,
    this.image,
    this.readyInMinutes,
    this.servings,
    this.calories,
    required this.ingredients,
    required this.steps,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) => RecipeDetail(
    spoonacularId: (json['spoonacular_id'] as num?)?.toInt() ?? 0,
    title: (json['title'] ?? '').toString(),
    image: json['image']?.toString(),
    readyInMinutes: (json['ready_in_minutes'] as num?)?.toInt(),
    servings: (json['servings'] as num?)?.toInt(),
    calories: (json['calories'] as num?)?.toDouble(),
    ingredients: (json['ingredients'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(RecipeIngredient.fromJson)
        .toList(),
    steps: (json['steps'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(RecipeStep.fromJson)
        .toList(),
  );
}