import 'package:flutter/material.dart';
import 'package:mobile/db/usuario_db.dart';
import 'package:mobile/model/usuario.dart';
import 'package:mobile/util/dialogos.dart';

class UsuarioCrudSQLitePage extends StatefulWidget {
  const UsuarioCrudSQLitePage({super.key});

  @override
  State<UsuarioCrudSQLitePage> createState() => _UsuarioCrudSQLitePageState();
}

class _UsuarioCrudSQLitePageState extends State<UsuarioCrudSQLitePage> {
  List<Usuario> lista = []; // Atributo para armazenar a lista de usuários
  Usuario? selecionado; // Atributo para armazenar o usuário selecionado
  final _formKey = GlobalKey<FormState>();
  final FocusNode _editarFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarLista();
  }

  void _carregarLista() async {
    final dados = await UsuarioDb().getAll();
    setState(() {
      lista = dados;
    });
  }

  void _inserirOuEditar({Usuario? selecionado}) async {
    setState(() {
      this.selecionado = selecionado;
    });
    await showDialog(
      context: context,
      builder: (context) => dialogEditarWidget(),
    );
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro nos dados. Verifique.')),
      );
      return;
    }

    if (selecionado!.id == null) {
      await UsuarioDb().insert(selecionado!);
    } else {
      await UsuarioDb().update(selecionado!);
    }
    _carregarLista();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Dados salvos com sucesso!')));
    Navigator.pop(context);
  }

  void _excluir() async {
    Dialogos.showConfirmDialog(
      context,
      'Confirma Exclusão?',
      _excluirConfirmado,
    );
  }

  void _excluirConfirmado() async {
    await UsuarioDb().delete(selecionado!.id!);
    _carregarLista();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Excluído com sucesso!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(10.0),
          scrollDirection: Axis.vertical,
          children: lista
              .map(
                (obj) => ListTile(
                  leading: Icon(Icons.person),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 150, child: Text('${obj.nome}')),
                      Text('Email ${obj.email}'),
                    ],
                  ),
                  onTap: () => _inserirOuEditar(selecionado: obj),
                ),
              )
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _inserirOuEditar(selecionado: Usuario()),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget dialogEditarWidget() {
    return AlertDialog(
      title: Text(selecionado!.id == null ? 'Novo Usuário' : 'Editar Usuário'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Digite o nome do usuário',
                  border: OutlineInputBorder(),
                ),
                focusNode: _editarFocusNode,
                initialValue: selecionado!.nome,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome do usuário deve ser preenchido.';
                  }
                  if (value.length < 2) {
                    return 'O nome do usuário deve ter pelo menos 2 caracteres.';
                  }
                  selecionado!.nome = value;
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Digite o email',
                  border: OutlineInputBorder(),
                ),
                initialValue: selecionado!.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O email deve ser preenchido.';
                  }
                  if (value.length < 10) {
                    return 'O email deve ter pelo menos 10 caracteres.';
                  }
                  selecionado!.email = value;
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Digite a senha',
                  border: OutlineInputBorder(),
                ),
                initialValue: selecionado!.senha,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A senha deve ser preenchida.';
                  }
                  if (value.length < 6) {
                    return 'O senha deve ter pelo menos 6 caracteres.';
                  }
                  selecionado!.senha = value;
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          onPressed: () async {
            _salvar();
          },
          label: const Text('Salvar'),
        ),
        TextButton.icon(
          icon: const Icon(Icons.undo),
          onPressed: () => Navigator.pop(context),
          label: const Text('Cancelar'),
        ),
        TextButton.icon(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluir(),
          label: const Text(
            'Excluir',
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
