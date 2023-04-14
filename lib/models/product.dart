class Product {
  int id;
  String name;
  int price;
  List<String> urlPhoto;
  String description;
  List<String> sizes = [];
  List<int> colors = [];

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.urlPhoto,
      required this.description,
      required this.sizes,
      required this.colors});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
      id: parsedJson['id'] ?? '',
      name: parsedJson['name'] ?? '',
      price: parsedJson['price'] ?? '',
      description: parsedJson['description'] ?? '',
      urlPhoto: List<String>.from(parsedJson['urlPhoto'] ?? ['']),
      sizes: List<String>.from(parsedJson['sizes'] ?? ['']),
      colors: List<int>.from(parsedJson['colors'] ?? ['']),
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
    };
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          urlPhoto == other.urlPhoto &&
          description == other.description &&
          sizes == other.sizes &&
          colors == other.colors;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      urlPhoto.hashCode ^
      description.hashCode ^
      sizes.hashCode ^
      colors.hashCode;
}
