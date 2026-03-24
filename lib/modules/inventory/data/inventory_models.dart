// Units enum — matches UnitEnum from API
enum UnitEnum {
  g,
  kg,
  oz,
  lb,
  ml,
  l,
  fl_oz,
  pcs,
  pack;

  String get label {
    switch (this) {
      case UnitEnum.g: return 'g';
      case UnitEnum.kg: return 'kg';
      case UnitEnum.oz: return 'oz';
      case UnitEnum.lb: return 'lb';
      case UnitEnum.ml: return 'ml';
      case UnitEnum.l: return 'l';
      case UnitEnum.fl_oz: return 'fl oz';
      case UnitEnum.pcs: return 'pcs';
      case UnitEnum.pack: return 'pack';
    }
  }

  String get value => name == 'fl_oz' ? 'fl_oz' : name;

  static UnitEnum fromString(String s) {
    return UnitEnum.values.firstWhere((e) => e.value == s, orElse: () => UnitEnum.pcs);
  }
}

class AddInventoryItemRequest {
  final String? productId;
  final String? barcode;
  final String? customName;
  final String? category;
  final String? notes;
  final String? location;
  final double amount;
  final UnitEnum unit;
  final DateTime expirationDate;

  AddInventoryItemRequest({
    this.productId,
    this.barcode,
    this.customName,
    this.category,
    this.notes,
    this.location,
    required this.amount,
    required this.unit,
    required this.expirationDate,
  });

  Map<String, dynamic> toJson() => {
    if (productId != null) 'product_id': productId,
    if (barcode != null) 'barcode': barcode,
    if (customName != null) 'custom_name': customName,
    if (category != null) 'category': category,
    if (notes != null) 'notes': notes,
    if (location != null) 'location': location,
    'amount': amount,
    'unit': unit.value,
    'expiration_date': expirationDate.toUtc().toIso8601String(),
  };
}

class UpdateInventoryItemRequest {
  final String? customName;
  final String? category;
  final String? notes;
  final String? location;
  final double? amount;
  final UnitEnum? unit;
  final DateTime? expirationDate;

  UpdateInventoryItemRequest({
    this.customName,
    this.category,
    this.notes,
    this.location,
    this.amount,
    this.unit,
    this.expirationDate,
  });

  Map<String, dynamic> toJson() => {
    if (customName != null) 'custom_name': customName,
    if (category != null) 'category': category,
    if (notes != null) 'notes': notes,
    if (location != null) 'location': location,
    if (amount != null) 'amount': amount,
    if (unit != null) 'unit': unit!.value,
    if (expirationDate != null)
      'expiration_date': expirationDate!.toUtc().toIso8601String(),
  };
}

class InventoryItem {
  final String id;
  final String userId;
  final String? productId;
  final String? barcode;
  final String? customName;
  final String? category;
  final String? notes;
  final String? location;
  final double amount;
  final String unit;
  final DateTime expirationDate;
  final String status;
  final DateTime addedAt;
  final DateTime updatedAt;

  InventoryItem({
    required this.id,
    required this.userId,
    this.productId,
    this.barcode,
    this.customName,
    this.category,
    this.notes,
    this.location,
    required this.amount,
    required this.unit,
    required this.expirationDate,
    required this.status,
    required this.addedAt,
    required this.updatedAt,
  });

  String get displayName => customName ?? barcode ?? 'Untitled';

  int get daysUntilExpiry {
    final now = DateTime.now();
    return expirationDate.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  bool get isExpired => daysUntilExpiry < 0;
  bool get isExpiringSoon => daysUntilExpiry >= 0 && daysUntilExpiry <= 3;

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
    id: json['id'],
    userId: json['user_id'],
    productId: json['product_id'],
    barcode: json['barcode'],
    customName: json['custom_name'],
    category: json['category'],
    notes: json['notes'],
    location: json['location'],
    amount: (json['amount'] as num).toDouble(),
    unit: json['unit'],
    expirationDate: DateTime.parse(json['expiration_date']),
    status: json['status'],
    addedAt: DateTime.parse(json['added_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}

class InventoryStats {
  final int totalActive;
  final int expiringToday;
  final int expiringIn3Days;
  final int expired;

  InventoryStats({
    required this.totalActive,
    required this.expiringToday,
    required this.expiringIn3Days,
    required this.expired,
  });

  factory InventoryStats.fromJson(Map<String, dynamic> json) => InventoryStats(
    totalActive: json['total_active'],
    expiringToday: json['expiring_today'],
    expiringIn3Days: json['expiring_in_3_days'],
    expired: json['expired'],
  );
}