import '../database/database_helper.dart';
import '../models/paciente.dart';

class PacienteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Criar paciente
  Future<Paciente> createPaciente(Paciente paciente) async {
    print('📝 Repository: Criando paciente ${paciente.nome}');
    await _dbHelper.insertPaciente(paciente.toMap());
    print('✅ Repository: Paciente criado com sucesso');
    return paciente;
  }

  // Buscar paciente por ID
  Future<Paciente?> getPacienteById(String id) async {
    final map = await _dbHelper.getPacienteById(id);
    return map != null ? Paciente.fromMap(map) : null;
  }

  // Buscar todos os pacientes
  Future<List<Paciente>> getAllPacientes() async {
    final maps = await _dbHelper.getPacientes();
    return maps.map((map) => Paciente.fromMap(map)).toList();
  }

  // Buscar pacientes por nome ou responsável
  Future<List<Paciente>> searchPacientes(String query) async {
    final maps = await _dbHelper.searchPacientes(query);
    return maps.map((map) => Paciente.fromMap(map)).toList();
  }

  // Atualizar paciente
  Future<Paciente> updatePaciente(Paciente paciente) async {
    print('📝 Repository: Atualizando paciente ${paciente.nome} (ID: ${paciente.id})');
    final updatedPaciente = paciente.copyWith(
      updatedAt: DateTime.now(),
    );
    print('📝 Repository: Dados para atualização: ${updatedPaciente.toMap()}');
    
    final result = await _dbHelper.updatePaciente(paciente.id, updatedPaciente.toMap());
    print('✅ Repository: Paciente atualizado com sucesso. Linhas afetadas: $result');
    
    // Verificar se a atualização foi bem-sucedida
    if (result == 0) {
      print('❌ Repository: Nenhuma linha foi atualizada! Verificando se o paciente existe...');
      final existing = await getPacienteById(paciente.id);
      print('🔍 Repository: Paciente existe no banco? ${existing != null}');
      if (existing != null) {
        print('🔍 Repository: Dados atuais no banco: ${existing.toMap()}');
      }
    }
    
    return updatedPaciente;
  }

  // Deletar paciente
  Future<void> deletePaciente(String id) async {
    await _dbHelper.deletePaciente(id);
  }

  // Criar pacientes de exemplo para testes
  Future<void> createSamplePacientes() async {
    final samplePacientes = [
      Paciente(
        id: 'paciente-001',
        nome: 'João Silva',
        dataNascimento: DateTime(2012, 3, 15),
        genero: 'masculino',
        responsavel: 'Maria Silva',
        telefone: '(11) 99999-9999',
        email: 'maria.silva@email.com',
        observacoes: 'Paciente em acompanhamento semanal. Demonstra boa evolução.',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Paciente(
        id: 'paciente-002',
        nome: 'Ana Costa',
        dataNascimento: DateTime(2016, 7, 22),
        genero: 'feminino',
        responsavel: 'Carlos Costa',
        telefone: '(11) 88888-8888',
        email: 'carlos.costa@email.com',
        observacoes: 'Primeira consulta agendada. Avaliação inicial necessária.',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Paciente(
        id: 'paciente-003',
        nome: 'Pedro Santos',
        dataNascimento: DateTime(2014, 11, 8),
        genero: 'masculino',
        responsavel: 'Ana Santos',
        telefone: '(11) 77777-7777',
        observacoes: 'Paciente com histórico de ansiedade. Requer acompanhamento especializado.',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    for (final paciente in samplePacientes) {
      // Verificar se já existe
      final existing = await getPacienteById(paciente.id);
      if (existing == null) {
        await createPaciente(paciente);
      }
    }
  }
}
