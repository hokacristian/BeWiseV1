import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobilescanner;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:bewise/core/constans/colors.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/page/product/product_base_page.dart';

class ScanProductPage extends StatefulWidget {
  const ScanProductPage({Key? key}) : super(key: key);

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
BarcodeScanner get _barcodeScanner => BarcodeScanner();

  @override
void dispose() {
  cameraController.dispose();
  // Hapus ini:
  // _barcodeScanner.close();
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
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          // Kamera atau gambar
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
                            await _handleScanResult(code);
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

          // Tombol "Lihat Detail Produk" (hanya muncul jika _selectedImage != null)
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
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await _scanImageFromGallery();
                  },
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text(
                    "Lihat Detail Produk",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Tombol Galeri di kiri bawah
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

          // Tombol Flash di kanan bawah
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

          // Loading indicator
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
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
        isLoading = true;
      });

      await _scanImageFromGallery();
    }
  }

  Future<void> _scanImageFromGallery() async {
  if (_selectedImage == null) return;

  final inputImage = InputImage.fromFilePath(_selectedImage!.path);
  final scanner = _barcodeScanner; // Gunakan getter

  try {
    final List<Barcode> barcodes = await scanner.processImage(inputImage);
    
    if (barcodes.isNotEmpty) {
      for (final barcode in barcodes) {
        if (barcode.type == BarcodeType.product) {
          final String? code = barcode.rawValue;
          if (code != null && code.isNotEmpty) {
            await _handleScanResult(code);
            return;
          }
        }
      }
      _showErrorMessage('Barcode produk tidak ditemukan');
    } else {
      _showErrorMessage('Tidak ada barcode terdeteksi');
    }
  } catch (e) {
    _showErrorMessage('Gagal memindai: ${e.toString()}');
  } finally {
    await scanner.close(); // Tutup scanner setelah selesai
    setState(() => isLoading = false);
  }
}

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Method privat untuk menangani hasil scan (kode)
  Future<void> _handleScanResult(String barcode) async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    try {
      // Panggil scanProduct di provider
      await productProvider.scanProduct(barcode);

      // Ambil object Product dari provider
      final Product? product = productProvider.product;

      if (product != null) {
        // Navigasi ke ProductBasePage dengan cara passing data "product"
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductBasePage(product: product),
          ),
        ).then((_) {
          setState(() {
            hasScanned = false;
            isLoading = false;
            _selectedImage = null; // Reset selected image
          });
          cameraController.start();
        });
      } else {
        throw Exception('Produk tidak ditemukan.');
      }
    } catch (e) {
      _showErrorMessage('Error: ${e.toString()}');
      setState(() {
        isLoading = false;
        hasScanned = false;
      });
      cameraController.start();
    }
  }
}