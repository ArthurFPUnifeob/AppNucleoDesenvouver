import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/paciente.dart';

class EditarPacienteScreen extends StatefulWidget {
  final Paciente paciente;
  
  const EditarPacienteScreen({super.key, required this.paciente});

  @override
  State<EditarPacienteScreen> createState() => _EditarPacienteScreenState();
}

class _EditarPacienteScreenState extends State<EditarPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _responsavelController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _observacoesController = TextEditingController();

  DateTime? _dataNascimento;
  String _genero = 'masculino';
  bool _isLoading = false;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadPacienteData();
  }

  void _loadPacienteData() {
    _nomeController.text = widget.paciente.nome;
    _dataNascimento = widget.paciente.dataNascimento;
    _genero = widget.paciente.genero;
    _responsavelController.text = widget.paciente.responsavel;
    _telefoneController.text = widget.paciente.telefone;
    _emailController.text = widget.paciente.email ?? '';
    _observacoesController.text = widget.paciente.observacoes ?? '';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime.now().subtract(const Duration(days: 365 * 5)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6FCF97)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dataNascimento) {
      setState(() => _dataNascimento = picked);
    }
  }

  void _salvarPaciente() async {
    if (_formKey.currentState!.validate()) {
      if (_dataNascimento == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione a data de nascimento do paciente'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      try {
        setState(() => _isLoading = true);
        
        // Criar paciente atualizado
        final email = _emailController.text.trim();
        final observacoes = _observacoesController.text.trim();
        
        final pacienteAtualizado = widget.paciente.copyWith(
          nome: _nomeController.text.trim(),
          dataNascimento: _dataNascimento!,
          genero: _genero,
          responsavel: _responsavelController.text.trim(),
          telefone: _telefoneController.text.trim(),
          email: email.isNotEmpty ? email : null,
          observacoes: observacoes.isNotEmpty ? observacoes : null,
          updatedAt: DateTime.now(),
        );

        print('🔄 Editando paciente: ${pacienteAtualizado.nome}');
        print('🔄 Dados do paciente: ${pacienteAtualizado.toMap()}');
        print('🔄 ID do paciente: ${pacienteAtualizado.id}');
        
        // Verificar se os dados estão diferentes do original
        print('🔄 Dados originais: ${widget.paciente.toMap()}');
        print('🔄 Dados atualizados: ${pacienteAtualizado.toMap()}');
        
        // Verificar se realmente há mudanças
        final hasChanges = widget.paciente.nome != pacienteAtualizado.nome ||
                          widget.paciente.responsavel != pacienteAtualizado.responsavel ||
                          widget.paciente.telefone != pacienteAtualizado.telefone ||
                          widget.paciente.email != pacienteAtualizado.email ||
                          widget.paciente.observacoes != pacienteAtualizado.observacoes;
        
        print('🔄 Há mudanças? $hasChanges');
        
        await _dataService.pacienteRepository.updatePaciente(pacienteAtualizado);
        
        print('✅ Paciente atualizado com sucesso no banco de dados');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Paciente atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, pacienteAtualizado); // Retorna o paciente atualizado
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar paciente: $e'),
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
        title: const Text('Editar Paciente'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              const Text(
                'Editar Paciente',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Altere os dados do paciente conforme necessário',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Nome do Paciente
              const Text(
                'Nome do Paciente',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  hintText: 'Digite o nome completo do paciente',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Data de Nascimento
              const Text(
                'Data de Nascimento',
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
                    hintText: 'Selecione a data de nascimento',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _dataNascimento != null
                        ? '${_dataNascimento!.day.toString().padLeft(2, '0')}/'
                              '${_dataNascimento!.month.toString().padLeft(2, '0')}/'
                              '${_dataNascimento!.year}'
                        : 'Selecione a data',
                    style: TextStyle(
                      color: _dataNascimento != null
                          ? const Color(0xFF2C3E50)
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Gênero
              const Text(
                'Gênero',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Masculino'),
                      value: 'masculino',
                      groupValue: _genero,
                      activeColor: const Color(0xFF6FCF97),
                      onChanged: (value) {
                        setState(() => _genero = value!);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Feminino'),
                      value: 'feminino',
                      groupValue: _genero,
                      activeColor: const Color(0xFF6FCF97),
                      onChanged: (value) {
                        setState(() => _genero = value!);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Responsável
              const Text(
                'Responsável',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _responsavelController,
                decoration: const InputDecoration(
                  hintText: 'Nome do responsável',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome do responsável é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Telefone
              const Text(
                'Telefone',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  hintText: 'Telefone de contato',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Telefone é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Email
              const Text(
                'Email (Opcional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email de contato (opcional)',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
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
                  hintText: 'Observações sobre o paciente (opcional)',
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
                      onPressed: _isLoading ? null : _salvarPaciente,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6FCF97),
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

  @override
  void dispose() {
    _nomeController.dispose();
    _responsavelController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }
}

