import 'package:flutter/material.dart';
import 'package:mobile/api/usuario_api.dart';
import 'package:mobile/model/usuario.dart';
import 'package:mobile/util/dialogos.dart';

class UsuarioCrudApiPage extends StatefulWidget {
  const UsuarioCrudApiPage({super.key});

  @override
  State<UsuarioCrudApiPage> createState() => _UsuarioCrudApiPageState();
}

class _UsuarioCrudApiPageState extends State<UsuarioCrudApiPage> {
  final UsuarioApi _api = UsuarioApi();
  List<Usuario> lista = [];
  Usuario? selecionado;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _editarFocusNode = FocusNode();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarLista();
  }

  void _carregarLista() async {
    setState(() => _carregando = true);
    try {
      final dados = await _api.getAll();
      setState(() {
        lista = dados;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados da API: $e'),
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

    try {
      if (selecionado!.id == null) {
        await _api.insert(selecionado!);
      } else {
        await _api.update(selecionado!);
      }
      _carregarLista();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos na API com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar na API: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _excluir() async {
    Dialogos.showConfirmDialog(
      context,
      'Confirma Exclusão na API?',
      _excluirConfirmado,
    );
  }

  void _excluirConfirmado() async {
    try {
      await _api.delete(selecionado!.id!);
      _carregarLista();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Excluído da API com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir na API: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD API (Usuários)'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarLista,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : lista.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum usuário retornado da API.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Center(
                  child: ListView(
                    padding: const EdgeInsets.all(10.0),
                    scrollDirection: Axis.vertical,
                    children: lista
                        .map(
                          (obj) => ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                obj.nome != null && obj.nome!.isNotEmpty
                                    ? obj.nome![0].toUpperCase()
                                    : '?',
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${obj.nome} (ID: ${obj.id})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Email: ${obj.email}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  selecionado = obj;
                                });
                                _excluir();
                              },
                            ),
                            onTap: () => _inserirOuEditar(selecionado: obj),
                          ),
                        )
                        .toList(),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () => _inserirOuEditar(selecionado: Usuario()),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget dialogEditarWidget() {
    return AlertDialog(
      title: Text(
        selecionado!.id == null ? 'Novo Usuário API' : 'Editar Usuário API',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
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
                    return 'O nome deve ter pelo menos 2 caracteres.';
                  }
                  selecionado!.nome = value;
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Digite o email',
                  border: OutlineInputBorder(),
                ),
                initialValue: selecionado!.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O email deve ser preenchido.';
                  }
                  if (!value.contains('@')) {
                    return 'Digite um email válido.';
                  }
                  selecionado!.email = value;
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Digite a senha',
                  border: OutlineInputBorder(),
                ),
                initialValue: selecionado!.senha,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A senha deve ser preenchida.';
                  }
                  if (value.length < 4) {
                    return 'A senha deve ter pelo menos 4 caracteres.';
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
          onPressed: _salvar,
          label: const Text('Salvar'),
        ),
        TextButton.icon(
          icon: const Icon(Icons.undo),
          onPressed: () => Navigator.pop(context),
          label: const Text('Cancelar'),
        ),
        if (selecionado!.id != null)
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
