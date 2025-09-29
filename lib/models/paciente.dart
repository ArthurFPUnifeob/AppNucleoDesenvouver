class Paciente {
  final String id;
  final String nome;
  final DateTime dataNascimento;
  final String genero; // 'masculino' ou 'feminino'
  final String responsavel;
  final String telefone;
  final String? email;
  final String? observacoes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Paciente({
    required this.id,
    required this.nome,
    required this.dataNascimento,
    required this.genero,
    required this.responsavel,
    required this.telefone,
    this.email,
    this.observacoes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converte Paciente para Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data_nascimento': dataNascimento.millisecondsSinceEpoch,
      'genero': genero,
      'responsavel': responsavel,
      'telefone': telefone,
      'email': email,
      'observacoes': observacoes,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Cria Paciente a partir de Map do banco
  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      id: map['id'],
      nome: map['nome'],
      dataNascimento: DateTime.fromMillisecondsSinceEpoch(map['data_nascimento']),
      genero: map['genero'],
      responsavel: map['responsavel'],
      telefone: map['telefone'],
      email: map['email'],
      observacoes: map['observacoes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  // Calcula a idade do paciente
  int get idade {
    final now = DateTime.now();
    int age = now.year - dataNascimento.year;
    if (now.month < dataNascimento.month || 
        (now.month == dataNascimento.month && now.day < dataNascimento.day)) {
      age--;
    }
    return age;
  }

  // Cria uma cópia do paciente com campos alterados
  Paciente copyWith({
    String? id,
    String? nome,
    DateTime? dataNascimento,
    String? genero,
    String? responsavel,
    String? telefone,
    String? email,
    String? observacoes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Paciente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      genero: genero ?? this.genero,
      responsavel: responsavel ?? this.responsavel,
      telefone: telefone ?? this.telefone,
      email: email, // Permitir null explícito
      observacoes: observacoes, // Permitir null explícito
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Paciente{id: $id, nome: $nome, idade: $idade}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Paciente && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

