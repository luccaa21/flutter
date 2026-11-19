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
    return Usuario.init(
      json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      json['nome'],
      json['email'],
      json['senha'],
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario.fromMap(json);

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'email': email,
    'senha': senha,
  };

  Map<String, dynamic> toJson() => toMap();
}
