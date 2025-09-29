import '../database/database_helper.dart';
import '../models/usuario.dart';

class UsuarioRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Criar usuário
  Future<Usuario> createUsuario(Usuario usuario) async {
    print('📝 Repository: Criando usuário ${usuario.nome} (${usuario.email})');
    await _dbHelper.insertUsuario(usuario.toMap());
    print('✅ Repository: Usuário criado com sucesso');
    return usuario;
  }

  // Buscar usuário por ID
  Future<Usuario?> getUsuarioById(String id) async {
    final map = await _dbHelper.getUsuarioById(id);
    return map != null ? Usuario.fromMap(map) : null;
  }

  // Buscar usuário por email
  Future<Usuario?> getUsuarioByEmail(String email) async {
    final map = await _dbHelper.getUsuarioByEmail(email);
    return map != null ? Usuario.fromMap(map) : null;
  }

  // Buscar todos os usuários
  Future<List<Usuario>> getAllUsuarios() async {
    final maps = await _dbHelper.getUsuarios();
    return maps.map((map) => Usuario.fromMap(map)).toList();
  }

  // Buscar apenas terapeutas
  Future<List<Usuario>> getTerapeutas() async {
    final maps = await _dbHelper.getTerapeutas();
    return maps.map((map) => Usuario.fromMap(map)).toList();
  }

  // Atualizar usuário
  Future<Usuario> updateUsuario(Usuario usuario) async {
    final updatedUsuario = usuario.copyWith(
      updatedAt: DateTime.now(),
    );
    await _dbHelper.updateUsuario(usuario.id, updatedUsuario.toMap());
    return updatedUsuario;
  }

  // Deletar usuário
  Future<void> deleteUsuario(String id) async {
    await _dbHelper.deleteUsuario(id);
  }

  // Verificar se email já existe
  Future<bool> emailExists(String email) async {
    final usuario = await getUsuarioByEmail(email);
    return usuario != null;
  }

  // Autenticar usuário
  Future<Usuario?> authenticate(String email, String senha) async {
    print('🔐 Repository: Autenticando usuário $email');
    final usuario = await getUsuarioByEmail(email);
    if (usuario != null && usuario.senha == senha) {
      print('✅ Repository: Autenticação bem-sucedida para ${usuario.nome}');
      return usuario;
    }
    print('❌ Repository: Falha na autenticação - usuário não encontrado ou senha incorreta');
    return null;
  }

  // Criar usuário terapeuta padrão para testes
  Future<void> createDefaultTerapeuta() async {
    final terapeuta = Usuario(
      id: 'terapeuta-001',
      nome: 'Dra. Maria Santos',
      email: 'maria@nucleodesenvolver.com',
      tipo: 'terapeuta',
      telefone: '(11) 99999-9999',
      cpf: '12345678901',
      senha: '123456',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Verificar se já existe
    final existing = await getUsuarioByEmail(terapeuta.email);
    if (existing == null) {
      await createUsuario(terapeuta);
    }
  }
}
