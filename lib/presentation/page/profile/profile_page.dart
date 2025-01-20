import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/login_page.dart';
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
    // Fetch user data saat halaman di-load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
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
                  // Foto Profil
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      user.avatarLink ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nama Pengguna
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email Pengguna
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Langganan End Date (Jika Ada)
                  if (bookingProvider.booking != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Langganan hingga: ${subscription?.validUntil ?? 'Tidak ada langganan aktif'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  // Tombol Berlangganan
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubscriptionsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text(
                      'Berlangganan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Menu Navigasi
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.blue),
                    title: const Text('Data Diri'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
                    leading: const Icon(Icons.info, color: Colors.green),
                    title: const Text('Tentang BeWise'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Tambahkan logika untuk membuka halaman Tentang BeWise
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Keluar Akun'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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