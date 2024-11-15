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
    name: 'Mario',
    user: 'mario.bros',
    password: 'itsme123',
  ),
  User(
    id: 'u2',
    name: 'Luigi',
    user: 'luigi.bros',
    password: 'greenbro2024',
  ),
  User(
    id: 'u3',
    name: 'Link',
    user: 'link.hyrule',
    password: 'masterSword!',
  ),
  User(
    id: 'u4',
    name: 'Zelda',
    user: 'zelda.hyrule',
    password: 'triforceQueen',
  ),
  User(
    id: 'u5',
    name: 'Donkey Kong',
    user: 'donkey.kong',
    password: 'bananas123',
  ),
];
