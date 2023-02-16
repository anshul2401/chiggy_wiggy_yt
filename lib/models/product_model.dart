class ProductModel {
  String name, description, price, shortDescription, weight, imgUrl, category;
  bool isAvailable;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.shortDescription,
    required this.weight,
    required this.imgUrl,
    required this.category,
    required this.isAvailable,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'shortDescription': shortDescription,
      'weight': weight,
      'imgUrl': imgUrl,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      shortDescription: json['shortDescription'],
      weight: json['weight'],
      imgUrl: json['imgUrl'],
      category: json['category'],
      isAvailable: json['isAvailable'],
    );
  }
}
