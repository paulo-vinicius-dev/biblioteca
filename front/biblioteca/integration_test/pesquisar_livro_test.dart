import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:biblioteca/main.dart'; 
import 'package:biblioteca/data/providers/livro_provider.dart';
import 'package:biblioteca/data/providers/exemplares_provider.dart';
import 'package:biblioteca/data/models/livro_model.dart';
import 'package:biblioteca/data/models/exemplar_model.dart';
import '../test/mocks.mocks.dart'; 


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pesquisar Livro Integration Test', () {
    late MockLivroProvider livroProvider;
    late MockExemplarProvider exemplarProvider;

    setUp(() {
      // Inicializa os mocks
      livroProvider = MockLivroProvider();
      exemplarProvider = MockExemplarProvider();
    });

    testWidgets('Testar pesquisa de livro e exibição de resultados', (WidgetTester tester) async {
      // Mock dos dados de Livro
      when(livroProvider.livros).thenReturn([
        Livro(
          idDoLivro: 1,
          isbn: '1234567890',
          titulo: 'Livro 1',
          anoPublicacao: DateTime(2020),
          editora: 'Editora A',
          pais: {'id': 1, 'nome': 'Brasil', 'sigla': 'BR'},
          categorias: [],
          autores: [],
        ),
        Livro(
          idDoLivro: 2,
          isbn: '0987654321',
          titulo: 'Livro 2',
          anoPublicacao: DateTime(2019),
          editora: 'Editora B',
          pais: {'id': 2, 'nome': 'EUA', 'sigla': 'US'},
          categorias: [],
          autores: [],
        ),
      ]);

      // Mock dos dados de Exemplar
      when(exemplarProvider.exemplares).thenReturn([
        Exemplar(
          id: 1,
          cativo: false,
          statusCodigo: 1,
          estado: 1,
          ativo: true,
          idLivro: 1,
          isbn: '1234567890',
          titulo: 'Livro 1',
          anoPublicacao: DateTime(2020),
          editora: 'Editora A',
          idPais: 1,
          nomePais: 'Brasil',
          siglaPais: 'BR',
        ),
        Exemplar(
          id: 2,
          cativo: false,
          statusCodigo: 2,
          estado: 2,
          ativo: true,
          idLivro: 1,
          isbn: '1234567890',
          titulo: 'Livro 1',
          anoPublicacao: DateTime(2020),
          editora: 'Editora A',
          idPais: 1,
          nomePais: 'Brasil',
          siglaPais: 'BR',
        ),
      ]);

      // Inicializa o aplicativo com os providers mockados
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LivroProvider>.value(value: livroProvider),
            ChangeNotifierProvider<ExemplarProvider>.value(value: exemplarProvider),
          ],
          child: const Myapp(), // Certifique-se de que o nome está correto
        ),
      );

      // Navega até a tela de pesquisa de livro
      await tester.tap(find.text('Pesquisar Livro'));
      await tester.pumpAndSettle();

      // Digita no campo de pesquisa
      await tester.enterText(find.byType(TextField), 'Livro 1');
      await tester.pumpAndSettle();

      // Pressiona o botão de pesquisa
      await tester.tap(find.text('Pesquisar'));
      await tester.pumpAndSettle();

      // Verifica se os resultados foram exibidos corretamente
      expect(find.text('Livro 1'), findsOneWidget);
      expect(find.text('Livro 2'), findsNothing);

      // Seleciona um livro
      await tester.tap(find.text('Selecionar'));
      await tester.pumpAndSettle();

      // Verifica se os detalhes do exemplar foram exibidos
      expect(find.text('Detalhes Dos Exemplares'), findsOneWidget);
      expect(find.text('Tombamento'), findsOneWidget);
      expect(find.text('Situação'), findsOneWidget);
      expect(find.text('Estado Físico'), findsOneWidget);
    });

    testWidgets('Testar pesquisa sem resultados', (WidgetTester tester) async {
      // Mock dos dados de Livro
      when(livroProvider.livros).thenReturn([
        Livro(
          idDoLivro: 1,
          isbn: '1234567890',
          titulo: 'Livro 1',
          anoPublicacao: DateTime(2020),
          editora: 'Editora A',
          pais: {'id': 1, 'nome': 'Brasil', 'sigla': 'BR'},
          categorias: [],
          autores: [],
        ),
      ]);

      // Inicializa o aplicativo com os providers mockados
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LivroProvider>.value(value: livroProvider),
            ChangeNotifierProvider<ExemplarProvider>.value(value: exemplarProvider),
          ],
          child: const Myapp(), // Certifique-se de que o nome está correto
        ),
      );

      // Navega até a tela de pesquisa de livro
      await tester.tap(find.text('Pesquisar Livro'));
      await tester.pumpAndSettle();

      // Digita no campo de pesquisa
      await tester.enterText(find.byType(TextField), 'Livro Inexistente');
      await tester.pumpAndSettle();

      // Pressiona o botão de pesquisa
      await tester.tap(find.text('Pesquisar'));
      await tester.pumpAndSettle();

      // Verifica se a mensagem de "Nenhum livro encontrado" é exibida
      expect(find.text('Nenhum livro encontrado'), findsOneWidget);
    });

    testWidgets('Testar falha na carga dos dados', (WidgetTester tester) async {
      // Mock de falha na carga dos dados
      when(livroProvider.livros).thenReturn([]);
      when(exemplarProvider.exemplares).thenReturn([]);

      // Inicializa o aplicativo com os providers mockados
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LivroProvider>.value(value: livroProvider),
            ChangeNotifierProvider<ExemplarProvider>.value(value: exemplarProvider),
          ],
          child: const Myapp(), // Certifique-se de que o nome está correto
        ),
      );

      // Navega até a tela de pesquisa de livro
      await tester.tap(find.text('Pesquisar Livro'));
      await tester.pumpAndSettle();

      // Verifica se a mensagem de erro é exibida (caso o app tenha tratamento de erro)
      expect(find.text('Erro ao carregar dados'), findsOneWidget);
    });

    testWidgets('Testar performance da pesquisa', (WidgetTester tester) async {
      // Mock de uma grande quantidade de dados para testar performance
      when(livroProvider.livros).thenReturn(List.generate(1000, (index) => Livro(
        idDoLivro: index,
        isbn: 'ISBN$index',
        titulo: 'Livro $index',
        anoPublicacao: DateTime(2020),
        editora: 'Editora $index',
        pais: {'id': 1, 'nome': 'Brasil', 'sigla': 'BR'},
        categorias: [],
        autores: [],
      )));

      // Inicializa o aplicativo com os providers mockados
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LivroProvider>.value(value: livroProvider),
            ChangeNotifierProvider<ExemplarProvider>.value(value: exemplarProvider),
          ],
          child: const Myapp(), // Certifique-se de que o nome está correto
        ),
      );

      // Navega até a tela de pesquisa de livro
      await tester.tap(find.text('Pesquisar Livro'));
      await tester.pumpAndSettle();

      // Mede o tempo de pesquisa
      final stopwatch = Stopwatch()..start();
      await tester.enterText(find.byType(TextField), 'Livro 500');
      await tester.tap(find.text('Pesquisar'));
      await tester.pumpAndSettle();
      stopwatch.stop();

      // Verifica se a pesquisa foi eficiente (tempo menor que 1 segundo, por exemplo)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}