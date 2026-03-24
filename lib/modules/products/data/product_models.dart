class ProductModel {
  final String id;
  final String? barcode;
  final String name;
  final String? brand;
  final String? imageUrl;
  final String? quantity;
  final String source;
  final bool isVerified;

  ProductModel({
    required this.id,
    this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.quantity,
    required this.source,
    required this.isVerified,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    barcode: json['barcode'],
    name: json['name'],
    brand: json['brand'],
    imageUrl: json['image_url'],
    quantity: json['quantity'],
    source: json['source'],
    isVerified: json['is_verified'],
  );
}