class MenuIngredient {
  final int id;
  final String name;
  final double amount;
  final String unit;

  MenuIngredient({required this.id, required this.name, required this.amount, required this.unit});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'unit': unit,
  };

  factory MenuIngredient.fromJson(Map<String, dynamic> json) => MenuIngredient(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 1,
    unit: json['unit'] ?? '',
  );
}

class MenuItem {
  final String id;
  final String userId;
  final String title;
  final List<MenuIngredient> ingredients;
  final DateTime createdAt;

  MenuItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.ingredients,
    required this.createdAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'] ?? '',
    userId: json['user_id'] ?? '',
    title: json['title'] ?? '',
    ingredients: (json['ingredients'] as List? ?? [])
        .map((e) => MenuIngredient.fromJson(e))
        .toList(),
    createdAt: DateTime.parse(json['created_at']),
  );
}

class CreateMenuItemRequest {
  final String title;
  final List<MenuIngredient> ingredients;

  CreateMenuItemRequest({required this.title, required this.ingredients});

  Map<String, dynamic> toJson() => {
    'title': title,
    'image': '',
    'ready_in_minutes': 1,
    'servings': 1,
    'calories': 0,
    'ingredients': ingredients.map((e) => e.toJson()).toList(),
    'steps': [
      {'number': 1, 'step': '-'}
    ],
  };
}