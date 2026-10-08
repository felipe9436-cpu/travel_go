class Gasto {
  final String id;
  final String viagemId;
  final String descricao;
  final double valor;
  final String categoria;
  final DateTime data;
  final String? observacao;

  Gasto({
    required this.id,
    required this.viagemId,
    required this.descricao,
    required this.valor,
    required this.categoria,
    required this.data,
    this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viagemId': viagemId,
      'descricao': descricao,
      'valor': valor,
      'categoria': categoria,
      'data': data.toIso8601String(),
      'observacao': observacao,
    };
  }

  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id'] as String,
      viagemId: map['viagemId'] as String,
      descricao: map['descricao'] as String,
      valor: (map['valor'] as num).toDouble(),
      categoria: map['categoria'] as String,
      data: DateTime.parse(map['data'] as String),
      observacao: map['observacao'] as String?,
    );
  }
}