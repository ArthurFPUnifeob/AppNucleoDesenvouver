import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:nucleo_desenvolver/main.dart';

/// Testes de widget para LoginScreen
/// Valida interface e funcionalidades da tela de login
void main() {
  group('LoginScreen Widget Tests', () {
    setUpAll(() {
      // Inicializar FFI para testes em ambiente isolado
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    testWidgets('deve exibir elementos da tela de login', (WidgetTester tester) async {
      // Arrange & Act - Carregar aplicativo
      await tester.pumpWidget(const MyApp());

      // Assert - Verificar elementos da tela de login
      expect(find.text('Núcleo Desenvolver'), findsOneWidget);
      expect(find.text('Bem-vindo de volta!'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Não tem uma conta?'), findsOneWidget);
      expect(find.text('Cadastre-se'), findsOneWidget);
    });

    testWidgets('deve permitir inserir email e senha', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act
      await tester.enterText(find.byType(TextField).first, 'test@email.com');
      await tester.enterText(find.byType(TextField).last, '123456');

      // Assert
      expect(find.text('test@email.com'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);
    });

    testWidgets('deve alternar visibilidade da senha', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byType(TextField).last, '123456');

      // Act
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('deve navegar para tela de cadastro', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act
      await tester.tap(find.text('Cadastre-se'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Cadastrar Terapeuta'), findsOneWidget);
    });

    testWidgets('deve mostrar loading ao fazer login', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byType(TextField).first, 'maria@nucleodesenvolver.com');
      await tester.enterText(find.byType(TextField).last, '123456');

      // Act
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve exibir mensagem de erro para credenciais inválidas', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byType(TextField).first, 'email@inexistente.com');
      await tester.enterText(find.byType(TextField).last, 'senhaErrada');

      // Act
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Email ou senha inválidos'), findsOneWidget);
    });

    testWidgets('deve fazer login com credenciais corretas', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byType(TextField).first, 'maria@nucleodesenvolver.com');
      await tester.enterText(find.byType(TextField).last, '123456');

      // Act
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Núcleo Desenvolver'), findsOneWidget); // Título do HomeScreen
    });
  });
}

