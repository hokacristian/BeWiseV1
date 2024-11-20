import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/presentation/page/profile/profile_page.dart';

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({Key? key}) : super(key: key);

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  String? _gender;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController.text = authProvider.user?.name ?? '';
    _gender = authProvider.user?.gender;
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
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

          print('Compressed image size: ${(compressedBytes.length / 1024).toStringAsFixed(2)} KB');
        } else {
          print('Failed to decode the image.');
        }
      } catch (e) {
        print('Error while compressing image: $e');
      }
    }
  }

  Future<void> _saveProfile() async {
  if (_formKey.currentState!.validate()) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      if (_selectedImage != null) {
        await authProvider.updateAvatar(_selectedImage!.path); // Update avatar
      }
      await authProvider.updateProfile(_nameController.text, _gender ?? 'Pria'); // Update nama dan gender

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Diri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (user?.avatarLink != null
                            ? NetworkImage(user!.avatarLink!)
                            : const AssetImage('assets/img/default_foto.png')) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20,
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email (non-editable)
              TextFormField(
                initialValue: user?.email ?? '',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),

              // Gender
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Jenis Kelamin:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Pria',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      const Text('Pria'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Wanita',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      const Text('Wanita'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tombol Simpan
              ElevatedButton(
  onPressed: () async {
    // Panggil fungsi _saveProfile untuk menyimpan data
    await _saveProfile();

    // Setelah berhasil menyimpan, arahkan ke halaman ProfilePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(), // Ganti dengan nama class ProfilePage Anda
      ),
    );
  },
  child: const Text('Simpan'),
),

            ],
          ),
        ),
      ),
    );
  }
}
