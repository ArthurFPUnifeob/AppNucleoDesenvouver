import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../services/user_service.dart';
import '../models/usuario.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  DateTime? _dataNascimento;
  bool _obscureSenhaAtual = true;
  bool _obscureNovaSenha = true;
  bool _obscureConfirmarSenha = true;
  bool _isLoading = false;
  final DataService _dataService = DataService();
  final UserService _userService = UserService();

  Usuario? _usuarioAtual;

  @override
  void initState() {
    super.initState();
    _loadUsuarioData();
  }

  void _loadUsuarioData() {
    _usuarioAtual = _userService.currentUser;
    if (_usuarioAtual != null) {
      _nomeController.text = _usuarioAtual!.nome;
      _emailController.text = _usuarioAtual!.email;
      _telefoneController.text = _usuarioAtual!.telefone ?? '';
      _cpfController.text = _usuarioAtual!.cpf ?? '';

      _dataNascimento = _usuarioAtual!.dataNascimento;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _dataNascimento ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF667EEA)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dataNascimento) {
      setState(() => _dataNascimento = picked);
    }
  }

  void _salvarPerfil() async {
    if (_formKey.currentState!.validate()) {
      if (_dataNascimento == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione a data de nascimento'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Verificar se está alterando a senha
      bool alterandoSenha =
          _senhaAtualController.text.isNotEmpty ||
          _novaSenhaController.text.isNotEmpty ||
          _confirmarSenhaController.text.isNotEmpty;

      if (alterandoSenha) {
        // Validar senhas
        if (_senhaAtualController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Digite a senha atual para alterar'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        if (_novaSenhaController.text.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('A nova senha deve ter pelo menos 6 caracteres'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        if (_novaSenhaController.text != _confirmarSenhaController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('As senhas não coincidem'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
      }

      try {
        setState(() => _isLoading = true);

        // Criar usuário atualizado
        final usuarioAtualizado = _usuarioAtual!.copyWith(
          nome: _nomeController.text.trim(),
          email: _emailController.text.trim(),
          telefone: _telefoneController.text.trim(),
          cpf: _cpfController.text.trim(),
          dataNascimento: _dataNascimento!,
          senha: alterandoSenha
              ? _novaSenhaController.text
              : _usuarioAtual!.senha,
          updatedAt: DateTime.now(),
        );

        // Atualizar no banco de dados
        await _dataService.usuarioRepository.updateUsuario(usuarioAtualizado);

        // Atualizar no UserService
        _userService.setCurrentUser(usuarioAtualizado);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar perfil: $e'),
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
    if (_usuarioAtual == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
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
                'Editar Perfil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Atualize suas informações pessoais',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Nome
              const Text(
                'Nome Completo',
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
                  hintText: 'Digite seu nome completo',
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

              // Email
              const Text(
                'Email',
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
                  hintText: 'Digite seu email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email é obrigatório';
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
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
                  hintText: 'Digite seu telefone',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Telefone é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // CPF
              const Text(
                'CPF',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  hintText: 'Digite seu CPF',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'CPF é obrigatório';
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
                    hintText: 'Selecione sua data de nascimento',
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
              const SizedBox(height: 32),

              // Seção de Alteração de Senha
              const Text(
                'Alterar Senha (Opcional)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 16),

              // Senha Atual
              const Text(
                'Senha Atual',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _senhaAtualController,
                obscureText: _obscureSenhaAtual,
                decoration: InputDecoration(
                  hintText: 'Digite sua senha atual',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureSenhaAtual
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscureSenhaAtual = !_obscureSenhaAtual);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Nova Senha
              const Text(
                'Nova Senha',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _novaSenhaController,
                obscureText: _obscureNovaSenha,
                decoration: InputDecoration(
                  hintText: 'Digite sua nova senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNovaSenha
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscureNovaSenha = !_obscureNovaSenha);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Confirmar Nova Senha
              const Text(
                'Confirmar Nova Senha',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: _obscureConfirmarSenha,
                decoration: InputDecoration(
                  hintText: 'Confirme sua nova senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmarSenha
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(
                        () => _obscureConfirmarSenha = !_obscureConfirmarSenha,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _salvarPerfil,
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
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
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }
}

