import 'package:et_project/detailprofile.dart';
import 'package:flutter/material.dart';
import '../class/mahasiswa.dart';
import 'login_page.dart';
import 'register_page.dart';

// Pastikan Anda mengimpor file 'editprofile.dart'
// (Saya lihat Anda sudah melakukan ini di kode Anda)
import 'editprofile.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: "/login",

      // === PERBAIKAN 1: 'routes' ===
      // Kita perbaiki rute 'editprofile' dan hapus rute 'logout' yang tidak perlu
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return MyHomePage(title: 'Daftar Mahasiswa', user: user);
        },
        
        // Mengarahkan ke halaman EditProfilePage dan mengirim data 'user'
        '/editprofile': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          // Pastikan nama class Anda adalah 'EditProfilePage'
          return EditProfilePage(user: user); 
        },

        'detail': (context) => const DetailPage(),
        
        // Rute lama 'editprofile' and 'logout' dihapus
      },
    );
  }
}

List<Widget> mahasiswaList(BuildContext context) {
  // ... (Tidak ada perubahan di sini, sudah benar)
  return List.generate(mahasiswas.length, (index) {
    final m = mahasiswas[index];
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(128, 128, 128, 0.5),
            spreadRadius: -6,
            blurRadius: 8,
            offset: Offset(8, 7),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                m.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  m.photoUrl,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text("NRP: ${m.nrp}", style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'detail', arguments: m);
                },
                child: const Text("Lihat Detail Profil"),
              ),
            ],
          ),
        ),
      ),
    );
  });
}


// === PERBAIKAN 2: 'MyHomePage' ===
class MyHomePage extends StatefulWidget {
  // Hanya perlu DUA properti ini
  final String title;
  final User user;

  // Hanya perlu SATU konstruktor
  const MyHomePage({
    super.key,
    required this.title,
    required this.user,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


// === PERBAIKAN 3: '_MyHomePageState' dan 'myDrawer' ===
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Panggil drawer DENGAN 'widget.user'
      drawer: myDrawer(context, widget.user),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: mahasiswaList(context),
            ),
            Divider(height: 100),
          ],
        ),
      ),
    );
  }

  // Tambahkan 'User user' sebagai parameter
  Drawer myDrawer(BuildContext context, User user) {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          // Tampilkan data 'user' yang sedang login
          UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.nrp),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
          ),
          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () {
              // Tutup drawer saja, karena sudah di halaman home
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Edit Profile"),
            leading: const Icon(Icons.people),
            onTap: () {
              Navigator.pop(context); // Tutup drawer
              // Panggil rute '/editprofile' dan kirim data 'user'
              Navigator.pushNamed(context, '/editprofile', arguments: user)
                  .then((_) {
                // Refresh halaman ini saat kembali dari edit
                setState(() {});
              });
            },
          ),
          ListTile(
            title: const Text("Log Out"),
            leading: const Icon(Icons.logout),
            onTap: () {
              // Panggil rute '/login' dan hapus semua rute sebelumnya
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}