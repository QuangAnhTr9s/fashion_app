class FinalProduct {
  int id;
  String name;
  int price;
  String urlPhoto;
  String description;
  String sizes;
  int colors;

  FinalProduct(
      {required this.id,
      required this.name,
      required this.price,
      required this.urlPhoto,
      required this.description,
      required this.sizes,
      required this.colors});

  factory FinalProduct.fromJson(Map<String, dynamic> parsedJson) {
    return FinalProduct(
      id: parsedJson['id'] ?? '',
      name: parsedJson['name'] ?? '',
      price: parsedJson['price'] ?? '',
      urlPhoto: parsedJson['urlPhoto'] ?? '',
      description: parsedJson['description'] ?? '',
      sizes: parsedJson['sizes'] ?? '',
      colors: parsedJson['colors'] ?? '',
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
  String toString() {
    return 'FinalProduct{id: $id, name: $name, price: $price, urlPhoto: $urlPhoto, description: $description, sizes: $sizes, colors: $colors}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinalProduct &&
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
