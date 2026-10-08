class ChecklistItem {
  final String id;
  final String viagemId;
  final String titulo;
  final String categoria;
  final bool concluido;
  final String? observacao;

  ChecklistItem({
    required this.id,
    required this.viagemId,
    required this.titulo,
    required this.categoria,
    this.concluido = false,
    this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viagemId': viagemId,
      'titulo': titulo,
      'categoria': categoria,
      'concluido': concluido,
      'observacao': observacao,
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'] as String,
      viagemId: map['viagemId'] as String,
      titulo: map['titulo'] as String,
      categoria: map['categoria'] as String,
      concluido: map['concluido'] as bool? ?? false,
      observacao: map['observacao'] as String?,
    );
  }

  ChecklistItem copyWith({
    String? id,
    String? viagemId,
    String? titulo,
    String? categoria,
    bool? concluido,
    String? observacao,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      viagemId: viagemId ?? this.viagemId,
      titulo: titulo ?? this.titulo,
      categoria: categoria ?? this.categoria,
      concluido: concluido ?? this.concluido,
      observacao: observacao ?? this.observacao,
    );
  }
}