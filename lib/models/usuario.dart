class Usuario {
  final String id;
  final String nome;
  final String email;
  final String tipo; // 'paciente' ou 'terapeuta'
  final String? telefone;
  final String? cpf;
  final DateTime? dataNascimento;
  final String? senha;
  final DateTime createdAt;
  final DateTime updatedAt;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
    this.telefone,
    this.cpf,
    this.dataNascimento,
    this.senha,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converte Usuario para Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipo': tipo,
      'telefone': telefone,
      'cpf': cpf,
      'data_nascimento': dataNascimento?.millisecondsSinceEpoch,
      'senha': senha,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Cria Usuario a partir de Map do banco
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      tipo: map['tipo'],
      telefone: map['telefone'],
      cpf: map['cpf'],
      dataNascimento: map['data_nascimento'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['data_nascimento'])
          : null,
      senha: map['senha'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  // Cria uma cópia do usuário com campos alterados
  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    String? tipo,
    String? telefone,
    String? cpf,
    DateTime? dataNascimento,
    String? senha,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      tipo: tipo ?? this.tipo,
      telefone: telefone ?? this.telefone,
      cpf: cpf ?? this.cpf,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      senha: senha ?? this.senha,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nome: $nome, email: $email, tipo: $tipo}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Usuario && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

