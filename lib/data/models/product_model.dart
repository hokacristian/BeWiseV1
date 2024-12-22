class Product {
  final int id;
  final String name;
  final String brand;
  final String photo;
  final int categoryProductId;
  final int nutritionFactId;
  final String barcode;
  final int priceA;
  final int priceB;
  final int labelId;
  final CategoryProduct? categoryProduct;
  final NutritionFact? nutritionFact;
  final Label? label;
  final List<Product>? rekomendasi;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.photo,
    required this.categoryProductId,
    required this.nutritionFactId,
    required this.barcode,
    required this.priceA,
    required this.priceB,
    required this.labelId,
    this.categoryProduct,
    this.nutritionFact,
    this.label,
    this.rekomendasi,
  });

  // Tambahkan copyWith
  Product copyWith({
  List<Product>? rekomendasi,
}) {
  return Product(
    id: id,
    name: name,
    brand: brand,
    photo: photo,
    categoryProductId: categoryProductId,
    nutritionFactId: nutritionFactId,
    barcode: barcode,
    priceA: priceA,
    priceB: priceB,
    labelId: labelId,
    categoryProduct: categoryProduct,
    nutritionFact: nutritionFact,
    label: label,
    rekomendasi: rekomendasi ?? this.rekomendasi,
  );
}


  factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] ?? 0,
    name: json['name'] ?? 'Unknown',
    brand: json['brand'] ?? 'Unknown',
    photo: json['photo'] ?? '',
    categoryProductId: json['category_product_id'] ?? 0,
    nutritionFactId: json['nutrition_fact_id'] ?? 0,
    barcode: json['barcode'] ?? '',
    priceA: json['price_a'] ?? 0,
    priceB: json['price_b'] ?? 0,
    labelId: json['label_id'] ?? 0,
    categoryProduct: json['categoryProduct'] != null
        ? CategoryProduct.fromJson(json['categoryProduct'])
        : null,
    nutritionFact: json['nutritionFact'] != null
        ? NutritionFact.fromJson(json['nutritionFact'])
        : null,
    label: json['label'] != null ? Label.fromJson(json['label']) : null,
    rekomendasi: json['rekomendasi'] != null
        ? (json['rekomendasi'] as List).map((item) => Product.fromJson(item)).toList()
        : [],
  );
}


  // Optional: Serialize back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'photo': photo,
      'category_product_id': categoryProductId,
      'nutrition_fact_id': nutritionFactId,
      'barcode': barcode,
      'price_a': priceA,
      'price_b': priceB,
      'label_id': labelId,
      'categoryProduct': categoryProduct?.toJson(),
      'nutritionFact': nutritionFact?.toJson(),
      'label': label?.toJson(),
      'rekomendasi': rekomendasi?.map((product) => product.toJson()).toList(),
    };
  }
}

class CategoryProduct {
  final int id;
  final String name;

  CategoryProduct({
    required this.id,
    required this.name,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }

  // Optional: Serialize back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class NutritionFact {
  final int id;
  final int energy;
  final double saturatedFat;
  final double sugar;
  final double sodium;
  final int protein;
  final int fiber;
  final int fruitVegetable;

  NutritionFact({
    required this.id,
    required this.energy,
    required this.saturatedFat,
    required this.sugar,
    required this.sodium,
    required this.protein,
    required this.fiber,
    required this.fruitVegetable,
  });

  factory NutritionFact.fromJson(Map<String, dynamic> json) {
    return NutritionFact(
      id: json['id'] ?? 0,
      energy: json['energy'] ?? 0,
      saturatedFat: (json['saturated_fat'] ?? 0).toDouble(),
      sugar: (json['sugar'] ?? 0).toDouble(),
      sodium: (json['sodium'] ?? 0).toDouble(),
      protein: json['protein'] ?? 0,
      fiber: json['fiber'] ?? 0,
      fruitVegetable: json['fruit_vegetable'] ?? 0,
    );
  }

  // Optional: Serialize back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'energy': energy,
      'saturated_fat': saturatedFat,
      'sugar': sugar,
      'sodium': sodium,
      'protein': protein,
      'fiber': fiber,
      'fruit_vegetable': fruitVegetable,
    };
  }
}

class Label {
  final int id;
  final String name;
  final String link;

  Label({
    required this.id,
    required this.name,
    required this.link,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      link: json['link'] ?? '',
    );
  }

  // Optional: Serialize back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'link': link,
    };
  }
}
