// lib/edit_profile_page.dart

import 'package:flutter/material.dart';
import 'class/mahasiswa.dart'; // Import class dan list global

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _programController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    // Isi controller dengan data user saat ini
    _nameController = TextEditingController(text: widget.user.name);
    _programController = TextEditingController(text: widget.user.program);
    _bioController = TextEditingController(text: widget.user.bio);
  }

  void _simpanProfile() {
    if (_formKey.currentState!.validate()) {
      // 1. Cari user di list global 'mahasiswas' berdasarkan ID
      try {
        final userIndex = mahasiswas.indexWhere((m) => m.id == widget.user.id);

        if (userIndex != -1) {
          // 2. Update data user di list global tersebut
          // Ini akan mengubah data di memori aplikasi
          setState(() {
            mahasiswas[userIndex].name = _nameController.text.trim();
            mahasiswas[userIndex].program = _programController.text.trim();
            mahasiswas[userIndex].bio = _bioController.text.trim();
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui!')),
          );
          
          // 3. Kembali ke halaman sebelumnya (Home)
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui profil: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Ubah Data Profil',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _programController,
                decoration: const InputDecoration(
                  labelText: 'Program/Lab',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Program tidak boleh kosong' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio Singkat',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Bio tidak boleh kosong' : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _simpanProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}