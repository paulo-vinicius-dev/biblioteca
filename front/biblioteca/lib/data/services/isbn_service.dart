import 'dart:convert';
import 'package:http/http.dart' as http;

class IsbnService {
  static Future<Map<String, dynamic>?> buscarLivroPorISBN(String isbn) async {
    if (isbn.isEmpty) return null;

    String url = 'https://brasilapi.com.br/api/isbn/v1/$isbn';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Erro ao buscar livro: $e');
    }
  }
}
