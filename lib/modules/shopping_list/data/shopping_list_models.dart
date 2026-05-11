class ShoppingListItem {
  final String id;
  final String userId;
  final String name;
  final String? category;
  final double amount;
  final String unit;
  final bool isChecked;
  final String source;
  final String? sourceId;
  final DateTime addedAt;

  ShoppingListItem({
    required this.id,
    required this.userId,
    required this.name,
    this.category,
    required this.amount,
    required this.unit,
    required this.isChecked,
    required this.source,
    this.sourceId,
    required this.addedAt,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      ShoppingListItem(
        id: json['id'],
        userId: json['user_id'],
        name: json['name'],
        category: json['category'],
        amount: (json['amount'] as num).toDouble(),
        unit: json['unit'] ?? 'pcs',
        isChecked: json['is_checked'] ?? false,
        source: json['source'] ?? 'manual',
        sourceId: json['source_id'],
        addedAt: DateTime.parse(json['added_at']),
      );

  ShoppingListItem copyWith({bool? isChecked}) => ShoppingListItem(
        id: id,
        userId: userId,
        name: name,
        category: category,
        amount: amount,
        unit: unit,
        isChecked: isChecked ?? this.isChecked,
        source: source,
        sourceId: sourceId,
        addedAt: addedAt,
      );
}

class AddShoppingItemRequest {
  final String name;
  final String? category;
  final double amount;
  final String unit;

  AddShoppingItemRequest({
    required this.name,
    this.category,
    required this.amount,
    required this.unit,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (category != null) 'category': category,
        'amount': amount,
        'unit': unit,
        'source': 'manual',
      };
}