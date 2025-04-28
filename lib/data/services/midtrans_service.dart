// import 'package:flutter/material.dart';
// import 'package:midtrans_sdk/midtrans_sdk.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class MidtransService {
//   late final MidtransSDK _midtrans;

//   Future<void> initialize() async {
//     // Muat konfigurasi dari .env
//     final clientKey = dotenv.env['MIDTRANS_CLIENT_KEY'] ?? "";
//     final merchantBaseUrl = dotenv.env['MIDTRANS_MERCHANT_BASE_URL'] ?? "";

//     // Periksa apakah clientKey valid
//     if (clientKey.isEmpty || merchantBaseUrl.isEmpty) {
//       throw Exception('Client Key atau Merchant Base URL tidak ditemukan');
//     }

//     // Konfigurasi Midtrans
//     final config = MidtransConfig(
//       clientKey: clientKey,
//       merchantBaseUrl: merchantBaseUrl,
//       colorTheme: ColorTheme(
//         colorPrimary: Colors.blue,
//         colorPrimaryDark: Colors.blueAccent,
//         colorSecondary: Colors.lightBlue,
//       ),
//     );

//     // Inisialisasi Midtrans SDK
//     _midtrans = await MidtransSDK.init(config: config);
//     _midtrans.setUIKitCustomSetting(skipCustomerDetailsPages: true);

//     // Callback untuk hasil transaksi
//     _midtrans.setTransactionFinishedCallback((result) {
//       debugPrint('Transaction result: ${result.toJson()}');
//     });
//   }

//   Future<void> startTransaction(String token) async {
//     await _midtrans.startPaymentUiFlow(token: token);
//   }
// }
