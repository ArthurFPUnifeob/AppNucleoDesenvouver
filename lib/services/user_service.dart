import '../models/usuario.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  Usuario? _currentUser;

  // Getters
  Usuario? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  String? get currentUserName => _currentUser?.nome;
  String? get currentUserEmail => _currentUser?.email;
  String? get currentUserType => _currentUser?.tipo;

  // Métodos
  void setCurrentUser(Usuario user) {
    _currentUser = user;
    print('Usuário logado: ${user.nome} (${user.email})');
  }

  void logout() {
    _currentUser = null;
    print('Usuário deslogado');
  }

  void updateUser(Usuario user) {
    _currentUser = user;
  }
}

