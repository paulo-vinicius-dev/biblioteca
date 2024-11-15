class User {
  final String id;
  final String name;
  final String user;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.user,
    required this.password,
  });
}

// Lista de usuários fictícios para testes
final List<User> dummyUsers = [
  User(
    id: 'u1',
    name: 'Alice Silva',
    user: 'alice.silva',
    password: 'password123',
  ),
  User(
    id: 'u2',
    name: 'Bruno Oliveira',
    user: 'bruno.oliveira',
    password: 'bruno2024',
  ),
  User(
    id: 'u3',
    name: 'Carla Souza',
    user: 'carla.souza',
    password: 'souza@22',
  ),
  User(
    id: 'u4',
    name: 'Diego Martins',
    user: 'diego.martins',
    password: 'martinsPass!',
  ),
  User(
    id: 'u5',
    name: 'Eduarda Lima',
    user: 'eduarda.lima',
    password: 'lima@123',
  ),
];
