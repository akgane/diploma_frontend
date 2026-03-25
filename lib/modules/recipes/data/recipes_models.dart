class RecipeRecommendation {
  final int spoonacularId;
  final String title;
  final String image;

  const RecipeRecommendation({
    required this.spoonacularId,
    required this.title,
    required this.image,
  });

  factory RecipeRecommendation.fromJson(Map<String, dynamic> json) {
    return RecipeRecommendation(
      spoonacularId: (json['spoonacular_id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
    );
  }
}
