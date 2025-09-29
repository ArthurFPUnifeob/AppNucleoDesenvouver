import '../repositories/usuario_repository.dart';
import '../repositories/paciente_repository.dart';
import '../repositories/agendamento_repository.dart';
// Import necessário
import '../database/database_helper.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final UsuarioRepository _usuarioRepository = UsuarioRepository();
  final PacienteRepository _pacienteRepository = PacienteRepository();
  final AgendamentoRepository _agendamentoRepository = AgendamentoRepository();

  // Inicializar dados de exemplo
  Future<void> initializeSampleData() async {
    try {
      // Criar terapeuta padrão
      await _usuarioRepository.createDefaultTerapeuta();

      // Criar pacientes de exemplo
      await _pacienteRepository.createSamplePacientes();

      // Criar agendamentos de exemplo
      await _agendamentoRepository.createSampleAgendamentos();
    } catch (e) {
      print('Erro ao inicializar dados de exemplo: $e');
    }
  }

  // Limpar todos os dados (útil para testes)
  Future<void> clearAllData() async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.clearAllTables();
    } catch (e) {
      print('Erro ao limpar dados: $e');
    }
  }

  // Getters para os repositórios
  UsuarioRepository get usuarioRepository => _usuarioRepository;
  PacienteRepository get pacienteRepository => _pacienteRepository;
  AgendamentoRepository get agendamentoRepository => _agendamentoRepository;
}

