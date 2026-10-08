class Destino {
  final String id;
  final String viagemId;
  final String nome;
  final String cidade;
  final String pais;
  final String categoria;
  final String? descricao;
  final double? latitude;
  final double? longitude;
  final double? avaliacao;

  Destino({
    required this.id,
    required this.viagemId,
    required this.nome,
    required this.cidade,
    required this.pais,
    required this.categoria,
    this.descricao,
    this.latitude,
    this.longitude,
    this.avaliacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viagemId': viagemId,
      'nome': nome,
      'cidade': cidade,
      'pais': pais,
      'categoria': categoria,
      'descricao': descricao,
      'latitude': latitude,
      'longitude': longitude,
      'avaliacao': avaliacao,
    };
  }

  factory Destino.fromMap(Map<String, dynamic> map) {
    return Destino(
      id: map['id'] as String,
      viagemId: map['viagemId'] as String,
      nome: map['nome'] as String,
      cidade: map['cidade'] as String,
      pais: map['pais'] as String,
      categoria: map['categoria'] as String,
      descricao: map['descricao'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      avaliacao: (map['avaliacao'] as num?)?.toDouble(),
    );
  }
}