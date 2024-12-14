import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobilescanner;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as mlkit; // Import Google ML Kit
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

  final mobilescanner.MobileScannerController cameraController = mobilescanner.MobileScannerController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pindai Produk',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            cameraController.dispose();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
              });
              cameraController.toggleTorch();
            },
          ),
          IconButton(
            icon: Icon(Icons.image, color: Colors.white),
            onPressed: _pickImageFromGallery,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _selectedImage == null
                      ? mobilescanner.MobileScanner(
                          controller: cameraController,
                          onDetect: (barcodeCapture) async {
                            if (hasScanned) return;

                            final List<mobilescanner.Barcode> barcodes = barcodeCapture.barcodes;
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
                SizedBox(height: 20),
                Text(
                  "Arahkan kamera ke barcode atau pilih gambar dari galeri.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _selectedImage != null
                    ? ElevatedButton(
                        onPressed: _scanImageFromGallery,
                        child: Text("Pindai dari Gambar"))
                    : SizedBox.shrink(),
              ],
            ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _scanImageFromGallery() async {
    if (_selectedImage == null) return;

    final mlkit.InputImage inputImage = mlkit.InputImage.fromFilePath(_selectedImage!.path);
    final mlkit.BarcodeScanner barcodeScanner = mlkit.GoogleMlKit.vision.barcodeScanner();

    try {
      final List<mlkit.Barcode> barcodes = await barcodeScanner.processImage(inputImage);
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
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

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
