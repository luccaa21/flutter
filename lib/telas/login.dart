import 'package:flutter/material.dart';
import 'package:mobile/api/usuario_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final Login login = Login();
  final UsuarioApi _api = UsuarioApi();
  bool _carregando = false;

  void _autenticar() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro nos dados de usuário ou senha')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      final usuario = await _api.login(login.email, login.senha);
      if (usuario != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bem-vindo(a), ${usuario.nome}!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popAndPushNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro de login: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.lock_person_rounded,
                  size: 80,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Autenticação API',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  initialValue: login.email,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deve informar o e-mail!';
                    }
                    if (!value.contains('@')) {
                      return 'Informe um e-mail válido!';
                    }
                    login.email = value.trim();
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: login.senha,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deve informar a senha!';
                    }
                    if (value.length < 4) {
                      return 'A senha deve ter no mínimo 4 caracteres!';
                    }
                    login.senha = value;
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Entrar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _autenticar();
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Login {
  String email = 'jaqson@upf.br';
  String senha = 'senha123';
}
