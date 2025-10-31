import 'package:flutter/material.dart';
import 'class/mahasiswa.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nrpController = TextEditingController();
  final _emailController = TextEditingController(); 
  final _programController = TextEditingController();
  final _bioController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      final nrpExists = mahasiswas.any(
        (m) => m.nrp == _nrpController.text,
      );
      final emailExists = mahasiswas.any(
        (m) => m.email == _emailController.text,
      );

      if (nrpExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NRP sudah terdaftar!')),
        );
        return;
      }

      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email sudah terdaftar!')),
        );
        return;
      }

      final newUser = User(
        id: mahasiswas.length + 1,
        name: _nameController.text,
        nrp: _nrpController.text,
        email: _emailController.text, 
        program: _programController.text,
        bio: _bioController.text,
        photoUrl: 'https://i.pravatar.cc/150?img=${mahasiswas.length + 1}',
        password: _passwordController.text,
      );

      mahasiswas.add(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
      Navigator.pop(context); // Kembali ke halaman login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Buat Akun Baru',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
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
                controller: _nrpController,
                decoration: const InputDecoration(
                  labelText: 'NRP',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'NRP tidak boleh kosong' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                  if (!v.contains('@')) return 'Email tidak valid';
                  return null;
                },
              ),
              // ==========================
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
                decoration: const InputDecoration(
                  labelText: 'Bio Singkat',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Bio tidak boleh kosong' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Password tidak boleh kosong' : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Register'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}