# Núcleo Desenvolver

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge" alt="Multi-Platform">
</div>

## 📋 Índice

- [1. Visão Geral](#1-visão-geral)
- [2. Funcionalidades](#2-funcionalidades)
- [3. Estrutura do Projeto](#3-estrutura-do-projeto)
- [4. Dependências](#4-dependências)
- [5. Como Executar](#5-como-executar)
- [6. Banco de Dados](#6-banco-de-dados)
- [7. Testes](#7-testes)

## 1. Visão Geral

O **Núcleo Desenvolver** é uma aplicação móvel desenvolvida em Flutter para gestão de pacientes e agendamentos em clínicas terapêuticas. O sistema permite que terapeutas gerenciem seus pacientes, agendem consultas e mantenham um controle organizado de suas atividades profissionais.

### 🎯 Objetivo
Facilitar a gestão de pacientes e agendamentos em clínicas terapêuticas, oferecendo uma interface intuitiva e moderna para profissionais da saúde mental.

### 👥 Público-Alvo
- **Psicólogos** e **terapeutas** que precisam organizar suas agendas
- **Clínicas de psicologia** que buscam digitalizar seus processos
- **Profissionais da saúde mental** que desejam melhorar a experiência do paciente

## 2. Funcionalidades

### 🔐 Autenticação e Usuários
- **Login seguro** com validação de credenciais
- **Cadastro de usuários** (pacientes e terapeutas)
- **Validação de email único** no sistema
- **Gestão de perfis** de usuário

### 👥 Gestão de Pacientes
- **CRUD completo** de pacientes
- **Busca por nome ou responsável** com filtro em tempo real
- **Informações detalhadas** (idade, responsável, contatos)
- **Histórico de observações** médicas
- **Edição de dados** com persistência no banco

### 📅 Gestão de Agendamentos
- **Criação de agendamentos** com paciente e terapeuta
- **Filtros por terapeuta logado** para dados personalizados
- **Status de agendamento** (confirmado, pendente, cancelado, realizado)
- **Tipos de consulta** (consulta, avaliação, retorno, emergência)
- **Cancelamento de consultas** com confirmação
- **Confirmação de consultas pendentes**

### 💬 Integração WhatsApp
- **Envio de mensagens** para pacientes com agendamentos pendentes
- **Mensagens pré-definidas** (lembrete, confirmação, checagem)
- **Personalização automática** com dados do paciente e consulta
- **Abertura direta** do WhatsApp com mensagem pronta

### 🎨 Interface e UX
- **Design responsivo** para diferentes tamanhos de tela
- **Material Design** com cores suaves (azul, verde, branco)
- **Navegação intuitiva** com bottom navigation
- **Feedback visual** para ações do usuário
- **Atualização dinâmica** de dados sem necessidade de refresh

## 3. Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados
│   ├── usuario.dart         # Modelo de usuário (terapeuta)
│   ├── paciente.dart        # Modelo de paciente
│   └── agendamento.dart     # Modelo de agendamento
├── database/                # Camada de persistência
│   └── database_helper.dart # Helper do banco SQLite
├── repositories/            # Camada de acesso a dados
│   ├── usuario_repository.dart
│   ├── paciente_repository.dart
│   └── agendamento_repository.dart
├── services/               # Serviços da aplicação
│   ├── data_service.dart   # Serviço de inicialização de dados
│   └── user_service.dart   # Serviço de usuário logado
└── screens/               # Telas da aplicação (em main.dart)
    ├── LoginScreen
    ├── CadastroScreen
    ├── HomeScreen
    ├── PacientesPage
    ├── AgendamentosPage
    ├── NovoAgendamentoScreen
    ├── CadastroPacienteScreen
    ├── EditarPacienteScreen
    ├── EditarAgendamentoScreen
    ├── DetalhePacienteScreen
    ├── DetalheAgendamentoScreen
    ├── ListaPacientesWhatsAppScreen
    └── PerfilPage
```

### 📱 Telas Principais
- **Login**: Autenticação de usuários
- **Cadastro**: Registro de novos usuários (terapeutas)
- **Home**: Dashboard principal com ações rápidas
- **Agenda**: Visualização e gestão de agendamentos
- **Pacientes**: Lista e gestão de pacientes
- **Novo Agendamento**: Criação de novos agendamentos
- **Cadastro de Paciente**: Registro de novos pacientes
- **Edição de Paciente**: Modificação de dados do paciente
- **Detalhes do Paciente**: Visualização completa dos dados
- **Detalhes do Agendamento**: Informações da consulta
- **WhatsApp**: Envio de mensagens para pacientes
- **Perfil**: Informações e configurações do usuário

## 4. Dependências

### 🚀 Framework Principal
- **Flutter 3.9.2+**: Framework multiplataforma para desenvolvimento mobile
- **Dart**: Linguagem de programação principal

### 🗄️ Persistência de Dados
- **sqflite 2.3.0**: Plugin Flutter para acesso ao SQLite
- **sqflite_common_ffi 2.3.0**: Para testes com SQLite em ambiente de desenvolvimento
- **path 1.8.3**: Manipulação de caminhos de arquivos

### 🔧 Ferramentas de Desenvolvimento
- **uuid 4.2.1**: Geração de identificadores únicos
- **url_launcher 6.2.1**: Integração com WhatsApp e outros apps
- **flutter_lints 5.0.0**: Análise estática de código
- **mockito 5.4.2**: Framework para testes com mocks
- **build_runner 2.4.7**: Geração de código para testes

### 🌐 Plataformas Suportadas
- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Chrome, Firefox, Safari, Edge

## 5. Como Executar

### 📋 Pré-requisitos
- **Flutter SDK 3.9.2+**: [Guia oficial do Flutter](https://flutter.dev/docs/get-started/install)
- **Android Studio** ou **VSCode** com extensão Flutter
- **Android SDK** (para desenvolvimento Android)
- **Xcode** (para desenvolvimento iOS - apenas macOS)

### 🚀 Passos para Execução

#### **1. Clone o Repositório**
```bash
git clone <url-do-repositorio>
cd nucleo_desenvolver
```

#### **2. Instale as Dependências**
```bash
flutter pub get
```

#### **3. Verifique a Configuração**
```bash
flutter doctor
```

#### **4. Execute o Projeto**

**Para Android:**
```bash
flutter run
# ou
flutter run -d android
```

**Para iOS (apenas macOS):**
```bash
flutter run -d ios
```

**Para Web:**
```bash
flutter run -d chrome
```

### 🔧 Build para Produção

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS (apenas macOS):**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 6. Banco de Dados

### 🗄️ Estrutura das Tabelas

#### **Tabela: usuarios**
Armazena informações dos terapeutas que utilizam o sistema.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | TEXT PRIMARY KEY | Identificador único do usuário |
| nome | TEXT NOT NULL | Nome completo do terapeuta |
| email | TEXT UNIQUE NOT NULL | Email único para login |
| senha | TEXT NOT NULL | Senha criptografada |
| tipo | TEXT NOT NULL | Tipo de usuário (terapeuta) |
| createdAt | TEXT NOT NULL | Data de criação do registro |
| updatedAt | TEXT NOT NULL | Data da última atualização |

#### **Tabela: pacientes**
Armazena informações dos pacientes atendidos pelos terapeutas.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | TEXT PRIMARY KEY | Identificador único do paciente |
| nome | TEXT NOT NULL | Nome completo do paciente |
| dataNascimento | TEXT NOT NULL | Data de nascimento |
| genero | TEXT NOT NULL | Gênero do paciente |
| responsavel | TEXT NOT NULL | Nome do responsável |
| telefone | TEXT NOT NULL | Telefone de contato |
| email | TEXT | Email de contato (opcional) |
| observacoes | TEXT | Observações médicas (opcional) |
| createdAt | TEXT NOT NULL | Data de criação do registro |
| updatedAt | TEXT NOT NULL | Data da última atualização |

#### **Tabela: agendamentos**
Armazena informações dos agendamentos de consultas.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | TEXT PRIMARY KEY | Identificador único do agendamento |
| pacienteId | TEXT NOT NULL | ID do paciente |
| terapeutaId | TEXT NOT NULL | ID do terapeuta |
| dataHora | TEXT NOT NULL | Data e hora da consulta |
| tipo | TEXT NOT NULL | Tipo de consulta |
| status | TEXT NOT NULL | Status do agendamento |
| observacoes | TEXT | Observações da consulta (opcional) |
| pacienteNome | TEXT NOT NULL | Nome do paciente (cache) |
| terapeutaNome | TEXT NOT NULL | Nome do terapeuta (cache) |
| createdAt | TEXT NOT NULL | Data de criação do registro |
| updatedAt | TEXT NOT NULL | Data da última atualização |

### 🔗 Relacionamentos
- **usuarios** ↔ **agendamentos**: Um terapeuta pode ter vários agendamentos
- **pacientes** ↔ **agendamentos**: Um paciente pode ter vários agendamentos
- **agendamentos**: Tabela de relacionamento entre terapeutas e pacientes

### 📊 Status dos Agendamentos
- **pendente**: Aguardando confirmação
- **confirmado**: Confirmado pelo paciente
- **realizado**: Consulta realizada
- **cancelado**: Cancelado pelo terapeuta ou paciente

### 🎯 Tipos de Consulta
- **consulta**: Consulta regular
- **avaliacao**: Avaliação inicial
- **retorno**: Consulta de retorno
- **emergencia**: Consulta de emergência

## 7. Testes

### 🧪 Estratégia de Testes

#### **Testes Unitários**
- **Repositórios**: Testes cobrindo CRUD e lógica de negócio
  - `UsuarioRepository`: Testes de autenticação e cadastro
  - `PacienteRepository`: Testes de CRUD de pacientes
  - `AgendamentoRepository`: Testes de agendamentos e filtros

#### **Testes de Widget**
- **Telas principais**: Testes de interface e navegação
  - `LoginScreen`: Testes de autenticação
  - `CadastroScreen`: Testes de cadastro de usuários
  - `PacientesPage`: Testes de listagem e filtros
  - `AgendamentosPage`: Testes de agendamentos
  - `WhatsAppScreen`: Testes de envio de mensagens

#### **Ferramentas de Teste**
- **flutter_test**: Framework oficial de testes do Flutter
- **sqflite_common_ffi**: Para testes com SQLite em ambiente de desenvolvimento
- **mockito**: Para criação de mocks em testes unitários

### 🚀 Execução dos Testes

```bash
# Executar todos os testes
flutter test

# Executar testes específicos
flutter test test/repositories/
flutter test test/widgets/

# Executar com cobertura
flutter test --coverage
```

### 📊 Cobertura de Testes
- **Repositórios**: 100% dos métodos CRUD testados
- **Validações**: Todos os cenários de erro cobertos
- **Navegação**: Fluxos principais de usuário testados
- **Integração**: Testes de integração com banco de dados

---

<div align="center">
  <p><strong>Núcleo Desenvolver</strong> - Gestão de Pacientes e Agendamentos</p>
  <p>Desenvolvido com ❤️ usando Flutter</p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev/)
  [![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat-square&logo=sqlite&logoColor=white)](https://sqlite.org/)
</div>
- **Design responsivo** para diferentes tamanhos de tela
- **Material Design** com cores suaves (azul, verde, branco)
- **Navegação intuitiva** com bottom navigation
- **Feedback visual** para ações do usuário

## 4. Tecnologias Utilizadas

### 🚀 Framework Principal
- **Flutter 3.9.2+**: Framework multiplataforma para desenvolvimento mobile
- **Dart**: Linguagem de programação principal

### 🗄️ Persistência de Dados
- **SQLite**: Banco de dados local para armazenamento offline
- **sqflite 2.3.0**: Plugin Flutter para acesso ao SQLite
- **path 1.8.3**: Manipulação de caminhos de arquivos

### 🔧 Ferramentas de Desenvolvimento
- **uuid 4.2.1**: Geração de identificadores únicos
- **flutter_lints 5.0.0**: Análise estática de código
- **mockito 5.4.2**: Framework para testes com mocks
- **build_runner 2.4.7**: Geração de código para testes

### 🌐 Plataformas Suportadas
- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Chrome, Firefox, Safari, Edge

## 5. Desenvolvimento do Protótipo

### 🎨 Escolhas de Design

#### **Material Design**
- Seguimos as diretrizes do Material Design para garantir consistência
- Componentes nativos do Flutter para melhor performance
- Animações suaves e transições intuitivas

#### **Paleta de Cores**
- **Azul Principal** (`#667EEA`): Cor primária para ações e destaque
- **Verde Secundário** (`#6FCF97`): Cor para pacientes e ações positivas
- **Branco** (`#FFFFFF`): Cor de fundo para clareza visual
- **Cinza Suave** (`#F5F7FA`): Fundo de telas para reduzir fadiga visual

#### **UX/UI**
- **Interface limpa** com foco na usabilidade
- **Navegação simplificada** com bottom navigation
- **Cards informativos** para melhor organização visual
- **Feedback imediato** para todas as ações do usuário

### 📱 Abordagem Responsiva
- **Design adaptativo** para diferentes tamanhos de tela
- **Layout flexível** que se ajusta automaticamente
- **Otimização para touch** em dispositivos móveis
- **Suporte a orientação** portrait e landscape

## 6. Testes

### 🧪 Estratégia de Testes

#### **Testes Unitários**
- **Repositórios**: 32 testes cobrindo CRUD e lógica de negócio
  - `UsuarioRepository`: 10 testes
  - `PacienteRepository`: 10 testes
  - `AgendamentoRepository`: 12 testes

#### **Testes de Widget**
- **Telas principais**: 23 testes de interface e navegação
  - `LoginScreen`: 7 testes
  - `CadastroScreen`: 9 testes
  - `PacientesPage`: 7 testes

#### **Ferramentas de Teste**
- **flutter_test**: Framework oficial de testes do Flutter
- **sqflite_common_ffi**: Para testes com SQLite em ambiente de desenvolvimento
- **mockito**: Para criação de mocks em testes unitários

### 📊 Cobertura de Testes
- **Repositórios**: 100% dos métodos CRUD testados
- **Validações**: Todos os cenários de erro cobertos
- **Navegação**: Fluxos principais de usuário testados
- **Integração**: Testes de integração com banco de dados

### 🚀 Execução dos Testes
```bash
# Executar todos os testes
flutter test

# Executar testes específicos
flutter test test/repositories/
flutter test test/widgets/

# Executar com cobertura
flutter test --coverage
```

## 7. Como Executar o Projeto

### 📋 Pré-requisitos

#### **Flutter SDK**
- **Versão**: Flutter 3.9.2 ou superior
- **Instalação**: [Guia oficial do Flutter](https://flutter.dev/docs/get-started/install)
- **Verificação**: `flutter doctor`

#### **Ambiente de Desenvolvimento**
- **Android Studio** ou **VSCode** com extensão Flutter
- **Android SDK** (para desenvolvimento Android)
- **Xcode** (para desenvolvimento iOS - apenas macOS)
- **Google Chrome** (para desenvolvimento Web)

#### **Dispositivos**
- **Emulador Android** ou **dispositivo físico** conectado
- **Simulador iOS** ou **iPhone/iPad** (apenas macOS)
- **Navegador Web** atualizado

### 🚀 Passos para Execução

#### **1. Clone o Repositório**
```bash
git clone <url-do-repositorio>
cd nucleo_desenvolver
```

#### **2. Instale as Dependências**
```bash
flutter pub get
```

#### **3. Verifique a Configuração**
```bash
flutter doctor
```

#### **4. Execute o Projeto**

**Para Android:**
```bash
flutter run
# ou
flutter run -d android
```

**Para iOS (apenas macOS):**
```bash
flutter run -d ios
```

**Para Web:**
```bash
flutter run -d chrome
```

### 🔧 Configurações Específicas

#### **Android**
```bash
# Verificar dispositivos conectados
flutter devices

# Executar em dispositivo específico
flutter run -d <device-id>
```

#### **iOS (macOS)**
```bash
# Abrir simulador iOS
open -a Simulator

# Executar no simulador
flutter run -d ios
```

#### **Web**
```bash
# Executar em modo debug
flutter run -d chrome --web-port 8080

# Build para produção
flutter build web
```

### 🐛 Resolução de Problemas

#### **Erro de Dependências**
```bash
flutter clean
flutter pub get
```

#### **Problemas com Emulador**
```bash
# Reiniciar emulador Android
adb kill-server
adb start-server
```

#### **Problemas de Cache**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

## 8. Estrutura do Projeto

### 📂 Organização de Arquivos

```
nucleo_desenvolver/
├── android/                 # Configurações Android
├── ios/                     # Configurações iOS
├── web/                     # Configurações Web
├── lib/                     # Código fonte principal
│   ├── main.dart           # Ponto de entrada
│   ├── models/             # Modelos de dados
│   ├── database/           # Camada de persistência
│   ├── repositories/       # Camada de acesso a dados
│   └── services/           # Serviços da aplicação
├── test/                   # Testes automatizados
│   ├── repositories/       # Testes de repositórios
│   ├── widgets/           # Testes de widgets
│   └── all_tests.dart     # Execução de todos os testes
├── pubspec.yaml           # Dependências do projeto
├── analysis_options.yaml  # Configurações de análise
└── README.md              # Documentação do projeto
```

## 9. Configuração do Banco de Dados

### 🔑 Credenciais Padrão

#### **Terapeuta de Teste**
- **Email**: `maria@nucleodesenvolver.com`
- **Senha**: `123456`

#### **Dados de Exemplo**
- **3 pacientes** pré-cadastrados
- **4 agendamentos** de exemplo
- **1 terapeuta** padrão

## 10. Roadmap

### 🎯 Versão Atual (v1.0.0)
- ✅ Sistema de autenticação
- ✅ CRUD de pacientes e agendamentos
- ✅ Interface responsiva
- ✅ Persistência local com SQLite
- ✅ Testes automatizados

### 🚀 Próximas Versões

#### **v1.1.0 - Melhorias de UX**
- [ ] Busca avançada de pacientes
- [ ] Filtros de agendamentos por período
- [ ] Notificações push
- [ ] Temas claro/escuro

#### **v2.0.0 - Integração com Backend**
- [ ] API REST para dados remotos
- [ ] Autenticação JWT
- [ ] Sincronização offline/online

## 12. Licença

Este projeto está licenciado sob a **MIT License**.