import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/paciente.dart';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  final DataService _dataService = DataService();
  List<Paciente> _pacientesAtendidos = [];
  int _consultasMes = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRelatorio();
  }

  Future<void> _loadRelatorio() async {
    try {
      // Buscar todos os pacientes
      final todosPacientes = await _dataService.pacienteRepository.getAllPacientes();
      
      // Buscar agendamentos realizados no mês atual
      final agora = DateTime.now();
      final inicioMes = DateTime(agora.year, agora.month, 1);
      final fimMes = DateTime(agora.year, agora.month + 1, 0);
      
      final todosAgendamentos = await _dataService.agendamentoRepository.getAllAgendamentos();
      final agendamentosMes = todosAgendamentos.where((ag) {
        return ag.dataHora.isAfter(inicioMes) && 
               ag.dataHora.isBefore(fimMes) && 
               ag.status == 'realizado';
      }).toList();

      setState(() {
        _pacientesAtendidos = todosPacientes;
        _consultasMes = agendamentosMes.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar relatório: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumo do mês
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Resumo do Mês',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Consultas Realizadas',
                                  _consultasMes.toString(),
                                  Icons.medical_services,
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Pacientes Cadastrados',
                                  _pacientesAtendidos.length.toString(),
                                  Icons.people,
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Lista de pacientes
                  const Text(
                    'Pacientes Cadastrados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_pacientesAtendidos.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Center(
                        child: Text(
                          'Nenhum paciente cadastrado',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else
                    ...(_pacientesAtendidos.map((paciente) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF6FCF97).withOpacity(0.1),
                            child: Text(
                              paciente.nome.substring(0, 1),
                              style: const TextStyle(
                                color: Color(0xFF6FCF97),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            paciente.nome,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${paciente.idade} anos • ${paciente.responsavel}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            paciente.genero == 'masculino' ? 'M' : 'F',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }).toList()),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

