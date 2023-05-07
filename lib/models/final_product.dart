class FinalProduct {
  int id;
  String name;
  int price;
  String urlPhoto;
  String description;
  String sizes;
  int colors;
  int quantity;
  String purchasedTime;

  FinalProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.urlPhoto,
    required this.description,
    required this.sizes,
    required this.colors,
    required this.quantity,
    // this.quantity = 1,
    this.purchasedTime = '',
  });

  factory FinalProduct.fromJson(Map<String, dynamic> parsedJson) {
    return FinalProduct(
      id: parsedJson['id'] ?? '',
      name: parsedJson['name'] ?? '',
      price: parsedJson['price'] ?? '',
      urlPhoto: parsedJson['urlPhoto'] ?? '',
      description: parsedJson['description'] ?? '',
      sizes: parsedJson['sizes'] ?? '',
      colors: parsedJson['colors'] ?? '',
      quantity: parsedJson['quantity'] ?? '',
      // quantity: parsedJson['quantity'] != null ? int.parse(parsedJson['quantity']) : 1,
      purchasedTime: parsedJson['purchasedTime'] ?? '',
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
      'quantity': quantity,
      'purchasedTime': purchasedTime,
    };
  }

  @override
  String toString() {
    return 'FinalProduct{id: $id, name: $name, time: $purchasedTime.}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinalProduct &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          sizes == other.sizes &&
          colors == other.colors;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      sizes.hashCode ^
      colors.hashCode;
}
