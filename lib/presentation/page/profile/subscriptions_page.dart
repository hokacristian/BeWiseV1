import 'package:flutter/material.dart';
import 'package:bewise/presentation/page/profile/payment_webview_page.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/data/providers/booking_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
           image: AssetImage('assets/img/subs_page.png'),
            fit: BoxFit.cover, // Sesuaikan dengan kebutuhan Anda
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                // Dapatkan token dan redirect URL dari booking provider
                final redirectUrl = await bookingProvider.getPaymentRedirectUrl();
                
                // Navigate to WebView page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentWebViewPage(redirectUrl: redirectUrl),
                  ),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $error')),
                );
              }
            },
            child: const Text('Pay Now'),
          ),
        ),
      ),
    );
  }
}