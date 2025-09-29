import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

// Importar modelos de dados
import 'models/usuario.dart';
import 'models/paciente.dart';
import 'models/agendamento.dart';

// Importar serviços da aplicação
import 'services/data_service.dart';
import 'services/user_service.dart';
import 'screens/relatorio_screen.dart';
import 'screens/editar_paciente_screen.dart';
import 'screens/editar_agendamento_screen.dart';
import 'screens/editar_perfil_screen.dart';

/// Ponto de entrada da aplicação Núcleo Desenvolver
/// Inicializa os dados de exemplo e executa o aplicativo
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dados de exemplo para demonstração
  await DataService().initializeSampleData();

  runApp(const MyApp());
}

/// Widget principal da aplicação
/// Configura o tema e define a tela inicial
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Núcleo Desenvolver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF2C3E50),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ========== TELA DE LOGIN ==========

/// Tela de autenticação do sistema
/// Permite que terapeutas façam login com email e senha
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final DataService _dataService = DataService();

  /// Processa o login do usuário
  /// Valida credenciais e redireciona para a tela principal
  void _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      // Autenticar usuário
      final usuario = await _dataService.usuarioRepository.authenticate(
        _emailController.text.trim(),
        _senhaController.text,
      );

      if (usuario != null) {
        // Login bem-sucedido - definir usuário atual
        UserService().setCurrentUser(usuario);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        // Credenciais inválidas
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email ou senha inválidos'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Erro na autenticação
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer login: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF64B6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo/Ícone
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.psychology,
                          size: 48,
                          color: Color(0xFF667EEA),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Núcleo Desenvolver',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bem-vindo de volta!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),

                      // Campo Email
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo Senha
                      TextField(
                        controller: _senhaController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Botão Login
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
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
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Divider(height: 32),

                      // Link Cadastro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Não tem uma conta?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CadastroScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Cadastre-se',
                              style: TextStyle(
                                color: Color(0xFF667EEA),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========== TELA DE CADASTRO ==========
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  String _tipoUsuario = 'terapeuta';
  DateTime? _dataNascimento;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final DataService _dataService = DataService();

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
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

  void _handleCadastro() async {
    // Validar senhas
    if (_senhaController.text != _confirmaSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_senhaController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter pelo menos 6 caracteres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Verificar se email já existe
      final emailExists = await _dataService.usuarioRepository.emailExists(
        _emailController.text.trim(),
      );

      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este email já está cadastrado'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Criar usuário
      final usuario = Usuario(
        id: const Uuid().v4(),
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        tipo: _tipoUsuario,
        telefone: _telefoneController.text.trim().isNotEmpty
            ? _telefoneController.text.trim()
            : null,
        cpf: _cpfController.text.trim().isNotEmpty
            ? _cpfController.text.trim()
            : null,
        dataNascimento: _dataNascimento,
        senha: _senhaController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _dataService.usuarioRepository.createUsuario(usuario);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terapeuta cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar terapeuta: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Cadastro de Terapeuta'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cadastro de Terapeuta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Preencha os dados abaixo para se cadastrar como terapeuta',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Tipo de Usuário (apenas terapeuta)
                  const Text(
                    'Tipo de Usuário',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          color: const Color(0xFF667EEA),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Terapeuta',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF667EEA),
                                ),
                              ),
                              const Text(
                                'Profissional da saúde mental',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.check_circle,
                          color: const Color(0xFF667EEA),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dados Pessoais
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome Completo',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                      prefixIcon: Icon(Icons.badge_outlined),
                      hintText: 'Apenas números',
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: Icon(Icons.phone_outlined),
                      hintText: '(00) 00000-0000',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Data de Nascimento
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Data de Nascimento',
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
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Senha
                  TextField(
                    controller: _senhaController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _confirmaSenhaController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botão Cadastrar Terapeuta
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleCadastro,
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
                              'Cadastrar Terapeuta',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========== TELA INICIAL ==========
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const InicioPage(),
    const AgendamentosPage(),
    const PacientesPage(),
    const PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Pacientes',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// ========== PÁGINA INICIAL ==========
class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final DataService _dataService = DataService();
  int _consultasHoje = 0;
  List<Agendamento> _consultasPendentes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final currentUser = UserService().currentUser;
      if (currentUser == null) {
        setState(() {
          _consultasHoje = 0;
          _isLoading = false;
        });
        return;
      }

      final hoje = DateTime.now();
      final todosAgendamentosHoje = await _dataService.agendamentoRepository
          .getAgendamentosByDate(hoje);
      
      // Filtrar apenas agendamentos do terapeuta logado e que não foram cancelados/realizados
      final agendamentosHoje = todosAgendamentosHoje.where((agendamento) {
        return agendamento.terapeutaId == currentUser.id && 
               agendamento.status != 'cancelado' && 
               agendamento.status != 'realizado';
      }).toList();

      // Carregar consultas pendentes do terapeuta
      final todosAgendamentos = await _dataService.agendamentoRepository.getAllAgendamentos();
      final consultasPendentes = todosAgendamentos.where((agendamento) {
        return agendamento.terapeutaId == currentUser.id && 
               agendamento.status == 'pendente';
      }).toList();

      setState(() {
        _consultasHoje = agendamentosHoje.length;
        _consultasPendentes = consultasPendentes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Núcleo Desenvolver'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implementar tela de notificações
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de Boas-vindas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF64B6FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, ${UserService().currentUserName ?? 'Usuário'}!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLoading
                              ? 'Carregando...'
                              : 'Você tem $_consultasHoje consulta${_consultasHoje != 1 ? 's' : ''} hoje',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ações Rápidas
            const Text(
              'Ações Rápidas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildQuickActionCard(
                  context,
                  'Novo\nAgendamento',
                  Icons.add_circle_outline,
                  const Color(0xFF667EEA),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NovoAgendamentoScreen(),
                    ),
                  ),
                ),
                _buildQuickActionCard(
                  context,
                  'Cadastrar\nPaciente',
                  Icons.person_add_outlined,
                  const Color(0xFF6FCF97),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CadastroPacienteScreen(),
                    ),
                  ),
                ),
                _buildQuickActionCard(
                  context,
                  'Enviar\nWhatsApp',
                  Icons.message,
                  const Color(0xFF25D366),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ListaPacientesWhatsAppScreen(),
                    ),
                  ),
                ),
                _buildQuickActionCard(
                  context,
                  'Relatórios',
                  Icons.assessment_outlined,
                  const Color(0xFFFF6B6B),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RelatorioScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Consultas Pendentes
            if (_consultasPendentes.isNotEmpty) ...[
              const Text(
                'Consultas Pendentes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 16),
              ...(_consultasPendentes.map((agendamento) {
                final dateTime = agendamento.dataHora;
                final dateStr = '${dateTime.day.toString().padLeft(2, '0')}/'
                    '${dateTime.month.toString().padLeft(2, '0')} - '
                    '${dateTime.hour.toString().padLeft(2, '0')}:'
                    '${dateTime.minute.toString().padLeft(2, '0')}';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildConsultaPendenteCard(
                    agendamento.pacienteNome,
                    dateStr,
                    agendamento,
                  ),
                );
              }).toList()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultaPendenteCard(
    String nome,
    String horario,
    Agendamento agendamento,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.orange.withOpacity(0.1),
            child: Text(
              nome.substring(0, 1),
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      horario,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _confirmarConsulta(agendamento),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Confirmar',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarConsulta(Agendamento agendamento) async {
    try {
      await _dataService.agendamentoRepository.confirmAgendamento(agendamento.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Consulta confirmada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Recarregar dados do dashboard
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao confirmar consulta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}

// ========== PÁGINA DE AGENDAMENTOS ==========
class AgendamentosPage extends StatefulWidget {
  const AgendamentosPage({super.key});

  @override
  State<AgendamentosPage> createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> {
  DateTime _selectedDate = DateTime.now();
  final DataService _dataService = DataService();
  List<Agendamento> _agendamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAgendamentos();
  }

  Future<void> _loadAgendamentos() async {
    try {
      final currentUser = UserService().currentUser;
      if (currentUser == null) {
        setState(() {
          _agendamentos = [];
          _isLoading = false;
        });
        return;
      }

      final agendamentos = await _dataService.agendamentoRepository
          .getAgendamentosByTerapeuta(currentUser.id);
      setState(() {
        _agendamentos = agendamentos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar agendamentos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Agendamentos")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Agendamentos")),
      body: _agendamentos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum agendamento encontrado',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _agendamentos.length,
              itemBuilder: (context, index) {
                final agendamento = _agendamentos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(
                        agendamento.status,
                      ).withOpacity(0.1),
                      child: Icon(
                        _getStatusIcon(agendamento.status),
                        color: _getStatusColor(agendamento.status),
                      ),
                    ),
                    title: Text(
                      agendamento.pacienteNome,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Terapeuta: ${agendamento.terapeutaNome}"),
                        const SizedBox(height: 2),
                        Text("Data: ${_formatDateTime(agendamento.dataHora)}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalheAgendamentoScreen(
                              agendamento: agendamento,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF667EEA),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NovoAgendamentoScreen()),
          );
          // Recarregar agendamentos quando voltar
          _loadAgendamentos();
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmado':
        return Colors.green;
      case 'pendente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'confirmado':
        return Icons.check_circle;
      case 'pendente':
        return Icons.schedule;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')} - '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// ========== DETALHE DO AGENDAMENTO ==========
class DetalheAgendamentoScreen extends StatefulWidget {
  final Agendamento agendamento;

  const DetalheAgendamentoScreen({super.key, required this.agendamento});

  @override
  State<DetalheAgendamentoScreen> createState() => _DetalheAgendamentoScreenState();
}

class _DetalheAgendamentoScreenState extends State<DetalheAgendamentoScreen> {
  late Agendamento _agendamento;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _agendamento = widget.agendamento;
  }

  Future<void> _atualizarAgendamento() async {
    try {
      final agendamentoAtualizado = await _dataService.agendamentoRepository.getAgendamentoById(_agendamento.id);
      if (agendamentoAtualizado != null) {
        setState(() {
          _agendamento = agendamentoAtualizado;
        });
      }
    } catch (e) {
      print('❌ Erro ao atualizar agendamento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes da Consulta")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Paciente: ${_agendamento.pacienteNome}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Terapeuta: ${_agendamento.terapeutaNome}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text("Data/Hora: ${_agendamento.dataHora}"),
            const SizedBox(height: 12),
            Text("Status: ${_agendamento.status}"),
            if (_agendamento.observacoes != null) ...[
              const SizedBox(height: 12),
              Text("Obs: ${_agendamento.observacoes!}"),
            ],
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final agendamentoAtualizado =
                          await Navigator.push<Agendamento>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarAgendamentoScreen(
                                agendamento: _agendamento,
                              ),
                            ),
                          );
                      if (agendamentoAtualizado != null) {
                        await _atualizarAgendamento();
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Editar"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Mostrar diálogo de confirmação
                      final bool? confirmar = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Cancelar Consulta'),
                            content: const Text(
                              'Tem certeza que deseja cancelar esta consulta? Esta ação não pode ser desfeita.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Não'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Sim, Cancelar'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmar == true) {
                        try {
                          await _dataService.agendamentoRepository.cancelAgendamento(_agendamento.id);
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Consulta cancelada com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Atualizar o agendamento localmente
                            await _atualizarAgendamento();
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao cancelar consulta: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label: const Text(
                      "Cancelar Consulta",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ========== PERFIL ==========
class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meu Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF667EEA),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              UserService().currentUserName ?? "Usuário",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              UserService().currentUserType == 'terapeuta'
                  ? "Terapeuta"
                  : "Paciente",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Editar Perfil"),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditarPerfilScreen()),
                );
                // Recarregar a página para mostrar dados atualizados
                if (mounted) {
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              onTap: () {
                // Implementar logout com limpeza de dados
                UserService().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ========== PÁGINA DE PACIENTES ==========
class PacientesPage extends StatefulWidget {
  const PacientesPage({super.key});

  @override
  State<PacientesPage> createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  final DataService _dataService = DataService();
  List<Paciente> _pacientes = [];
  List<Paciente> _pacientesFiltrados = [];
  bool _isLoading = true;
  String _queryBusca = '';

  @override
  void initState() {
    super.initState();
    _loadPacientes();
  }

  Future<void> _loadPacientes() async {
    try {
      final pacientes = await _dataService.pacienteRepository.getAllPacientes();
      setState(() {
        _pacientes = pacientes;
        _pacientesFiltrados = pacientes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar pacientes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filtrarPacientes(String query) async {
    setState(() {
      _queryBusca = query;
    });

    if (query.isEmpty) {
      setState(() {
        _pacientesFiltrados = _pacientes;
      });
    } else {
      try {
        final pacientesFiltrados = await _dataService.pacienteRepository.searchPacientes(query);
        setState(() {
          _pacientesFiltrados = pacientesFiltrados;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao buscar pacientes: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _mostrarDialogoBusca() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController searchController = TextEditingController(text: _queryBusca);
        return AlertDialog(
          title: const Text('Buscar Pacientes'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Digite o nome do paciente',
              prefixIcon: Icon(Icons.search),
            ),
            autofocus: true,
            onChanged: (value) {
              _filtrarPacientes(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _filtrarPacientes('');
                Navigator.of(context).pop();
              },
              child: const Text('Limpar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _mostrarDialogoBusca();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pacientesFiltrados.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    _queryBusca.isEmpty 
                        ? 'Nenhum paciente cadastrado'
                        : 'Nenhum paciente encontrado para "$_queryBusca"',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  if (_queryBusca.isNotEmpty) ...[
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _filtrarPacientes('');
                      },
                      child: Text('Limpar filtro'),
                    ),
                  ],
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pacientesFiltrados.length,
              itemBuilder: (context, index) {
                final paciente = _pacientesFiltrados[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF6FCF97).withOpacity(0.1),
                      child: Text(
                        paciente.nome.substring(0, 1),
                        style: const TextStyle(
                          color: Color(0xFF6FCF97),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      paciente.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Idade: ${paciente.idade} anos'),
                        Text('Responsável: ${paciente.responsavel}'),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Telefone: ${paciente.telefone}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetalhePacienteScreen(paciente: paciente),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6FCF97),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroPacienteScreen()),
          );
          // Recarregar lista após cadastrar
          _loadPacientes();
        },
      ),
    );
  }
}

// ========== DETALHE DO PACIENTE ==========
class DetalhePacienteScreen extends StatefulWidget {
  final Paciente paciente;

  const DetalhePacienteScreen({super.key, required this.paciente});

  @override
  State<DetalhePacienteScreen> createState() => _DetalhePacienteScreenState();
}

class _DetalhePacienteScreenState extends State<DetalhePacienteScreen> {
  late Paciente _paciente;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _paciente = widget.paciente;
  }

  Future<void> _recarregarPaciente() async {
    try {
      final pacienteAtualizado = await _dataService.pacienteRepository.getPacienteById(_paciente.id);
      if (pacienteAtualizado != null) {
        setState(() {
          _paciente = pacienteAtualizado;
        });
        print('✅ Paciente recarregado do banco de dados');
        
        // Mostrar feedback visual de atualização
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dados do paciente atualizados!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Erro ao recarregar paciente: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar dados: $e'),
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
        title: Text("Paciente: ${_paciente.nome}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card do Paciente
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF6FCF97).withOpacity(0.1),
                      child: Text(
                        _paciente.nome.substring(0, 1),
                        style: const TextStyle(
                          color: Color(0xFF6FCF97),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _paciente.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_paciente.idade} anos',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Informações
            const Text(
              'Informações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),

            _buildInfoCard(
              'Responsável',
              _paciente.responsavel,
              Icons.person_outline,
              const Color(0xFF667EEA),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              'Telefone',
              _paciente.telefone,
              Icons.phone_outlined,
              const Color(0xFF6FCF97),
            ),
            const SizedBox(height: 12),

            if (_paciente.email != null) ...[
              _buildInfoCard(
                'Email',
                _paciente.email!,
                Icons.email_outlined,
                const Color(0xFFFF6B6B),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 24),

            // Observações
            const Text(
              'Observações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Text(
                _paciente.observacoes ?? 'Nenhuma observação registrada',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),

            // Ações
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final pacienteAtualizado = await Navigator.push<Paciente>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditarPacienteScreen(paciente: _paciente),
                        ),
                      );
                      if (pacienteAtualizado != null) {
                        // Recarregar dados do banco para garantir que está atualizado
                        await _recarregarPaciente();
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NovoAgendamentoScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667EEA),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Nova Consulta',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ========== NOVO AGENDAMENTO ==========
class NovoAgendamentoScreen extends StatefulWidget {
  const NovoAgendamentoScreen({super.key});

  @override
  State<NovoAgendamentoScreen> createState() => _NovoAgendamentoScreenState();
}

class _NovoAgendamentoScreenState extends State<NovoAgendamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _observacoesController = TextEditingController();
  final DataService _dataService = DataService();

  String _pacienteSelecionado = '';
  String _terapeutaSelecionado = '';
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  String _tipoConsulta = 'consulta';

  List<Paciente> _pacientes = [];
  List<Usuario> _terapeutas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final pacientes = await _dataService.pacienteRepository.getAllPacientes();
      final terapeutas = await _dataService.usuarioRepository.getTerapeutas();

      setState(() {
        _pacientes = pacientes;
        _terapeutas = terapeutas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Novo Agendamento')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Agendamento'),
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
                'Agendar Nova Consulta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Preencha os dados para criar um novo agendamento',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Seleção de Paciente
              const Text(
                'Paciente',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _pacienteSelecionado.isEmpty
                    ? null
                    : _pacienteSelecionado,
                decoration: const InputDecoration(
                  hintText: 'Selecione um paciente',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: _pacientes.map((paciente) {
                  return DropdownMenuItem<String>(
                    value: paciente.id,
                    child: Text(paciente.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _pacienteSelecionado = value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione um paciente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Seleção de Terapeuta
              const Text(
                'Terapeuta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _terapeutaSelecionado.isEmpty
                    ? null
                    : _terapeutaSelecionado,
                decoration: const InputDecoration(
                  hintText: 'Selecione um terapeuta',
                  prefixIcon: Icon(Icons.psychology_outlined),
                ),
                items: _terapeutas.map((terapeuta) {
                  return DropdownMenuItem<String>(
                    value: terapeuta.id,
                    child: Text(terapeuta.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _terapeutaSelecionado = value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione um terapeuta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Data da Consulta
              const Text(
                'Data da Consulta',
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
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Hora da Consulta
              const Text(
                'Hora da Consulta',
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
                        ? '${_horaSelecionada!.hour.toString().padLeft(2, '0')}:'
                              '${_horaSelecionada!.minute.toString().padLeft(2, '0')}'
                        : 'Selecione a hora',
                    style: TextStyle(
                      color: _horaSelecionada != null
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ),
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
                items: const [
                  DropdownMenuItem(value: 'consulta', child: Text('Consulta')),
                  DropdownMenuItem(
                    value: 'avaliacao',
                    child: Text('Avaliação'),
                  ),
                  DropdownMenuItem(value: 'retorno', child: Text('Retorno')),
                  DropdownMenuItem(
                    value: 'emergencia',
                    child: Text('Emergência'),
                  ),
                ],
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
                  hintText: 'Observações sobre a consulta (opcional)',
                  prefixIcon: Icon(Icons.note_outlined),
                ),
              ),
              const SizedBox(height: 32),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvarAgendamento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667EEA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Agendar',
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
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
      if (_dataSelecionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione uma data para a consulta'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (_horaSelecionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione uma hora para a consulta'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (_pacienteSelecionado.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione um paciente'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (_terapeutaSelecionado.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione um terapeuta'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      try {
        // Encontrar paciente e terapeuta selecionados
        final paciente = _pacientes.firstWhere(
          (p) => p.id == _pacienteSelecionado,
        );
        final terapeuta = _terapeutas.firstWhere(
          (t) => t.id == _terapeutaSelecionado,
        );

        // Combinar data e hora
        final dataHora = DateTime(
          _dataSelecionada!.year,
          _dataSelecionada!.month,
          _dataSelecionada!.day,
          _horaSelecionada!.hour,
          _horaSelecionada!.minute,
        );

        // Criar agendamento
        final agendamento = Agendamento(
          id: const Uuid().v4(),
          pacienteId: paciente.id,
          pacienteNome: paciente.nome,
          terapeutaId: terapeuta.id,
          terapeutaNome: terapeuta.nome,
          dataHora: dataHora,
          status: 'pendente',
          tipoConsulta: _tipoConsulta,
          observacoes: _observacoesController.text.trim().isNotEmpty
              ? _observacoesController.text.trim()
              : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _dataService.agendamentoRepository.createAgendamento(agendamento);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Agendamento criado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao criar agendamento: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

// ========== CADASTRO DE PACIENTE ==========
class CadastroPacienteScreen extends StatefulWidget {
  const CadastroPacienteScreen({super.key});

  @override
  State<CadastroPacienteScreen> createState() => _CadastroPacienteScreenState();
}

class _CadastroPacienteScreenState extends State<CadastroPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _responsavelController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _observacoesController = TextEditingController();

  DateTime? _dataNascimento;
  String _genero = 'masculino';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Paciente'),
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
                'Novo Paciente',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Preencha os dados do paciente para cadastrar',
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
                          ? Colors.black87
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

              // Nome do Responsável
              const Text(
                'Nome do Responsável',
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
                  hintText: 'Digite o nome do responsável',
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
                'Telefone de Contato',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  hintText: '(00) 00000-0000',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Telefone é obrigatório';
                  }
                  if (value.length < 10) {
                    return 'Telefone deve ter pelo menos 10 dígitos';
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
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Digite o email para contato',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
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
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvarPaciente,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6FCF97),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cadastrar',
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
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
        final dataService = DataService();

        // Criar paciente
        final paciente = Paciente(
          id: const Uuid().v4(),
          nome: _nomeController.text.trim(),
          dataNascimento: _dataNascimento!,
          genero: _genero,
          responsavel: _responsavelController.text.trim(),
          telefone: _telefoneController.text.trim(),
          email: _emailController.text.trim().isNotEmpty
              ? _emailController.text.trim()
              : null,
          observacoes: _observacoesController.text.trim().isNotEmpty
              ? _observacoesController.text.trim()
              : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await dataService.pacienteRepository.createPaciente(paciente);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Paciente cadastrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao cadastrar paciente: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

// ========== LISTA DE PACIENTES PARA WHATSAPP ==========
class ListaPacientesWhatsAppScreen extends StatefulWidget {
  const ListaPacientesWhatsAppScreen({super.key});

  @override
  State<ListaPacientesWhatsAppScreen> createState() => _ListaPacientesWhatsAppScreenState();
}

class _ListaPacientesWhatsAppScreenState extends State<ListaPacientesWhatsAppScreen> {
  final DataService _dataService = DataService();
  List<Paciente> _pacientes = [];
  List<Agendamento> _agendamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPacientesComTelefone();
  }

  Future<void> _loadPacientesComTelefone() async {
    try {
      // Obter terapeuta logado
      final currentUser = UserService().currentUser;
      if (currentUser == null) {
        setState(() {
          _pacientes = [];
          _agendamentos = [];
          _isLoading = false;
        });
        return;
      }

      // Buscar agendamentos do terapeuta logado
      final agendamentosTerapeuta = await _dataService.agendamentoRepository
          .getAgendamentosByTerapeuta(currentUser.id);
      
      // Filtrar apenas agendamentos pendentes
      final agendamentosPendentes = agendamentosTerapeuta.where((agendamento) {
        return agendamento.status == 'pendente';
      }).toList();

      // Obter IDs únicos dos pacientes com agendamentos pendentes
      final pacientesIds = agendamentosPendentes
          .map((agendamento) => agendamento.pacienteId)
          .toSet()
          .toList();

      // Buscar pacientes que têm telefone e agendamentos pendentes
      final pacientesComTelefone = <Paciente>[];
      for (final pacienteId in pacientesIds) {
        final paciente = await _dataService.pacienteRepository.getPacienteById(pacienteId);
        if (paciente != null && paciente.telefone.isNotEmpty) {
          pacientesComTelefone.add(paciente);
        }
      }

      setState(() {
        _pacientes = pacientesComTelefone;
        _agendamentos = agendamentosPendentes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar pacientes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Agendamento? _getProximaConsulta(String pacienteId) {
    final agora = DateTime.now();
    final consultasPendentes = _agendamentos.where((agendamento) {
      return agendamento.pacienteId == pacienteId && 
             agendamento.status == 'pendente';
    }).toList();

    if (consultasPendentes.isEmpty) return null;

    // Ordenar por data/hora e pegar o mais próximo
    consultasPendentes.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    return consultasPendentes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar WhatsApp'),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pacientes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum paciente com agendamento pendente',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cadastre agendamentos com status "pendente" para enviar WhatsApp',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pacientes.length,
              itemBuilder: (context, index) {
                final paciente = _pacientes[index];
                final proximaConsulta = _getProximaConsulta(paciente.id);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF25D366).withOpacity(0.1),
                      child: Text(
                        paciente.nome.substring(0, 1),
                        style: const TextStyle(
                          color: Color(0xFF25D366),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      paciente.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              paciente.telefone,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (proximaConsulta != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Próxima: ${_formatDateTime(proximaConsulta.dataHora)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 2),
                          const Text(
                            'Nenhum agendamento pendente',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () => _mostrarOpcoesMensagem(paciente, proximaConsulta),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.message, size: 16),
                      label: const Text('Enviar', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')} - '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _mostrarOpcoesMensagem(Paciente paciente, Agendamento? proximaConsulta) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enviar WhatsApp para ${paciente.nome}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Escolha o tipo de mensagem:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              _buildOpcaoMensagem(
                'Lembrete',
                'Lembrar sobre consulta agendada',
                Icons.schedule,
                () => _enviarMensagem(paciente, proximaConsulta, 'lembrete'),
              ),
              const SizedBox(height: 8),
              _buildOpcaoMensagem(
                'Confirmação',
                'Confirmar registro da consulta',
                Icons.check_circle,
                () => _enviarMensagem(paciente, proximaConsulta, 'confirmacao'),
              ),
              const SizedBox(height: 8),
              _buildOpcaoMensagem(
                'Checagem',
                'Verificar se horário está adequado',
                Icons.help_outline,
                () => _enviarMensagem(paciente, proximaConsulta, 'checagem'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOpcaoMensagem(String titulo, String descricao, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF25D366), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    descricao,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _enviarMensagem(Paciente paciente, Agendamento? proximaConsulta, String tipo) {
    String mensagem = '';
    
    switch (tipo) {
      case 'lembrete':
        if (proximaConsulta != null) {
          mensagem = 'Olá ${paciente.nome}, estamos passando para lembrar que sua consulta está agendada para ${_formatData(proximaConsulta.dataHora)} às ${_formatHora(proximaConsulta.dataHora)}.';
        } else {
          mensagem = 'Olá ${paciente.nome}, gostaríamos de entrar em contato para agendar uma consulta.';
        }
        break;
      case 'confirmacao':
        mensagem = 'Sua consulta foi registrada no nosso sistema, ${paciente.nome}. Nos vemos em breve!';
        break;
      case 'checagem':
        if (proximaConsulta != null) {
          mensagem = 'Oi ${paciente.nome}, gostaríamos de confirmar se o horário ${_formatData(proximaConsulta.dataHora)} às ${_formatHora(proximaConsulta.dataHora)} continua adequado para você.';
        } else {
          mensagem = 'Oi ${paciente.nome}, gostaríamos de confirmar se você tem disponibilidade para agendar uma consulta.';
        }
        break;
    }

    _abrirWhatsApp(paciente.telefone, mensagem);
    Navigator.of(context).pop();
  }

  String _formatData(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}';
  }

  String _formatHora(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _abrirWhatsApp(String telefone, String mensagem) async {
    try {
      // Remover todos os caracteres que não sejam dígitos
      final numeroLimpo = telefone.replaceAll(RegExp(r'[^0-9]'), '');
      
      // Validar se o número tem pelo menos 10 dígitos (DDD + número)
      if (numeroLimpo.length < 10) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Número de telefone inválido. Deve ter pelo menos 10 dígitos.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }
      
      // Adicionar código do país 55 (Brasil) se não estiver presente
      String numeroFormatado;
      if (numeroLimpo.startsWith('55')) {
        numeroFormatado = numeroLimpo;
      } else {
        numeroFormatado = '55$numeroLimpo';
      }
      
      // Validar se o número final tem pelo menos 12 dígitos (55 + DDD + número)
      if (numeroFormatado.length < 12) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Número de telefone incompleto. Verifique o DDD e o número.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }
      
      final url = 'https://wa.me/$numeroFormatado?text=${Uri.encodeComponent(mensagem)}';
      
      print('📱 Telefone original: $telefone');
      print('📱 Telefone limpo: $numeroLimpo');
      print('📱 Telefone formatado: $numeroFormatado');
      print('📱 URL WhatsApp: $url');
      
      // Tentar diferentes modos de abertura
      bool sucesso = false;
      
      // Primeira tentativa: LaunchMode.externalApplication
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
          sucesso = true;
          print('✅ WhatsApp aberto com LaunchMode.externalApplication');
        }
      } catch (e) {
        print('❌ Erro com LaunchMode.externalApplication: $e');
      }
      
      // Segunda tentativa: LaunchMode.platformDefault
      if (!sucesso) {
        try {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.platformDefault,
            );
            sucesso = true;
            print('✅ WhatsApp aberto com LaunchMode.platformDefault');
          }
        } catch (e) {
          print('❌ Erro com LaunchMode.platformDefault: $e');
        }
      }
      
      // Terceira tentativa: Sem modo específico
      if (!sucesso) {
        try {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
            sucesso = true;
            print('✅ WhatsApp aberto sem modo específico');
          }
        } catch (e) {
          print('❌ Erro sem modo específico: $e');
        }
      }
      
      if (sucesso) {
        // Mostrar feedback de sucesso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('WhatsApp aberto com sucesso!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Mostrar URL para o usuário copiar manualmente
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('WhatsApp não pôde ser aberto automaticamente'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Copie o link abaixo e cole no seu navegador:'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: SelectableText(
                        url,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Copiar para área de transferência
                      Clipboard.setData(ClipboardData(text: url));
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link copiado para a área de transferência!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('Copiar Link'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print('❌ Erro geral ao abrir WhatsApp: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir WhatsApp: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}
