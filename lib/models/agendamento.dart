class Agendamento {
  final String id;
  final String pacienteId;
  final String pacienteNome;
  final String terapeutaId;
  final String terapeutaNome;
  final DateTime dataHora;
  final String status; // 'confirmado', 'pendente', 'cancelado', 'realizado'
  final String tipoConsulta; // 'consulta', 'avaliacao', 'retorno', 'emergencia'
  final String? observacoes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Agendamento({
    required this.id,
    required this.pacienteId,
    required this.pacienteNome,
    required this.terapeutaId,
    required this.terapeutaNome,
    required this.dataHora,
    required this.status,
    required this.tipoConsulta,
    this.observacoes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converte Agendamento para Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paciente_id': pacienteId,
      'paciente_nome': pacienteNome,
      'terapeuta_id': terapeutaId,
      'terapeuta_nome': terapeutaNome,
      'data_hora': dataHora.millisecondsSinceEpoch,
      'status': status,
      'tipo_consulta': tipoConsulta,
      'observacoes': observacoes,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Cria Agendamento a partir de Map do banco
  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'],
      pacienteId: map['paciente_id'],
      pacienteNome: map['paciente_nome'],
      terapeutaId: map['terapeuta_id'],
      terapeutaNome: map['terapeuta_nome'],
      dataHora: DateTime.fromMillisecondsSinceEpoch(map['data_hora']),
      status: map['status'],
      tipoConsulta: map['tipo_consulta'],
      observacoes: map['observacoes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  // Verifica se o agendamento é hoje
  bool get isHoje {
    final now = DateTime.now();
    return dataHora.year == now.year &&
           dataHora.month == now.month &&
           dataHora.day == now.day;
  }

  // Verifica se o agendamento é no futuro
  bool get isFuturo {
    return dataHora.isAfter(DateTime.now());
  }

  // Verifica se o agendamento é no passado
  bool get isPassado {
    return dataHora.isBefore(DateTime.now());
  }

  // Cria uma cópia do agendamento com campos alterados
  Agendamento copyWith({
    String? id,
    String? pacienteId,
    String? pacienteNome,
    String? terapeutaId,
    String? terapeutaNome,
    DateTime? dataHora,
    String? status,
    String? tipoConsulta,
    String? observacoes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Agendamento(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      pacienteNome: pacienteNome ?? this.pacienteNome,
      terapeutaId: terapeutaId ?? this.terapeutaId,
      terapeutaNome: terapeutaNome ?? this.terapeutaNome,
      dataHora: dataHora ?? this.dataHora,
      status: status ?? this.status,
      tipoConsulta: tipoConsulta ?? this.tipoConsulta,
      observacoes: observacoes ?? this.observacoes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Agendamento{id: $id, paciente: $pacienteNome, data: $dataHora, status: $status}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Agendamento && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

