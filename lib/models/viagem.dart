class Viagem {
  final String id;
  final String nome;
  final String destino;
  final DateTime dataInicio;
  final DateTime dataFim;
  final int numeroViajantes;
  final double orcamento;
  final String? imagemUrl;

  Viagem({
    required this.id,
    required this.nome,
    required this.destino,
    required this.dataInicio,
    required this.dataFim,
    required this.numeroViajantes,
    required this.orcamento,
    this.imagemUrl,
  });

  int get duracaoEmDias {
    return dataFim.difference(dataInicio).inDays + 1;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'destino': destino,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      'numeroViajantes': numeroViajantes,
      'orcamento': orcamento,
      'imagemUrl': imagemUrl,
    };
  }

  factory Viagem.fromMap(Map<String, dynamic> map) {
    return Viagem(
      id: map['id'] as String,
      nome: map['nome'] as String,
      destino: map['destino'] as String,
      dataInicio: DateTime.parse(
        map['dataInicio'] as String,
      ),
      dataFim: DateTime.parse(
        map['dataFim'] as String,
      ),
      numeroViajantes:
      map['numeroViajantes'] as int,
      orcamento:
      (map['orcamento'] as num).toDouble(),
      imagemUrl: map['imagemUrl'] as String?,
    );
  }
}