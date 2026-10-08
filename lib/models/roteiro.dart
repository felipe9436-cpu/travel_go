class Roteiro {
  final String id;
  final String viagemId;
  final DateTime data;
  final String titulo;
  final String? descricao;
  final String? horario;
  final String categoria;
  final String? local;
  final bool concluido;

  Roteiro({
    required this.id,
    required this.viagemId,
    required this.data,
    required this.titulo,
    this.descricao,
    this.horario,
    required this.categoria,
    this.local,
    this.concluido = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viagemId': viagemId,
      'data': data.toIso8601String(),
      'titulo': titulo,
      'descricao': descricao,
      'horario': horario,
      'categoria': categoria,
      'local': local,
      'concluido': concluido,
    };
  }

  factory Roteiro.fromMap(Map<String, dynamic> map) {
    return Roteiro(
      id: map['id'] as String,
      viagemId: map['viagemId'] as String,
      data: DateTime.parse(map['data'] as String),
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String?,
      horario: map['horario'] as String?,
      categoria: map['categoria'] as String,
      local: map['local'] as String?,
      concluido: map['concluido'] as bool? ?? false,
    );
  }

  Roteiro copyWith({
    String? id,
    String? viagemId,
    DateTime? data,
    String? titulo,
    String? descricao,
    String? horario,
    String? categoria,
    String? local,
    bool? concluido,
  }) {
    return Roteiro(
      id: id ?? this.id,
      viagemId: viagemId ?? this.viagemId,
      data: data ?? this.data,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      horario: horario ?? this.horario,
      categoria: categoria ?? this.categoria,
      local: local ?? this.local,
      concluido: concluido ?? this.concluido,
    );
  }
}