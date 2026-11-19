class Usuario {
  int? id;
  String? nome;
  String? email;
  String? senha;

  Usuario() {
    id = null;
    nome = "";
    email = "";
    senha = "";
  }

  Usuario.init(this.id, this.nome, this.email, this.senha);

  factory Usuario.fromMap(Map<String, dynamic> json) {
    return Usuario.init(json['id'], json['nome'], json['email'], json['senha']);
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'email': email,
    'senha': senha,
  };
}
