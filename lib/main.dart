import 'package:et_project/detailprofile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- IMPORT (POIN 2)
import '../class/mahasiswa.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'editprofile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  final prefs = await SharedPreferences.getInstance();
  final String? loggedInUserNrp = prefs.getString('loggedInUserNrp');
  
  User? loggedInUser;
  if (loggedInUserNrp != null) {
    try {
      loggedInUser = mahasiswas.firstWhere((m) => m.nrp == loggedInUserNrp);
    } catch (e) {
      await prefs.remove('loggedInUserNrp');
    }
  }

  runApp(MyApp(loggedInUser: loggedInUser));
}

class MyApp extends StatelessWidget {
  final User? loggedInUser;
  const MyApp({super.key, this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: loggedInUser != null
          ? MyHomePage(title: 'Daftar Mahasiswa', user: loggedInUser!)
          : const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return MyHomePage(title: 'Daftar Mahasiswa', user: user);
        },
        '/editprofile': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return EditProfilePage(user: user);
        },
        'detail': (context) => const DetailPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final User user;

  const MyHomePage({
    super.key,
    required this.title,
    required this.user,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _mahasiswaList(BuildContext context) {
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
                    Navigator.pushNamed(context, 'detail', arguments: {
                      'viewedUser': m,
                      'currentUser': widget.user, 
                    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              physics: const NeverScrollableScrollPhysics(),
              children: _mahasiswaList(context), 
            ),
            const Divider(height: 100),
          ],
        ),
      ),
    );
  }

  Drawer myDrawer(BuildContext context, User user) {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.email), 
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
          ),
          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Edit Profile"),
            leading: const Icon(Icons.people),
            onTap: () {
              Navigator.pop(context); 
              Navigator.pushNamed(context, '/editprofile', arguments: user)
                  .then((_) {
                setState(() {});
              });
            },
          ),
          ListTile(
            title: const Text("Log Out"),
            leading: const Icon(Icons.logout),
            onTap: () async { 

              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('loggedInUserNrp');

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