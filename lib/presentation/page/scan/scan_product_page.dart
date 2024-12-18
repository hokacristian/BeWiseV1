import 'package:bewise/core/constans/colors.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobilescanner;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_ml_kit/google_ml_kit.dart'
    as mlkit; // Import Google ML Kit
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/page/product/detail_product_page.dart';

class ScanProductPage extends StatefulWidget {
  @override
  _ScanProductPageState createState() => _ScanProductPageState();
}

class _ScanProductPageState extends State<ScanProductPage> {
  bool isLoading = false;
  String scannedBarcode = '';
  bool hasScanned = false;
  bool isFlashOn = false;
  XFile? _selectedImage;

  final mobilescanner.MobileScannerController cameraController =
      mobilescanner.MobileScannerController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brokenWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildCameraOrImage()),
          const SizedBox(height: 20),
          _buildInformationMessage(),
        ],
      ),
    );
  }

  /// Build AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.brokenWhite,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          cameraController.dispose();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// Build Kamera atau Gambar dari Galeri
  Widget _buildCameraOrImage() {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Tambahkan padding di sekitar Stack
      child: Stack(
        children: [
          // Kamera atau gambar dari galeri
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _selectedImage == null
                  ? mobilescanner.MobileScanner(
                      controller: cameraController,
                      onDetect: (barcodeCapture) async {
                        if (hasScanned) return;

                        final List<mobilescanner.Barcode> barcodes =
                            barcodeCapture.barcodes;
                        for (final barcode in barcodes) {
                          final String? code = barcode.rawValue;
                          if (code != null) {
                            setState(() {
                              hasScanned = true;
                              isLoading = true;
                              scannedBarcode = code;
                            });
                            cameraController.stop();
                            await _fetchProductData(code);
                            break;
                          }
                        }
                      },
                    )
                  : Image.file(
                      File(_selectedImage!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
          ),

          // Tombol Trigger ke Detail Product
          if (_selectedImage != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 23),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await _scanImageFromGallery(); // Pindai gambar untuk barcode
                  },
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text(
                    "Lihat Detail Produk",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                      color: Colors.white),
                  ),
                ),
              ),
            ),

          // Tombol Galeri di Kiri Bawah
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: _pickImageFromGallery,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.image, color: Colors.white, size: 30),
              ),
            ),
          ),

          // Tombol Flash di Kanan Bawah
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                cameraController.toggleTorch();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Pesan Informasi
  Widget _buildInformationMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
      decoration: const BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: const Text(
        "Silakan pindai barcode di kemasan untuk mendapatkan informasi lebih lanjut.",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _scanImageFromGallery() async {
    if (_selectedImage == null) return;

    final mlkit.InputImage inputImage =
        mlkit.InputImage.fromFilePath(_selectedImage!.path);
    final mlkit.BarcodeScanner barcodeScanner =
        mlkit.GoogleMlKit.vision.barcodeScanner();

    try {
      final List<mlkit.Barcode> barcodes =
          await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        final String? code = barcodes.first.rawValue;
        if (code != null) {
          await _fetchProductData(code);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tidak dapat membaca barcode dari gambar')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Barcode tidak ditemukan dalam gambar')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat memindai gambar')),
      );
    } finally {
      await barcodeScanner.close();
      setState(() {
        _selectedImage = null;
      });
    }
  }

  Future<void> _fetchProductData(String barcode) async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      await productProvider.scanProduct(barcode);
      final product = productProvider.product;

      if (product != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productId: product.id),
          ),
        ).then((_) {
          setState(() {
            hasScanned = false;
            isLoading = false;
          });
          cameraController.start();
        });
      } else {
        throw Exception('Produk tidak ditemukan.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        isLoading = false;
        hasScanned = false;
      });
      cameraController.start();
    }
  }
}
