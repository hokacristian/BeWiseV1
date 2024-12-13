import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/presentation/page/product/category_product_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> _fetchUserFuture;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _fetchUserFuture = authProvider.fetchUserData(); // Future diinisialisasi di initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: FutureBuilder<void>(
        future: _fetchUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeleton(); // Menampilkan skeleton saat data sedang diambil
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return _buildContent(context); // Konten utama jika Future berhasil
          }
        },
      ),
    );
  }

  // Konten utama jika data berhasil dimuat
  Widget _buildContent(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👋 Haloo!',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  user?.avatarLink ?? 'https://example.com/default-avatar.png',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Cari apapun',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Categories
          const Text(
            'Kategori',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Grid View for Categories
          Expanded(
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              children: [
                _buildCategoryButton(context, 'Teh', 1, Icons.local_drink),
                _buildCategoryButton(context, 'Soda', 2, Icons.local_cafe),
                _buildCategoryButton(context, 'Susu', 3, Icons.free_breakfast),
                _buildCategoryButton(context, 'Snack', 4, Icons.fastfood),
                _buildCategoryButton(context, 'Roti', 5, Icons.bakery_dining),
                _buildCategoryButton(context, 'Semua', 0, Icons.all_inclusive),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Skeleton Loading saat data sedang dimuat
  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 100,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 150,
                      height: 25,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              Skeletonizer(
                enabled: true,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Skeleton Search Bar
          Skeletonizer(
            enabled: true,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Skeleton Categories Title
          Skeletonizer(
            enabled: true,
            child: Container(
              height: 20,
              width: 100,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 10),

          // Skeleton Grid for Categories
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemCount: 6, // Jumlah kategori skeleton
              itemBuilder: (context, index) {
                return Skeletonizer(
                  enabled: true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Button untuk kategori
  Widget _buildCategoryButton(
      BuildContext context, String name, int categoryId, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductPage(categoryId: categoryId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
