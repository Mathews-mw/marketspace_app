class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final bool isNew;
  final bool acceptTrade;
  final String userId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isNew,
    required this.acceptTrade,
    required this.userId,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  set id(String id) {
    this.id = id;
  }

  set name(String name) {
    this.name = name;
  }

  set description(String description) {
    this.description = description;
  }

  set price(int price) {
    this.price = price;
  }

  set isNew(bool isNew) {
    this.isNew = isNew;
  }

  set acceptTrade(bool acceptTrade) {
    this.acceptTrade = acceptTrade;
  }

  set userId(String userId) {
    this.userId = userId;
  }

  set isActive(bool isActive) {
    this.isActive = isActive;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  set updatedAt(DateTime? updatedAt) {
    this.updatedAt = updatedAt;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      isNew: json['is_new'] as bool,
      acceptTrade: json['accept_trade'] as bool,
      userId: json['user_id'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, isNew: $isNew, acceptTrade: $acceptTrade, userId: $userId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
