class Product {
  int id;
  String name;
  int price;
  List<String> urlPhoto;
  String store;
  String description;
  String typeByGender;
  String category;
  String date;
  List<String> sizes = [];
  List<int> colors = [];
  int favoriteCount = 0;
  List<String>? comments = [];

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.urlPhoto,
    required this.store,
    required this.description,
    required this.typeByGender,
    required this.category,
    required this.date,
    required this.sizes,
    required this.colors,
    this.favoriteCount = 0,
    this.comments,
  });

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
      id: parsedJson['id'] ?? '',
      name: parsedJson['name'] ?? '',
      price: parsedJson['price'] ?? '',
      store: parsedJson['store'] ?? '',
      description: parsedJson['description'] ?? '',
      typeByGender: parsedJson['typeByGender'] ?? '',
      category: parsedJson['category'] ?? '',
      date: parsedJson['date'] ?? '',
      urlPhoto: List<String>.from(parsedJson['urlPhoto'] ?? ['']),
      sizes: List<String>.from(parsedJson['sizes'] ?? ['']),
      colors: List<int>.from(parsedJson['colors'] ?? ['']),
      favoriteCount: parsedJson['favoriteCount'] ?? 0,
      comments: List<String>.from(parsedJson['comments'] ?? ['']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'store': store,
      'description': description,
      'typeByGender': typeByGender,
      'category': category,
      'date': date,
      'urlPhoto': urlPhoto,
      'sizes': sizes,
      'colors': colors,
      'favoriteCount': favoriteCount,
      'comments': comments,
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, favoriteCount: $favoriteCount}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
