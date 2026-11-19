import 'dart:async';

import 'package:mobile/db/database_helper.dart';
import 'package:mobile/model/usuario.dart';

class UsuarioDb {
  // Método para obter a lista de todos os usuários
  Future<List<Usuario>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final results = await db.getAll(
      '''SELECT * FROM usuario m ORDER BY m.nome''',
    );
    return results.map<Usuario>((row) => Usuario.fromMap(row)).toList();
  }

  // Método para inserir um usuário
  Future<int> insert(Usuario usuario) async {
    final db = await DatabaseHelper.instance.database;
    await db.execute(
      'INSERT INTO usuario (nome, email, senha) VALUES (?, ?, ?)',
      [usuario.nome, usuario.email, usuario.senha],
    );
    final result = await db.get('SELECT changes() as affected');
    return result['affected'];
  }

  // Método para alterar um usuário
  Future<int> update(Usuario usuario) async {
    final db = await DatabaseHelper.instance.database;
    await db.execute(
      '''UPDATE usuario SET nome=?, email=?, senha=? WHERE id=?''',
      [usuario.nome, usuario.email, usuario.senha, usuario.id],
    );
    final result = await db.get('SELECT changes() as affected');
    return result['affected'];
  }

  // Método para excluir um usuário
  Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.execute('DELETE FROM usuario WHERE id=?', [id]);
    final result = await db.get('SELECT changes() as affected');
    return result['affected'];
  }

  // Método para recuperar um usuário pelo email e senha
  Future<Usuario?> getUsuario(String email, String senha) async {
    final db = await DatabaseHelper.instance.database;
    final results = await db.getAll(
      '''SELECT * FROM usuario WHERE email = ? AND senha = ?''',
      [email, senha],
    );
    if (results.isNotEmpty) return Usuario.fromMap(results.first);
    return null;
  }
}
