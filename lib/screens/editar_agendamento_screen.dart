import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/agendamento.dart';
import '../models/paciente.dart';
import '../models/usuario.dart';

class EditarAgendamentoScreen extends StatefulWidget {
  final Agendamento agendamento;
  
  const EditarAgendamentoScreen({super.key, required this.agendamento});

  @override
  State<EditarAgendamentoScreen> createState() => _EditarAgendamentoScreenState();
}

class _EditarAgendamentoScreenState extends State<EditarAgendamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _observacoesController = TextEditingController();

  String _status = '';
  String _tipoConsulta = '';
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  bool _isLoading = false;
  final DataService _dataService = DataService();

  // Opções disponíveis
  final List<String> _statusOptions = ['pendente', 'confirmado', 'cancelado', 'realizado'];
  final List<String> _tipoOptions = ['consulta', 'avaliacao', 'retorno', 'emergencia'];

  @override
  void initState() {
    super.initState();
    _loadAgendamentoData();
  }

  void _loadAgendamentoData() {
    _status = widget.agendamento.status;
    _tipoConsulta = widget.agendamento.tipoConsulta;
    _observacoesController.text = widget.agendamento.observacoes ?? '';
    _dataSelecionada = widget.agendamento.dataHora;
    _horaSelecionada = TimeOfDay.fromDateTime(widget.agendamento.dataHora);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF667EEA)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() => _dataSelecionada = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaSelecionada ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF667EEA)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _horaSelecionada) {
      setState(() => _horaSelecionada = picked);
    }
  }

  void _salvarAgendamento() async {
    if (_formKey.currentState!.validate()) {
      if (_dataSelecionada == null || _horaSelecionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione data e hora para o agendamento'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      try {
        setState(() => _isLoading = true);
        
        // Combinar data e hora
        final dataHora = DateTime(
          _dataSelecionada!.year,
          _dataSelecionada!.month,
          _dataSelecionada!.day,
          _horaSelecionada!.hour,
          _horaSelecionada!.minute,
        );

        // Criar agendamento atualizado
        final agendamentoAtualizado = widget.agendamento.copyWith(
          dataHora: dataHora,
          status: _status,
          tipoConsulta: _tipoConsulta,
          observacoes: _observacoesController.text.trim().isNotEmpty 
              ? _observacoesController.text.trim() 
              : null,
          updatedAt: DateTime.now(),
        );

        await _dataService.agendamentoRepository.updateAgendamento(agendamentoAtualizado);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Agendamento atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, agendamentoAtualizado);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar agendamento: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _cancelarAgendamento() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: const Text('Tem certeza que deseja cancelar este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sim, cancelar'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        setState(() => _isLoading = true);
        
        final agendamentoCancelado = widget.agendamento.copyWith(
          status: 'cancelado',
          updatedAt: DateTime.now(),
        );

        await _dataService.agendamentoRepository.updateAgendamento(agendamentoCancelado);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Agendamento cancelado com sucesso!'),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.pop(context, agendamentoCancelado);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao cancelar agendamento: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Agendamento'),
        backgroundColor: Colors.transparent,
        actions: [
          if (widget.agendamento.status != 'cancelado')
            TextButton(
              onPressed: _isLoading ? null : _cancelarAgendamento,
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações do Paciente e Terapeuta
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informações',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Paciente', widget.agendamento.pacienteNome),
                      _buildInfoRow('Terapeuta', widget.agendamento.terapeutaNome),
                      _buildInfoRow('Data/Hora', _formatDateTime(widget.agendamento.dataHora)),
                      _buildInfoRow('Status', _getStatusText(widget.agendamento.status)),
                      _buildInfoRow('Tipo', _getTipoText(widget.agendamento.tipoConsulta)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Data
              const Text(
                'Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    hintText: 'Selecione a data',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _dataSelecionada != null
                        ? '${_dataSelecionada!.day.toString().padLeft(2, '0')}/'
                              '${_dataSelecionada!.month.toString().padLeft(2, '0')}/'
                              '${_dataSelecionada!.year}'
                        : 'Selecione a data',
                    style: TextStyle(
                      color: _dataSelecionada != null
                          ? const Color(0xFF2C3E50)
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Hora
              const Text(
                'Hora',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectTime,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    hintText: 'Selecione a hora',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    _horaSelecionada != null
                        ? _horaSelecionada!.format(context)
                        : 'Selecione a hora',
                    style: TextStyle(
                      color: _horaSelecionada != null
                          ? const Color(0xFF2C3E50)
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Status
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.info_outline),
                ),
                items: _statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_getStatusText(status)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _status = value!);
                },
              ),
              const SizedBox(height: 24),

              // Tipo de Consulta
              const Text(
                'Tipo de Consulta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _tipoConsulta,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.medical_services_outlined),
                ),
                items: _tipoOptions.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(_getTipoText(tipo)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _tipoConsulta = value!);
                },
              ),
              const SizedBox(height: 24),

              // Observações
              const Text(
                'Observações',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _observacoesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Observações sobre o agendamento (opcional)',
                  prefixIcon: Icon(Icons.note_outlined),
                ),
              ),
              const SizedBox(height: 32),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _salvarAgendamento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667EEA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Salvar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
           '${dateTime.month.toString().padLeft(2, '0')}/'
           '${dateTime.year} - '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmado':
        return 'Confirmado';
      case 'pendente':
        return 'Pendente';
      case 'cancelado':
        return 'Cancelado';
      case 'realizado':
        return 'Realizado';
      default:
        return status;
    }
  }

  String _getTipoText(String tipo) {
    switch (tipo) {
      case 'consulta':
        return 'Consulta';
      case 'avaliacao':
        return 'Avaliação';
      case 'retorno':
        return 'Retorno';
      case 'emergencia':
        return 'Emergência';
      default:
        return tipo;
    }
  }

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }
}

