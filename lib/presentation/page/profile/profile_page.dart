import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../auth/login_page.dart';
import 'package:bewise/core/constans/colors.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/data/providers/booking_provider.dart';
import 'package:bewise/core/utils/sessionmanager.dart';
import 'package:bewise/presentation/page/profile/subscriptions_page.dart';
import 'package:bewise/presentation/page/profile/detail_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookingProvider =
          Provider.of<BookingProvider>(context, listen: false);
      authProvider.fetchUserData();
      bookingProvider.createBooking(authProvider.token!, 1);
    });
  }

  Future<void> _logout(BuildContext context) async {
    final sessionManager = SessionManager();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await sessionManager.clearSession();
    authProvider.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, BookingProvider>(
        builder: (context, authProvider, bookingProvider, child) {
          if (authProvider.isLoading || bookingProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (authProvider.user == null) {
            return const Center(
              child: Text(
                'Tidak dapat memuat data pengguna.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          final user = authProvider.user!;
          final subscription = authProvider.subscription;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Box/Card pembungkus
                  Card(
                    color: AppColors.yellow,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              user.avatarLink ??
                                  'https://ik.imagekit.io/swvbgy6po/icon.png',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Bagian yang diubah
                          if (subscription?.isActive == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Premium: ${subscription?.countDownDay ?? 0} Hari',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SubscriptionsPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/img/barcode.svg',
                                    height: 24,
                                    width: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Berlangganan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Menu Navigasi
                  // Ganti bagian ListTile pada profile_page.dart

                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/img/datadiri.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    title: const Text(
                      'Data Diri',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF4F7DF3), // Biru sesuai gambar
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailProfilePage(),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/img/tentang.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    title: const Text(
                      'Tentang BeWise',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF1A202C), // Hitam gelap sesuai gambar
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                    onTap: () {},
                  ),

                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/img/logout.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    title: const Text(
                      'Keluar akun', // Huruf 'a' kecil sesuai gambar
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFFE53E3E), // Merah sesuai gambar
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
