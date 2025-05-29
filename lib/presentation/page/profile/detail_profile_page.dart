import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/presentation/page/profile/profile_page.dart';
import 'package:bewise/presentation/widgets/custom_button_widget.dart';

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({super.key});

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  File? _selectedImage;
  String? _gender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _firstNameController.text = authProvider.user?.firstName ?? '';
    _lastNameController.text = authProvider.user?.lastName ?? '';
    _gender = authProvider.user?.gender;
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Built-in quality reduction
    );
    
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      try {
        // Baca file asli sebagai byte array dan ubah menjadi Uint8List
        Uint8List imageBytes = await imageFile.readAsBytes();

        // Decode gambar
        img.Image? image = img.decodeImage(imageBytes);

        if (image != null) {
          // Resize gambar untuk memastikan maksimal lebar 800px
          const int maxWidth = 800;
          final resizedImage = img.copyResize(
            image,
            width: maxWidth,
            height: (maxWidth * image.height ~/ image.width), // Menjaga rasio aspek
          );

          // Kompres gambar ke kualitas 70%
          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 70);

          // Jika ukuran masih terlalu besar (>1MB), turunkan kualitas lebih lanjut
          if (compressedBytes.length > 1024 * 1024) {
            compressedBytes = img.encodeJpg(resizedImage, quality: 50);
          }

          // Simpan gambar terkompresi ke file baru
          final compressedFilePath = pickedImage.path.replaceFirst(
            path.extension(pickedImage.path),
            '_compressed.jpg',
          );
          final compressedFile = File(compressedFilePath)
            ..writeAsBytesSync(compressedBytes);

          setState(() {
            _selectedImage = compressedFile; // Update state dengan file terkompresi
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saat memproses gambar: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        if (_selectedImage != null) {
          await authProvider.updateAvatar(_selectedImage!.path); // Update avatar
        }
        await authProvider.updateProfile(
          _firstNameController.text,
          _lastNameController.text,
          _gender ?? 'Pria',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to profile page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilePage(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui profil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside of text fields
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              children: [
                // Profile Header with Avatar
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Foto Profil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.primaryColor.withOpacity(0.2),
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                      : (user?.avatarLink != null
                                          ? NetworkImage(user!.avatarLink!)
                                          : const AssetImage('assets/img/default_foto.png')) as ImageProvider,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.primaryColor,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ketuk tombol kamera untuk mengubah foto profil',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Personal Information Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Pribadi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // First Name field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nama Depan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan nama depan',
                                prefixIcon: const Icon(Icons.person_outline),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: theme.primaryColor, width: 1),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama depan tidak boleh kosong';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Last Name field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nama Belakang',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan nama belakang',
                                prefixIcon: const Icon(Icons.person_outline),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: theme.primaryColor, width: 1),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Email field (non-editable)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: user?.email ?? '',
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              enabled: false,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Gender selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jenis Kelamin',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _gender = 'Pria';
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _gender == 'Pria' ? theme.primaryColor : Colors.transparent,
                                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(11)),),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.male_rounded,
                                              color: _gender == 'Pria' ? Colors.white : Colors.grey[700],
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Pria',
                                              style: TextStyle(
                                                color: _gender == 'Pria' ? Colors.white : Colors.grey[700],
                                                fontWeight: _gender == 'Pria' ? FontWeight.bold : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _gender = 'Wanita';
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _gender == 'Wanita' ? theme.primaryColor : Colors.transparent,
                                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(11)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.female_rounded,
                                              color: _gender == 'Wanita' ? Colors.white : Colors.grey[700],
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Wanita',
                                              style: TextStyle(
                                                color: _gender == 'Wanita' ? Colors.white : Colors.grey[700],
                                                fontWeight: _gender == 'Wanita' ? FontWeight.bold : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Save Button
                CustomButtonWidget(
                  text: 'Simpan Perubahan',
                  onPressed: _saveProfile,
                  isLoading: _isLoading,
                  backgroundColor: theme.primaryColor,
                  icon: const Icon(Icons.save_rounded, color: Colors.white),
                ),
                
                const SizedBox(height: 12),
                
                // Cancel Button
                CustomButtonWidget(
                  text: 'Batal',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.grey[200],
                  textColor: Colors.black87,
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}