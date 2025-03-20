import 'package:bewise/core/constans/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:bewise/presentation/page/home/search_page.dart';
import 'package:flutter/scheduler.dart';
import 'package:bewise/presentation/widgets/product_card.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/page/product/category_product_page.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:bewise/presentation/page/product/category_all_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<void> _fetchUserFuture;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _fetchUserFuture = authProvider.fetchUserData();

    // Menunda fetchTopChoices sampai build selesai
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchTopChoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brokenWhite,
      body: FutureBuilder<void>(
        future: _fetchUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Menampilkan skeleton saat data sedang diambil
            return _buildSkeleton();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Konten utama jika Future berhasil
            return _buildContent(context);
          }
        },
      ),
    );
  }

  /// Konten utama setelah data user berhasil dimuat
  Widget _buildContent(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          // Kategori
          _buildCategorySection(),
          // Banner
          _buildBanner(),

          const SizedBox(height: 20),

          // Teks "Pilihan Terbaik"
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Pilihan Terbaik',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Carousel Pilihan Terbaik
          if (productProvider.isLoadingTopChoices)
            const Center(child: CircularProgressIndicator())
          else if (productProvider.errorMessageTopChoices != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(productProvider.errorMessageTopChoices!),
            )
          else
            _buildCarousel(productProvider.topChoices),

          // Spasi bawah agar tidak tertimpa Bottom Navigation
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Header dengan nama user, avatar, dan search bar
  Widget _buildHeader() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Salam dan Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '👋 Haloo!',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.firstName ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
          // Search bar
          _buildSearchBar(),
        ],
      ),
    );
  }

  /// Search Bar (TextField non-aktif, navigasi ke SearchPage jika di-tap)
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
      },
      child: TextField(
        enabled: false, // Nonaktifkan input
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: 'Cari apapun',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan kategori (Snack, Roti, Teh, Soda, dll.)
  Widget _buildCategorySection() {
    // List kategori dengan ID, nama, dan path gambar
    final List<Map<String, dynamic>> categories = [
    {'id': 7, 'name': 'Teh', 'image': 'assets/img/google.svg'},
    {'id': 7, 'name': 'Soda', 'image': 'assets/img/icon_soda.svg'},
    {'id': 7, 'name': 'Susu', 'image': 'assets/img/icon_susu.svg'},
    {'id': 7, 'name': 'Snack', 'image': 'assets/img/icon_snack.svg'},
    {'id': 7, 'name': 'Roti', 'image': 'assets/img/icon_roti.svg'},
    {'id': 0, 'name': 'Semua', 'image': 'assets/img/icon_all.svg'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Jumlah kolom
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _buildCategoryButtonWithImage(
            context,
            cat['name'] as String,
            cat['id'] as int,
            cat['image'] as String,
          );
        },
      ),
    );
  }

  /// Tombol kategori satuan
  Widget _buildCategoryButtonWithImage(
      BuildContext context, String name, int categoryId, String imagePath) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          debugPrint("Tapped: $name (ID: $categoryId)");
          if (name == 'Semua') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoryAllProductPage(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CategoryProductPage(categoryId: categoryId),
              ),
            );
          }
        },
        child: SizedBox.expand(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  imagePath,
                  height: 55,
                  width: 55,
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Banner di bawah kategori
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.blue[50], // Warna latar belakang banner
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/img/banner.png'), // Gambar banner
          fit: BoxFit.cover, // Mengatur agar gambar menutupi container
        ),
      ),
    );
  }

  /// Carousel untuk "Pilihan Terbaik"
  Widget _buildCarousel(List<Product> topChoices) {
    return CarouselSlider.builder(
      itemCount: topChoices.length,
      itemBuilder: (context, index, realIndex) {
        return ProductCard(product: topChoices[index]);
      },
      options: CarouselOptions(
        height: 250,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),
        viewportFraction: 0.8,
      ),
    );
  }

  /// Skeleton saat data user belum tersedia
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
}
