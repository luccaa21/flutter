import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/telas/contador.dart';
import 'package:mobile/telas/home.dart';
import 'package:mobile/telas/login.dart';
import 'package:mobile/telas/sobre.dart';
import 'package:mobile/telas/usuario_crud.dart';
import 'package:mobile/telas/usuario_crud_sqlite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Aula',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/contador': (context) =>
            const ContadorPage(title: 'Contador de Cliques'),
        '/sobre': (context) => const SobrePage(),
        '/usuario_crud': (context) => UsuarioCrudPage(),
        '/usuario_crud_sqlite': (context) => UsuarioCrudSQLitePage(),
      },
    );
  }
}
