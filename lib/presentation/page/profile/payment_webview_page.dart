import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:bewise/presentation/page/profile/profile_page.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String redirectUrl;

  const PaymentWebViewPage({
    Key? key,
    required this.redirectUrl,
  }) : super(key: key);

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;
  bool isCountdownStarted = false;
  int countdown = 4;
  Timer? checkTimer;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            print('Page started: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            print('Page finished: $url');
            startChecking();
          },
        ),
      );

    controller.loadRequest(Uri.parse(widget.redirectUrl));
  }

  void startChecking() {
    // Cancel existing timer if any
    checkTimer?.cancel();
    
    // Start new periodic check
    checkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted && !isCountdownStarted) {
        checkForPaymentSuccess();
      } else {
        timer.cancel();
      }
    });
  }

  void checkForPaymentSuccess() async {
    try {
      final result = await controller.runJavaScriptReturningResult('''
        (function() {
          // First, lets log the entire HTML for debugging
          console.log('Full HTML:', document.documentElement.outerHTML);
          
          // Try finding the element with the exact class name
          const element = document.querySelector('div.text-headline.medium[bis_skin_checked="1"]');
          console.log('Found element:', element);
          
          if (element) {
            console.log('Element text:', element.innerText.trim());
            if (element.innerText.trim() === 'Pembayaran berhasil') {
              return true;
            }
          }
          
          // Alternative method using textContent
          const elements = document.getElementsByClassName('text-headline medium');
          for (const el of elements) {
            console.log('Checking element:', el.textContent.trim());
            if (el.textContent.trim() === 'Pembayaran berhasil') {
              return true;
            }
          }
          
          return false;
        })();
      ''');
      
      print('JavaScript check result: $result');
      
      if (result.toString() == 'true' && !isCountdownStarted) {
        print('Payment success detected!');
        checkTimer?.cancel();
        setState(() {
          isCountdownStarted = true;
        });
        startCountdown();
      }
    } catch (e) {
      print('Error running JavaScript: $e');
    }
  }

  void startCountdown() {
  print('Starting countdown from $countdown');
  if (countdown > 0) {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          countdown--;
        });
        print('Countdown: $countdown');
        startCountdown();
      }
    });
  } else {
    print('Countdown finished, navigating to ProfilePage');
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }
}


  @override
  void dispose() {
    checkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}