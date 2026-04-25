class RecipeRecommendation {
  final int spoonacularId;
  final String title;
  final String image;
  final double matchScore;

  const RecipeRecommendation({
    required this.spoonacularId,
    required this.title,
    required this.image,
    this.matchScore = 0.0
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
