import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/model/usuario.dart';

class UsuarioApi {
  // Instância do FlutterSecureStorage para armazenamento seguro de token
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'jwt_token';

  // Porta em que a API Mock está rodando
  static const int apiPort = 3001;

  // Configuração da URL Base para funcionar em Web, Desktop e Emulador Android
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$apiPort';
    }
    try {
      if (Platform.isAndroid) {
        // 10.0.2.2 é o alias para localhost do computador no emulador Android
        return 'http://10.0.2.2:$apiPort';
      }
    } catch (_) {
      // Fallback para ambientes que não suportam dart:io
    }
    return 'http://localhost:$apiPort';
  }

  // --- MÉTODOS DE GERENCIAMENTO DE TOKEN ---

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Monta os headers padrão incluindo o token JWT caso exista
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // --- AUTENTICAÇÃO ---

  Future<Usuario?> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/users/getUserByEmailAndSenha');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
      if (data['user'] != null) {
        return Usuario.fromJson(data['user']);
      }
      return null;
    } else {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'Falha na autenticação';
      throw Exception(message);
    }
  }

  // --- CRUD DA API ---

  // GET: Retornar todos os usuários com envio de token
  Future<List<Usuario>> getAll() async {
    final url = Uri.parse('$baseUrl/users');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar usuários: ${response.statusCode}');
    }
  }

  // GET: Retornar o maior id presente na lista da API
  Future<int> getMaiorId() async {
    final url = Uri.parse('$baseUrl/users/getMaiorId');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final idString = response.body.trim();
      return int.tryParse(idString) ?? 0;
    }
    return 0;
  }

  // POST: Incluir um novo usuário
  Future<Usuario> insert(Usuario usuario) async {
    // A API mock exige que o id seja enviado no body
    if (usuario.id == null || usuario.id == 0) {
      final maiorId = await getMaiorId();
      usuario.id = maiorId + 1;
    }

    final url = Uri.parse('$baseUrl/users');
    final headers = await _getHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao inserir usuário: ${response.body}');
    }
  }

  // PUT: Alterar um usuário existente pelo id
  Future<Usuario> update(Usuario usuario) async {
    final url = Uri.parse('$baseUrl/users');
    final headers = await _getHeaders();
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar usuário: ${response.body}');
    }
  }

  // DELETE: Excluir um usuário pelo id
  Future<void> delete(int id) async {
    final url = Uri.parse('$baseUrl/users/$id');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir usuário: ${response.body}');
    }
  }
}
