class Avaliacao {
  final String id;
  final String viagemId;
  final String nome;
  final String categoria;
  final double nota;
  final String? comentario;
  final DateTime data;

  Avaliacao({
    required this.id,
    required this.viagemId,
    required this.nome,
    required this.categoria,
    required this.nota,
    this.comentario,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viagemId': viagemId,
      'nome': nome,
      'categoria': categoria,
      'nota': nota,
      'comentario': comentario,
      'data': data.toIso8601String(),
    };
  }

  factory Avaliacao.fromMap(Map<String, dynamic> map) {
    return Avaliacao(
      id: map['id'] as String,
      viagemId: map['viagemId'] as String,
      nome: map['nome'] as String,
      categoria: map['categoria'] as String,
      nota: (map['nota'] as num).toDouble(),
      comentario: map['comentario'] as String?,
      data: DateTime.parse(map['data'] as String),
    );
  }
}