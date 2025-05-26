import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  String _validateImageUrl(String url) {
    return url.isNotEmpty &&
            (url.startsWith('http://') || url.startsWith('https://'))
        ? url
        : 'https://via.placeholder.com/150'; // Placeholder jika gambar kosong
  }

  // Fungsi untuk mendapatkan warna berdasarkan label
  Color _getLabelColor(String labelName) {
    switch (labelName.toUpperCase()) {
      case 'A':
        return const Color(0xFF018242); // Hijau untuk A
      case 'B':
        return const Color(0xFF86BC31); // Hijau muda untuk B
      case 'C':
        return const Color(0xFFFFCD01); // Kuning untuk C
      case 'D':
        return const Color(0xFFEF8304); // Orange untuk D
      case 'E':
        return const Color(0xFFC44623); // Merah untuk E
      default:
        return Colors.grey; // Default warna abu-abu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // Sesuai dengan layout yang diinginkan
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300), // Border seperti di gambar
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bagian Gambar dengan Label
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0), // Jarak dari atas
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    _validateImageUrl(product.photo),
                    fit: BoxFit.contain,
                    height: 120,
                    width: 120,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 120,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      width: 120,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error_outline, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              if (product.label != null)
                Positioned(
                  top: 8,
                  left: 90,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _getLabelColor(product.label!.name), // Dynamic color berdasarkan label
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      product.label!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Informasi Produk
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Brand
                Text(
                  product.brand,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Nama Produk
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Harga dalam bentuk button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                          'Rp ${_formatPrice(product.priceA)} - Rp ${_formatPrice(product.priceB)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

}