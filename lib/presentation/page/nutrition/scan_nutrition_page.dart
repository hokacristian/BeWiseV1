import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:bewise/core/constans/colors.dart';
import 'package:bewise/presentation/widgets/custom_button_widget.dart';
import 'package:bewise/data/services/api_service.dart';
import 'package:bewise/core/utils/sessionmanager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:bewise/core/utils/custom_toast.dart';


class ScanNutritionPage extends StatefulWidget {
  final String? barcode;
  
  const ScanNutritionPage({Key? key, this.barcode}) : super(key: key);

  @override
  _ScanNutritionPageState createState() => _ScanNutritionPageState();
}

class _ScanNutritionPageState extends State<ScanNutritionPage> {
  XFile? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();
  final ApiService _apiService = ApiService();

  // State untuk hasil analisis
  String? _nutritionGrade;
  String? _nutritionInsight;
  bool _hasAnalyzed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brokenWhite,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_hasAnalyzed) ...[
                        _buildHeaderSection(),
                        const SizedBox(height: 24),
                        _buildImageSection(),
                        const SizedBox(height: 24),
                        _buildInstructionSection(),
                      ] else ...[
                        _buildResultSection(),
                      ],
                    ],
                  ),
                ),
              ),
              if (!_hasAnalyzed) _buildBottomSection(),
              if (_hasAnalyzed) _buildRetrySection(),
            ],
          ),
          // Custom Loading Overlay dengan discreteCircular
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Loading Animation Widget - discreteCircular
              LoadingAnimationWidget.discreteCircle(
                color: AppColors.lightBlue,
                size: 80,
              ),
              
              const SizedBox(height: 24),
              
              // Loading Title
              Text(
                'Menganalisis Nutrisi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Loading Description
              Text(
                'Sedang memproses gambar label nutrisi\nuntuk mendapatkan analisis yang akurat',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              // Additional info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Mohon tunggu sebentar...',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.lightBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.brokenWhite,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        _hasAnalyzed ? 'Hasil Analisis Nutrisi' : 'Scan Label Nutrisi',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.barcode != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.qr_code, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Barcode: ${widget.barcode}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          'Pindai Label Nutrisi Manual',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ambil foto dari label informasi nilai gizi yang tertera pada kemasan produk untuk mendapatkan analisis nutrisi.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _selectedImage == null ? _buildEmptyImageState() : _buildSelectedImage(),
    );
  }

  Widget _buildEmptyImageState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.lightBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.camera_alt_outlined,
            size: 48,
            color: AppColors.lightBlue,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Belum ada gambar',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ambil foto label nutrisi\natau pilih dari galeri',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.grey[500],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImagePickerButton(
              icon: Icons.camera_alt,
              label: 'Kamera',
              onTap: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(width: 16),
            _buildImagePickerButton(
              icon: Icons.photo_library,
              label: 'Galeri',
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(_selectedImage!.path),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        if (!_hasAnalyzed)
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.edit,
                  onTap: () => _showImageSourceDialog(),
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete,
                  onTap: _removeImage,
                  color: Colors.red,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildInstructionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Tips untuk hasil terbaik:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('Pastikan label nutrisi terlihat jelas dan tidak buram'),
          _buildTipItem('Ambil foto dengan pencahayaan yang cukup'),
          _buildTipItem('Hindari bayangan atau pantulan pada label'),
          _buildTipItem('Pastikan seluruh tabel nutrisi masuk dalam frame'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.blue[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Foto hasil
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(_selectedImage!.path),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Grade Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _getGradeColor(_nutritionGrade ?? 'C'),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getGradeDarkerColor(_nutritionGrade ?? 'C'),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _nutritionGrade ?? 'C',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Grade Nutrisi: ${_nutritionGrade ?? 'C'}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Insight Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.insights,
                    color: AppColors.lightBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Analisis Nutrisi',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _nutritionInsight ?? 'Tidak ada insight tersedia.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CustomButtonWidget(
        text: 'Analisis Nutrisi',
        isLoading: false, // Set false karena kita handle loading di overlay
        onPressed: _selectedImage != null && !_isLoading ? _analyzeNutrition : () {},
        backgroundColor: _selectedImage != null && !_isLoading ? AppColors.lightBlue : Colors.grey.shade400,
        icon: Icon(
          Icons.analytics_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRetrySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButtonWidget(
              text: 'Analisis Ulang',
              onPressed: _resetAnalysis,
              backgroundColor: Colors.grey.shade600,
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButtonWidget(
              text: 'Selesai',
              onPressed: () => Navigator.of(context).pop(),
              backgroundColor: AppColors.lightBlue,
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return const Color(0xFF74AB83);
      case 'B':
        return const Color(0xFFBFD789);
      case 'C':
        return const Color(0xFFFEE272);
      case 'D':
        return const Color(0xFFF6B971);
      case 'E':
        return const Color(0xFFF1947A);
      default:
        return const Color(0xFFFEE272);
    }
  }

  Color _getGradeDarkerColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return const Color(0xFF5E8B6B);
      case 'B':
        return const Color(0xFF9BC063);
      case 'C':
        return const Color(0xFFF4C430);
      case 'D':
        return const Color(0xFFE8974F);
      case 'E':
        return const Color(0xFFE67E52);
      default:
        return const Color(0xFFF4C430);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _hasAnalyzed = false; // Reset jika ada analisis sebelumnya
        });
      }
    } catch (e) {
      _showErrorMessage('Gagal mengambil gambar: ${e.toString()}');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pilih Sumber Gambar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildImagePickerButton(
                    icon: Icons.camera_alt,
                    label: 'Kamera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImagePickerButton(
                    icon: Icons.photo_library,
                    label: 'Galeri',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _hasAnalyzed = false;
    });
  }

  void _resetAnalysis() {
    setState(() {
      _hasAnalyzed = false;
      _nutritionGrade = null;
      _nutritionInsight = null;
    });
  }

  Future<void> _analyzeNutrition() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();
      if (token == null) throw Exception('Token tidak tersedia');

      final response = await _apiService.processNutritionImage(token, _selectedImage!.path);
      
      setState(() {
        _nutritionGrade = response['data']['prediction']['grade'];
        _nutritionInsight = response['data']['insight'];
        _hasAnalyzed = true;
      });
      
    } catch (e) {
      _showErrorMessage('Gagal menganalisis nutrisi: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

 void _showErrorMessage(String message) {
  CustomToast.showError(context, message);
}

}