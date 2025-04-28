import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/booking_provider.dart';
import 'package:bewise/presentation/page/profile/payment_webview_page.dart';
import 'package:bewise/presentation/widgets/trial_button.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          // Background SVG
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/img/subscription.svg', // Pastikan file ada di folder assets/img
              fit: BoxFit.cover,
            ),
          ),

          // Trial Button di bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90), // Jarak dari bawah
              child: TrialButton(
                onPressed: () async {
                  try {
                    final redirectUrl = await bookingProvider.getPaymentRedirectUrl();
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
