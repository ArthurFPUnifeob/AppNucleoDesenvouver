import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'nucleo_desenvolver.db';
  static const int _databaseVersion = 1;

  // Tabelas
  static const String _tableUsuarios = 'usuarios';
  static const String _tablePacientes = 'pacientes';
  static const String _tableAgendamentos = 'agendamentos';

  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE $_tableUsuarios (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        tipo TEXT NOT NULL CHECK (tipo IN ('paciente', 'terapeuta')),
        telefone TEXT,
        cpf TEXT,
        data_nascimento INTEGER,
        senha TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Tabela de pacientes
    await db.execute('''
      CREATE TABLE $_tablePacientes (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        data_nascimento INTEGER NOT NULL,
        genero TEXT NOT NULL CHECK (genero IN ('masculino', 'feminino')),
        responsavel TEXT NOT NULL,
        telefone TEXT NOT NULL,
        email TEXT,
        observacoes TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Tabela de agendamentos
    await db.execute('''
      CREATE TABLE $_tableAgendamentos (
        id TEXT PRIMARY KEY,
        paciente_id TEXT NOT NULL,
        paciente_nome TEXT NOT NULL,
        terapeuta_id TEXT NOT NULL,
        terapeuta_nome TEXT NOT NULL,
        data_hora INTEGER NOT NULL,
        status TEXT NOT NULL CHECK (status IN ('confirmado', 'pendente', 'cancelado', 'realizado')),
        tipo_consulta TEXT NOT NULL CHECK (tipo_consulta IN ('consulta', 'avaliacao', 'retorno', 'emergencia')),
        observacoes TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (paciente_id) REFERENCES $_tablePacientes (id),
        FOREIGN KEY (terapeuta_id) REFERENCES $_tableUsuarios (id)
      )
    ''');

    // Índices para melhor performance
    await db.execute('CREATE INDEX idx_usuarios_email ON $_tableUsuarios (email)');
    await db.execute('CREATE INDEX idx_usuarios_tipo ON $_tableUsuarios (tipo)');
    await db.execute('CREATE INDEX idx_pacientes_nome ON $_tablePacientes (nome)');
    await db.execute('CREATE INDEX idx_agendamentos_data ON $_tableAgendamentos (data_hora)');
    await db.execute('CREATE INDEX idx_agendamentos_paciente ON $_tableAgendamentos (paciente_id)');
    await db.execute('CREATE INDEX idx_agendamentos_terapeuta ON $_tableAgendamentos (terapeuta_id)');
    await db.execute('CREATE INDEX idx_agendamentos_status ON $_tableAgendamentos (status)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migrações quando necessário
    if (oldVersion < newVersion) {
      // Exemplo de migração:
      // await db.execute('ALTER TABLE $_tableUsuarios ADD COLUMN nova_coluna TEXT');
    }
  }

  // Métodos para usuários
  Future<int> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    print('🗄️ Inserindo usuário no banco: ${usuario['nome']} (${usuario['email']})');
    final result = await db.insert(_tableUsuarios, usuario);
    print('✅ Usuário inserido com ID: $result');
    return result;
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await database;
    return await db.query(_tableUsuarios, orderBy: 'nome ASC');
  }

  Future<Map<String, dynamic>?> getUsuarioById(String id) async {
    final db = await database;
    final result = await db.query(
      _tableUsuarios,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUsuarioByEmail(String email) async {
    final db = await database;
    print('🔍 Buscando usuário por email: $email');
    final result = await db.query(
      _tableUsuarios,
      where: 'email = ?',
      whereArgs: [email],
    );
    print('📊 Resultado da busca: ${result.length} usuário(s) encontrado(s)');
    if (result.isNotEmpty) {
      print('👤 Usuário encontrado: ${result.first['nome']}');
    }
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getTerapeutas() async {
    final db = await database;
    return await db.query(
      _tableUsuarios,
      where: 'tipo = ?',
      whereArgs: ['terapeuta'],
      orderBy: 'nome ASC',
    );
  }

  Future<int> updateUsuario(String id, Map<String, dynamic> usuario) async {
    final db = await database;
    return await db.update(
      _tableUsuarios,
      usuario,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUsuario(String id) async {
    final db = await database;
    return await db.delete(
      _tableUsuarios,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para pacientes
  Future<int> insertPaciente(Map<String, dynamic> paciente) async {
    final db = await database;
    print('🗄️ Inserindo paciente no banco: ${paciente['nome']}');
    final result = await db.insert(_tablePacientes, paciente);
    print('✅ Paciente inserido com ID: $result');
    return result;
  }

  Future<List<Map<String, dynamic>>> getPacientes() async {
    final db = await database;
    return await db.query(_tablePacientes, orderBy: 'nome ASC');
  }

  Future<Map<String, dynamic>?> getPacienteById(String id) async {
    final db = await database;
    final result = await db.query(
      _tablePacientes,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> searchPacientes(String query) async {
    final db = await database;
    return await db.query(
      _tablePacientes,
      where: 'nome LIKE ? OR responsavel LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'nome ASC',
    );
  }

  Future<int> updatePaciente(String id, Map<String, dynamic> paciente) async {
    final db = await database;
    print('🗄️ DatabaseHelper: Atualizando paciente ID: $id');
    print('🗄️ DatabaseHelper: Dados: $paciente');
    
    // Verificar se o paciente existe antes de atualizar
    final existing = await db.query(
      _tablePacientes,
      where: 'id = ?',
      whereArgs: [id],
    );
    print('🔍 DatabaseHelper: Paciente existe? ${existing.isNotEmpty}');
    
    final result = await db.update(
      _tablePacientes,
      paciente,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    print('✅ DatabaseHelper: Update executado. Linhas afetadas: $result');
    
    // Verificar se a atualização foi bem-sucedida
    if (result == 0) {
      print('❌ DatabaseHelper: Nenhuma linha foi atualizada!');
    }
    
    return result;
  }

  Future<int> deletePaciente(String id) async {
    final db = await database;
    return await db.delete(
      _tablePacientes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para agendamentos
  Future<int> insertAgendamento(Map<String, dynamic> agendamento) async {
    final db = await database;
    print('🗄️ Inserindo agendamento no banco: ${agendamento['paciente_nome']} - ${agendamento['data_hora']}');
    final result = await db.insert(_tableAgendamentos, agendamento);
    print('✅ Agendamento inserido com ID: $result');
    return result;
  }

  Future<List<Map<String, dynamic>>> getAgendamentos() async {
    final db = await database;
    print('🔍 DatabaseHelper: Buscando todos os agendamentos');
    final result = await db.query(
      _tableAgendamentos,
      orderBy: 'data_hora ASC',
    );
    print('📊 DatabaseHelper: ${result.length} agendamentos encontrados na tabela');
    return result;
  }

  Future<List<Map<String, dynamic>>> getAgendamentosByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    print('🔍 DatabaseHelper: Buscando agendamentos para ${date.day}/${date.month}/${date.year}');
    print('🔍 DatabaseHelper: Período: ${startOfDay.millisecondsSinceEpoch} - ${endOfDay.millisecondsSinceEpoch}');
    
    final result = await db.query(
      _tableAgendamentos,
      where: 'data_hora >= ? AND data_hora < ?',
      whereArgs: [
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch,
      ],
      orderBy: 'data_hora ASC',
    );
    
    print('📊 DatabaseHelper: ${result.length} agendamentos encontrados para esta data');
    return result;
  }

  Future<List<Map<String, dynamic>>> getProximosAgendamentos() async {
    final db = await database;
    final now = DateTime.now();
    
    return await db.query(
      _tableAgendamentos,
      where: 'data_hora >= ? AND status != ?',
      whereArgs: [now.millisecondsSinceEpoch, 'cancelado'],
      orderBy: 'data_hora ASC',
      limit: 10,
    );
  }

  Future<List<Map<String, dynamic>>> getAgendamentosByPaciente(String pacienteId) async {
    final db = await database;
    return await db.query(
      _tableAgendamentos,
      where: 'paciente_id = ?',
      whereArgs: [pacienteId],
      orderBy: 'data_hora DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAgendamentosByTerapeuta(String terapeutaId) async {
    final db = await database;
    return await db.query(
      _tableAgendamentos,
      where: 'terapeuta_id = ?',
      whereArgs: [terapeutaId],
      orderBy: 'data_hora ASC',
    );
  }

  Future<Map<String, dynamic>?> getAgendamentoById(String id) async {
    final db = await database;
    final result = await db.query(
      _tableAgendamentos,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateAgendamento(String id, Map<String, dynamic> agendamento) async {
    final db = await database;
    return await db.update(
      _tableAgendamentos,
      agendamento,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAgendamento(String id) async {
    final db = await database;
    return await db.delete(
      _tableAgendamentos,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para fechar o banco
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Método para deletar o banco (útil para testes)
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // Método para limpar todas as tabelas (útil para testes)
  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete(_tableAgendamentos);
    await db.delete(_tablePacientes);
    await db.delete(_tableUsuarios);
  }
}
