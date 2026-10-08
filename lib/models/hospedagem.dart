class Hospedagem {
  final String id;
  final String viagemId;
  final String nome;
  final String endereco;
  final DateTime checkIn;
  final DateTime checkOut;
  final double valorTotal;
  final double? avaliacao;
  final String? observacao;
  final String? urlReserva;

  Hospedagem({
    required this.id,
    required this.viagemId,
    required this.nome,
    required this.endereco,
    required this.checkIn,
    required this.checkOut,
    required this.valorTotal,
    this.avaliacao,
    this.observacao,
    this.urlReserva,
  });

  int get numeroNoites {
    return checkOut.difference(checkIn).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viagemId': viagemId,
      'nome': nome,
      'endereco': endereco,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'valorTotal': valorTotal,
      'avaliacao': avaliacao,
      'observacao': observacao,
      'urlReserva': urlReserva,
    };
  }

  factory Hospedagem.fromMap(Map<String, dynamic> map) {
    return Hospedagem(
      id: map['id'] as String,
      viagemId: map['viagemId'] as String,
      nome: map['nome'] as String,
      endereco: map['endereco'] as String,
      checkIn: DateTime.parse(map['checkIn'] as String),
      checkOut: DateTime.parse(map['checkOut'] as String),
      valorTotal: (map['valorTotal'] as num).toDouble(),
      avaliacao: (map['avaliacao'] as num?)?.toDouble(),
      observacao: map['observacao'] as String?,
      urlReserva: map['urlReserva'] as String?,
    );
  }
}