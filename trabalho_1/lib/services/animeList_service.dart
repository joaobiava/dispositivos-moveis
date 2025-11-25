import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AnimelistService {
  Future<Map<String, dynamic>> PesquisaAnimeById(int? id) async {
    try {
      final uri = Uri.parse("https://api.jikan.moe/v4/anime/$id");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Erro ${response.statusCode}: ${response.body}");
      }
    } on SocketException {
      throw Exception("Erro de conexão com a internet.");
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> PesquisaAnimeByName(String? name) async {
    try {
      final uri = Uri.parse("https://api.jikan.moe/v4/anime?q=$name");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }
}
