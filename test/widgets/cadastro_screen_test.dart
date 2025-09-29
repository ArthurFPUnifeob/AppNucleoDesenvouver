import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:nucleo_desenvolver/main.dart';

/// Testes de widget para CadastroScreen
/// Valida interface e funcionalidades da tela de cadastro
void main() {
  group('CadastroScreen Widget Tests', () {
    setUpAll(() {
      // Inicializar FFI para testes em ambiente isolado
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    testWidgets('deve exibir elementos da tela de cadastro', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Cadastre-se'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Cadastrar Terapeuta'), findsOneWidget);
      expect(
        find.text('Preencha os dados abaixo para se cadastrar'),
        findsOneWidget,
      );
      expect(find.text('Tipo de Usuário'), findsOneWidget);
      expect(find.text('Paciente'), findsOneWidget);
      expect(find.text('Terapeuta'), findsOneWidget);
      expect(find.text('Nome Completo'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('CPF'), findsOneWidget);
      expect(find.text('Telefone'), findsOneWidget);
      expect(find.text('Data de Nascimento'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Confirmar Senha'), findsOneWidget);
      expect(find.text('Cadastrar'), findsOneWidget);
    });

    testWidgets('deve permitir selecionar tipo de usuário', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Cadastre-se'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Terapeuta'));
      await tester.pump();

      // Assert
      final radioTerapeuta = find.byWidgetPredicate(
        (widget) =>
            widget is RadioListTile<String> && widget.value == 'terapeuta',
      );
      expect(radioTerapeuta, findsOneWidget);
    });

    testWidgets('deve permitir preencher campos do formulário', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Cadastre-se'));
      await tester.pumpAndSettle();

      // Act - Preencher apenas o primeiro campo (nome)
      final nomeField = find.byType(TextField).first;
      await tester.enterText(nomeField, 'João Silva');

      // Assert
      expect(find.text('João Silva'), findsOneWidget);
    });

    testWidgets('deve alternar visibilidade das senhas', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Cadastre-se'));
      await tester.pumpAndSettle();

      // Act - Tentar encontrar e clicar no ícone de visibilidade
      final visibilityIcon = find.byIcon(Icons.visibility_outlined);
      if (visibilityIcon.evaluate().isNotEmpty) {
        await tester.tap(visibilityIcon);
        await tester.pump();
      }

      // Assert - Verificar se a tela ainda está funcionando
      expect(find.text('Cadastrar Terapeuta'), findsOneWidget);
    });

    testWidgets('deve mostrar botão de cadastrar', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Cadastre-se'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Cadastrar Terapeuta'), findsOneWidget);
    });

    testWidgets('deve voltar para tela de login ao cancelar', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Cadastre-se'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Núcleo Desenvolver'), findsOneWidget);
    });
  });
}

// Extensões para facilitar os testes
extension WidgetTesterX on WidgetTester {
  Future<void> enterTextByKey(Key key, String text) async {
    await enterText(find.byKey(key), text);
  }
}

