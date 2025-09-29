import '../database/database_helper.dart';
import '../models/agendamento.dart';

class AgendamentoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Criar agendamento
  Future<Agendamento> createAgendamento(Agendamento agendamento) async {
    print('📝 Repository: Criando agendamento para ${agendamento.pacienteNome}');
    await _dbHelper.insertAgendamento(agendamento.toMap());
    print('✅ Repository: Agendamento criado com sucesso');
    return agendamento;
  }

  // Buscar agendamento por ID
  Future<Agendamento?> getAgendamentoById(String id) async {
    final map = await _dbHelper.getAgendamentoById(id);
    return map != null ? Agendamento.fromMap(map) : null;
  }

  // Buscar todos os agendamentos
  Future<List<Agendamento>> getAllAgendamentos() async {
    print('🔍 Repository: Buscando todos os agendamentos');
    final maps = await _dbHelper.getAgendamentos();
    print('📊 Repository: ${maps.length} agendamentos encontrados no banco');
    final agendamentos = maps.map((map) => Agendamento.fromMap(map)).toList();
    for (final agendamento in agendamentos) {
      print('   - ${agendamento.pacienteNome} - ${agendamento.dataHora}');
    }
    return agendamentos;
  }

  // Buscar agendamentos por data
  Future<List<Agendamento>> getAgendamentosByDate(DateTime date) async {
    print('🔍 Repository: Buscando agendamentos para ${date.day}/${date.month}/${date.year}');
    final maps = await _dbHelper.getAgendamentosByDate(date);
    print('📊 Repository: ${maps.length} agendamentos encontrados para esta data');
    return maps.map((map) => Agendamento.fromMap(map)).toList();
  }

  // Buscar próximos agendamentos
  Future<List<Agendamento>> getProximosAgendamentos() async {
    final maps = await _dbHelper.getProximosAgendamentos();
    return maps.map((map) => Agendamento.fromMap(map)).toList();
  }

  // Buscar agendamentos por paciente
  Future<List<Agendamento>> getAgendamentosByPaciente(String pacienteId) async {
    final maps = await _dbHelper.getAgendamentosByPaciente(pacienteId);
    return maps.map((map) => Agendamento.fromMap(map)).toList();
  }

  // Buscar agendamentos por terapeuta
  Future<List<Agendamento>> getAgendamentosByTerapeuta(String terapeutaId) async {
    final maps = await _dbHelper.getAgendamentosByTerapeuta(terapeutaId);
    return maps.map((map) => Agendamento.fromMap(map)).toList();
  }

  // Buscar agendamentos de hoje
  Future<List<Agendamento>> getAgendamentosHoje() async {
    final hoje = DateTime.now();
    return getAgendamentosByDate(hoje);
  }

  // Atualizar agendamento
  Future<Agendamento> updateAgendamento(Agendamento agendamento) async {
    final updatedAgendamento = agendamento.copyWith(
      updatedAt: DateTime.now(),
    );
    await _dbHelper.updateAgendamento(agendamento.id, updatedAgendamento.toMap());
    return updatedAgendamento;
  }

  // Atualizar status do agendamento
  Future<Agendamento> updateAgendamentoStatus(String id, String status) async {
    final agendamento = await getAgendamentoById(id);
    if (agendamento == null) {
      throw Exception('Agendamento não encontrado');
    }
    
    final updatedAgendamento = agendamento.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    
    await _dbHelper.updateAgendamento(id, updatedAgendamento.toMap());
    return updatedAgendamento;
  }

  // Deletar agendamento
  Future<void> deleteAgendamento(String id) async {
    await _dbHelper.deleteAgendamento(id);
  }

  // Cancelar agendamento
  Future<Agendamento> cancelAgendamento(String id) async {
    return await updateAgendamentoStatus(id, 'cancelado');
  }

  // Confirmar agendamento
  Future<Agendamento> confirmAgendamento(String id) async {
    return await updateAgendamentoStatus(id, 'confirmado');
  }

  // Marcar como realizado
  Future<Agendamento> markAsRealizado(String id) async {
    return await updateAgendamentoStatus(id, 'realizado');
  }

  // Criar agendamentos de exemplo para testes
  Future<void> createSampleAgendamentos() async {
    final sampleAgendamentos = [
      Agendamento(
        id: 'agendamento-001',
        pacienteId: 'paciente-001',
        pacienteNome: 'João Silva',
        terapeutaId: 'terapeuta-001',
        terapeutaNome: 'Dra. Maria Santos',
        dataHora: DateTime.now().add(const Duration(hours: 2)),
        status: 'confirmado',
        tipoConsulta: 'consulta',
        observacoes: 'Sessão de acompanhamento semanal',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Agendamento(
        id: 'agendamento-002',
        pacienteId: 'paciente-002',
        pacienteNome: 'Ana Costa',
        terapeutaId: 'terapeuta-001',
        terapeutaNome: 'Dra. Maria Santos',
        dataHora: DateTime.now().add(const Duration(days: 1, hours: 10)),
        status: 'pendente',
        tipoConsulta: 'avaliacao',
        observacoes: 'Primeira avaliação da paciente',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Agendamento(
        id: 'agendamento-003',
        pacienteId: 'paciente-003',
        pacienteNome: 'Pedro Santos',
        terapeutaId: 'terapeuta-001',
        terapeutaNome: 'Dra. Maria Santos',
        dataHora: DateTime.now().add(const Duration(days: 2, hours: 14)),
        status: 'confirmado',
        tipoConsulta: 'retorno',
        observacoes: 'Retorno após 2 semanas',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      // Agendamento de hoje
      Agendamento(
        id: 'agendamento-004',
        pacienteId: 'paciente-001',
        pacienteNome: 'João Silva',
        terapeutaId: 'terapeuta-001',
        terapeutaNome: 'Dra. Maria Santos',
        dataHora: DateTime.now().add(const Duration(hours: 3)),
        status: 'confirmado',
        tipoConsulta: 'consulta',
        observacoes: 'Consulta de hoje',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];

    for (final agendamento in sampleAgendamentos) {
      // Verificar se já existe
      final existing = await getAgendamentoById(agendamento.id);
      if (existing == null) {
        await createAgendamento(agendamento);
      }
    }
  }
}
