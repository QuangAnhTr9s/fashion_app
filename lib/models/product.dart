class Product {
  int id;
  String name;
  int price;
  List<String> urlPhoto;
  String description;
  List<String> sizes = [];
  List<int> colors = [];
  int favoriteCount = 0;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.urlPhoto,
      required this.description,
      required this.sizes,
      required this.colors,
      this.favoriteCount = 0});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
      id: parsedJson['id'] ?? '',
      name: parsedJson['name'] ?? '',
      price: parsedJson['price'] ?? '',
      description: parsedJson['description'] ?? '',
      urlPhoto: List<String>.from(parsedJson['urlPhoto'] ?? ['']),
      sizes: List<String>.from(parsedJson['sizes'] ?? ['']),
      colors: List<int>.from(parsedJson['colors'] ?? ['']),
      favoriteCount: parsedJson['favoriteCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'urlPhoto': urlPhoto,
      'sizes': sizes,
      'colors': colors,
      'favoriteCount': favoriteCount,
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
