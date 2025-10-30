class User {
  int id;
  String name;
  String nrp;
  String program;
  String bio;
  String photoUrl;
  String password;

  User({
    required this.id,
    required this.name,
    required this.nrp,
    required this.program,
    required this.bio,
    required this.photoUrl,
    required this.password,
  });
}

var mahasiswas = <User>[
  User(
    id: 1,
    name: 'Dita Surya',
    nrp: '160720001',
    program: 'Informatika',
    bio: 'Suka mobile dev & UI/UX.',
    photoUrl: 'https://i.pravatar.cc/150?img=1',
    password: "123",
  ),
  User(
    id: 2,
    name: 'Andra Putra',
    nrp: '160720003',
    program: 'Sistem Informasi',
    bio: 'Exploring data & product.',
    photoUrl: 'https://i.pravatar.cc/150?img=2',
    password: "456",
  ),
  User(
    id: 3,
    name: 'Nayla Azzahra',
    nrp: '160720005',
    program: 'Informatika',
    bio: 'AI/ML enthusiast.',
    photoUrl: 'https://i.pravatar.cc/150?img=3',
    password: "789",
  ),
];
