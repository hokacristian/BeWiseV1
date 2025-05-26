// Buat file baru: history_model.dart

import 'package:bewise/data/models/product_model.dart';

class History {
  final int id;
  final int userId;
  final int productId;
  final String createdAt;
  final Product product;

  History({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
    required this.product,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'created_at': createdAt,
      'product': product.toJson(),
    };
  }
}