class StorageRecommendationRequest {
  final String name;
  final String? category;
  final String? location;
  final String? state;
  final String? language;

  StorageRecommendationRequest({
    required this.name,
    this.category,
    this.location,
    this.state,
    this.language,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    if (category != null) 'category': category,
    if (location != null) 'location': location,
    if (state != null) 'state': state,
    if (language != null) 'language': language,
  };
}

class StorageRecommendationOption {
  final String location;
  final String state;
  final int recommendedDays;
  final int? minDays;
  final int? maxDays;

  StorageRecommendationOption({
    required this.location,
    required this.state,
    required this.recommendedDays,
    this.minDays,
    this.maxDays,
  });

  factory StorageRecommendationOption.fromJson(Map<String, dynamic> json) =>
      StorageRecommendationOption(
        location: json['location'] ?? '',
        state: json['state'] ?? '',
        recommendedDays: (json['recommended_days'] as num).toInt(),
        minDays: (json['min_days'] as num?)?.toInt(),
        maxDays: (json['max_days'] as num?)?.toInt(),
      );

  String get locationLabel {
    const map = {
      'fridge': '🧊 Fridge',
      'freezer': '❄️ Freezer',
      'pantry': '📦 Pantry',
      'room': '🏠 Room temperature',
    };
    return map[location] ?? location;
  }

  String get stateLabel {
    const map = {
      'whole': 'whole',
      'cut': 'cut',
      'raw': 'raw',
      'cooked': 'cooked',
      'opened': 'opened',
      'unopened': 'unopened',
      'fresh': 'fresh',
    };
    return map[state] ?? state;
  }

  String get daysLabel {
    if (minDays != null && maxDays != null && minDays != maxDays) {
      return '$minDays–$maxDays days';
    }
    return '$recommendedDays days';
  }
}

class StorageRecommendationResponse {
  final String input;
  final String canonicalName;
  final String displayName;
  final String category;
  final int? recommendedDays;
  final int? minDays;
  final int? maxDays;
  final String? location;
  final String? state;
  final bool requiresClarification;
  final List<StorageRecommendationOption> options;

  StorageRecommendationResponse({
    required this.input,
    required this.canonicalName,
    required this.displayName,
    required this.category,
    this.recommendedDays,
    this.minDays,
    this.maxDays,
    this.location,
    this.state,
    required this.requiresClarification,
    required this.options,
  });

  factory StorageRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      StorageRecommendationResponse(
        input: json['input'] ?? '',
        canonicalName: json['canonical_name'] ?? '',
        displayName: json['display_name'] ?? '',
        category: json['category'] ?? '',
        recommendedDays: (json['recommended_days'] as num?)?.toInt(),
        minDays: (json['min_days'] as num?)?.toInt(),
        maxDays: (json['max_days'] as num?)?.toInt(),
        location: json['location'],
        state: json['state'],
        requiresClarification: json['requires_clarification'] ?? false,
        options: (json['options'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(StorageRecommendationOption.fromJson)
            .toList(),
      );
}