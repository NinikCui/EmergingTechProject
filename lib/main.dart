import 'package:et_project/detailprofile.dart';
import 'package:flutter/material.dart';
import '../class/mahasiswa.dart';

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
      home: const MyHomePage(title: 'Project ET'),
      routes: {
        'home': (context) => const MyHomePage(title: 'Project ET'),
        'editprofile': (context) => const MyHomePage(title: 'Edit Profile'),
        "logout": (context) => const MyHomePage(title: 'Log Out'),
        'detail': (context) => const DetailPage(),
      },
    );
  }
}

List<Widget> mahasiswaList(BuildContext context) {
  return List.generate(mahasiswas.length, (index) {
    final m = mahasiswas[index]; // "bekukan" referensi item di sini

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myDrawer(context),
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

  Drawer myDrawer(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("Cindy"),
            accountEmail: Text("cindylau@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
            ),
          ),

          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pushNamed(context, 'home');
            },
          ),
          ListTile(
            title: const Text("Edit Profile"),
            leading: const Icon(Icons.people),
            onTap: () {
              Navigator.pushNamed(context, 'editprofile');
            },
          ),
          ListTile(
            title: const Text("Log Out"),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.pushNamed(context, 'logout');
            },
          ),
        ],
      ),
    );
  }
}
