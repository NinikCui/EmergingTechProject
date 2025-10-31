import 'package:flutter/material.dart';
import 'class/mahasiswa.dart'; 

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  final List<String> _programList = [
    'Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Data Science',
    'Lainnya'
  ];
  late String _selectedProgram;
 

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio);

    if (_programList.contains(widget.user.program)) {
      _selectedProgram = widget.user.program;
    } else {
      _selectedProgram = 'Lainnya';
    }
  }

  void _simpanProfile() {
    if (_formKey.currentState!.validate()) {
      try {
        final userIndex = mahasiswas.indexWhere((m) => m.id == widget.user.id);

        if (userIndex != -1) {
          setState(() {
            mahasiswas[userIndex].name = _nameController.text.trim();
            mahasiswas[userIndex].program = _selectedProgram; 
            mahasiswas[userIndex].bio = _bioController.text.trim();
          });

          showDialog(
            context: context,
            barrierDismissible: false, 
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Berhasil'),
                content: const Text('Data berhasil diperbarui.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); 
                      Navigator.of(context).pop(); 
                    },
                  ),
                ],
              );
            },
          );          
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

              DropdownButtonFormField<String>(
                value: _selectedProgram,
                items: _programList.map((String program) {
                  return DropdownMenuItem<String>(
                    value: program,
                    child: Text(program),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedProgram = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Program/Lab',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'Program tidak boleh kosong' : null,
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