import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:nucleo_desenvolver/main.dart';

/// Testes de widget para PacientesPage
/// Valida interface e funcionalidades da página de pacientes
void main() {
  group('PacientesPage Widget Tests', () {
    setUpAll(() {
      // Inicializar FFI para testes em ambiente isolado
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    testWidgets('deve exibir elementos da página de pacientes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Fazer login primeiro
      await tester.enterText(find.byType(TextField).first, 'maria@nucleodesenvolver.com');
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Navegar para página de pacientes
      await tester.tap(find.text('Pacientes'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Pacientes'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('deve exibir lista de pacientes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Fazer login
      await tester.enterText(find.byType(TextField).first, 'maria@nucleodesenvolver.com');
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Navegar para página de pacientes
      await tester.tap(find.text('Pacientes'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('Ana Costa'), findsOneWidget);
      expect(find.text('Pedro Santos'), findsOneWidget);
    });

    testWidgets('deve exibir informações dos pacientes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Fazer login
      await tester.enterText(find.byType(TextField).first, 'maria@nucleodesenvolver.com');
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Navegar para página de pacientes
      await tester.tap(find.text('Pacientes'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Idade:'), findsWidgets);
      expect(find.textContaining('Responsável:'), findsWidgets);
      expect(find.textContaining('Telefone:'), findsWidgets);
    });

    testWidgets('deve navegar para detalhes do paciente', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Fazer login
      await tester.enterText(find.byType(TextField).first, 'maria@nucleodesenvolver.com');
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Navegar para página de pacientes
      await tester.tap(find.text('Pacientes'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('João Silva'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Paciente: João Silva'), findsOneWidget);
      expect(find.text('Informações'), findsOneWidget);
      expect(find.text('Observações'), findsOneWidget);
    });

    testWidgets('deve navegar para cadastro de paciente', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Fazer login
      await tester.enterText(find.byType(TextField).first, 'maria@nucleodesenvolver.com');
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Navegar para página de pacientes
      await tester.tap(find.text('Pacientes'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Novo Paciente'), findsOneWidget);
      expect(find.text('Preencha os dados do paciente para cadastrar'), findsOneWidget);
    });

    testWidgets('deve exibir loading inicial', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Fazer login
      await tester.enterText(find.byType(TextField).first, 'maria@nucleodesenvolver.com');
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Act - Navegar para página de pacientes
      await tester.tap(find.text('Pacientes'));
      await tester.pump(); // Não usar pumpAndSettle para capturar o loading

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve recarregar lista após cadastrar paciente', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Fazer login
      await tester.enterText(find.byType(TextField).first, 'maria@nucleodesenvolver.com');
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Navegar para página de pacientes
      await tester.tap(find.text('Pacientes'));
      await tester.pumpAndSettle();

      // Contar pacientes iniciais
      final pacientesIniciais = find.textContaining('anos').evaluate().length;

      // Act - Cadastrar novo paciente
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('nome_paciente_field')), 'Maria Lima');
      await tester.enterText(find.byKey(const Key('responsavel_field')), 'Carlos Lima');
      await tester.enterText(find.byKey(const Key('telefone_field')), '11777777777');
      await tester.enterText(find.byKey(const Key('senha_field')), '123456');
      await tester.enterText(find.byKey(const Key('confirmar_senha_field')), '123456');

      await tester.tap(find.text('Cadastrar'));
      await tester.pumpAndSettle();

      // Assert
      final pacientesFinais = find.textContaining('anos').evaluate().length;
      expect(pacientesFinais, greaterThan(pacientesIniciais));
    });
  });
}

