import 'package:flutter/material.dart';
import '../class/mahasiswa.dart';
import '../class/teman.dart'; 

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  void _showAddFriendDialog(BuildContext context, String friendName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil'),
        content: Text('Anda berhasil menambahkan $friendName sebagai teman.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, User>;
    final User mahasiswa = args['viewedUser']!;
    final User currentUser = args['currentUser']!;

    final bool isSelf = currentUser.nrp == mahasiswa.nrp;
    final bool isAlreadyFriend = temans.any((f) =>
        (f.nrp_1 == currentUser.nrp && f.nrp_2 == mahasiswa.nrp) ||
        (f.nrp_1 == mahasiswa.nrp && f.nrp_2 == currentUser.nrp));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Profil"),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: isSelf
          ? null 
          : FloatingActionButton(
              onPressed: isAlreadyFriend
                  ? null 
                  : () {
                      temans.add(Friend(
                          nrp_1: currentUser.nrp, nrp_2: mahasiswa.nrp));
                      _showAddFriendDialog(context, mahasiswa.name);
                    },
              backgroundColor: isAlreadyFriend ? Colors.grey : Colors.deepPurple,
              child: const Icon(Icons.person_add),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(mahasiswa.photoUrl),
            ),
            const SizedBox(height: 20),
            Text(
              mahasiswa.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "NRP: ${mahasiswa.nrp}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Program/Lab",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(mahasiswa.program),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Biografi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(mahasiswa.bio),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}