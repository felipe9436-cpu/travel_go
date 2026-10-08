import '../models/avaliacao.dart';
import '../models/checklist_item.dart';
import '../models/destino.dart';
import '../models/gasto.dart';
import '../models/hospedagem.dart';
import '../models/roteiro.dart';
import '../models/viagem.dart';

class StorageService {
  StorageService._();

  static final StorageService instance =
  StorageService._();

  final List<Viagem> _viagens = [];
  final List<Destino> _destinos = [];
  final List<Roteiro> _roteiros = [];
  final List<Hospedagem> _hospedagens = [];
  final List<Gasto> _gastos = [];
  final List<ChecklistItem> _checklist = [];
  final List<Avaliacao> _avaliacoes = [];

  // ============================================================
  // VIAGENS
  // ============================================================

  List<Viagem> get viagens {
    return List.unmodifiable(_viagens);
  }

  void adicionarViagem(Viagem viagem) {
    _viagens.add(viagem);
  }

  void atualizarViagem(Viagem viagem) {
    final index = _viagens.indexWhere(
          (item) => item.id == viagem.id,
    );

    if (index == -1) return;

    _viagens[index] = viagem;
  }

  void removerViagem(String id) {
    _viagens.removeWhere(
          (viagem) => viagem.id == id,
    );

    _destinos.removeWhere(
          (destino) => destino.viagemId == id,
    );

    _roteiros.removeWhere(
          (roteiro) => roteiro.viagemId == id,
    );

    _hospedagens.removeWhere(
          (hospedagem) => hospedagem.viagemId == id,
    );

    _gastos.removeWhere(
          (gasto) => gasto.viagemId == id,
    );

    _checklist.removeWhere(
          (item) => item.viagemId == id,
    );

    _avaliacoes.removeWhere(
          (avaliacao) => avaliacao.viagemId == id,
    );
  }

  Viagem? buscarViagem(String id) {
    for (final viagem in _viagens) {
      if (viagem.id == id) {
        return viagem;
      }
    }

    return null;
  }

  // ============================================================
  // DESTINOS
  // ============================================================

  List<Destino> destinosDaViagem(
      String viagemId,
      ) {
    return List.unmodifiable(
      _destinos.where(
            (destino) => destino.viagemId == viagemId,
      ),
    );
  }

  void adicionarDestino(Destino destino) {
    _destinos.add(destino);
  }

  void atualizarDestino(Destino destino) {
    final index = _destinos.indexWhere(
          (item) => item.id == destino.id,
    );

    if (index == -1) return;

    _destinos[index] = destino;
  }

  void removerDestino(String id) {
    _destinos.removeWhere(
          (destino) => destino.id == id,
    );
  }

  Destino? buscarDestino(String id) {
    for (final destino in _destinos) {
      if (destino.id == id) {
        return destino;
      }
    }

    return null;
  }

  // ============================================================
  // ROTEIRO
  // ============================================================

  List<Roteiro> roteiroDaViagem(
      String viagemId,
      ) {
    return List.unmodifiable(
      _roteiros.where(
            (roteiro) => roteiro.viagemId == viagemId,
      ),
    );
  }

  void adicionarRoteiro(Roteiro roteiro) {
    _roteiros.add(roteiro);
  }

  void atualizarRoteiro(Roteiro roteiro) {
    final index = _roteiros.indexWhere(
          (item) => item.id == roteiro.id,
    );

    if (index == -1) return;

    _roteiros[index] = roteiro;
  }

  void removerRoteiro(String id) {
    _roteiros.removeWhere(
          (roteiro) => roteiro.id == id,
    );
  }

  Roteiro? buscarRoteiro(String id) {
    for (final roteiro in _roteiros) {
      if (roteiro.id == id) {
        return roteiro;
      }
    }

    return null;
  }

  // ============================================================
  // HOSPEDAGEM
  // ============================================================

  List<Hospedagem> hospedagensDaViagem(
      String viagemId,
      ) {
    return List.unmodifiable(
      _hospedagens.where(
            (hospedagem) =>
        hospedagem.viagemId == viagemId,
      ),
    );
  }

  void adicionarHospedagem(
      Hospedagem hospedagem,
      ) {
    _hospedagens.add(hospedagem);
  }

  void atualizarHospedagem(
      Hospedagem hospedagem,
      ) {
    final index = _hospedagens.indexWhere(
          (item) => item.id == hospedagem.id,
    );

    if (index == -1) return;

    _hospedagens[index] = hospedagem;
  }

  void removerHospedagem(String id) {
    _hospedagens.removeWhere(
          (hospedagem) => hospedagem.id == id,
    );
  }

  Hospedagem? buscarHospedagem(String id) {
    for (final hospedagem in _hospedagens) {
      if (hospedagem.id == id) {
        return hospedagem;
      }
    }

    return null;
  }

  // ============================================================
  // GASTOS
  // ============================================================

  List<Gasto> gastosDaViagem(
      String viagemId,
      ) {
    return List.unmodifiable(
      _gastos.where(
            (gasto) => gasto.viagemId == viagemId,
      ),
    );
  }

  void adicionarGasto(Gasto gasto) {
    _gastos.add(gasto);
  }

  void atualizarGasto(Gasto gasto) {
    final index = _gastos.indexWhere(
          (item) => item.id == gasto.id,
    );

    if (index == -1) return;

    _gastos[index] = gasto;
  }

  void removerGasto(String id) {
    _gastos.removeWhere(
          (gasto) => gasto.id == id,
    );
  }

  Gasto? buscarGasto(String id) {
    for (final gasto in _gastos) {
      if (gasto.id == id) {
        return gasto;
      }
    }

    return null;
  }

  double totalGastosDaViagem(
      String viagemId,
      ) {
    return _gastos
        .where(
          (gasto) => gasto.viagemId == viagemId,
    )
        .fold(
      0.0,
          (total, gasto) => total + gasto.valor,
    );
  }

  // ============================================================
  // CHECKLIST
  // ============================================================

  List<ChecklistItem> checklistDaViagem(
      String viagemId,
      ) {
    return List.unmodifiable(
      _checklist.where(
            (item) => item.viagemId == viagemId,
      ),
    );
  }

  void adicionarChecklistItem(
      ChecklistItem item,
      ) {
    _checklist.add(item);
  }

  void atualizarChecklistItem(
      ChecklistItem item,
      ) {
    final index = _checklist.indexWhere(
          (element) => element.id == item.id,
    );

    if (index == -1) return;

    _checklist[index] = item;
  }

  void removerChecklistItem(String id) {
    _checklist.removeWhere(
          (item) => item.id == id,
    );
  }

  int itensChecklistConcluidos(
      String viagemId,
      ) {
    return _checklist
        .where(
          (item) =>
      item.viagemId == viagemId &&
          item.concluido,
    )
        .length;
  }

  // ============================================================
  // AVALIAÇÕES
  // ============================================================

  List<Avaliacao> avaliacoesDaViagem(
      String viagemId,
      ) {
    return List.unmodifiable(
      _avaliacoes.where(
            (avaliacao) =>
        avaliacao.viagemId == viagemId,
      ),
    );
  }

  void adicionarAvaliacao(
      Avaliacao avaliacao,
      ) {
    _avaliacoes.add(avaliacao);
  }

  void atualizarAvaliacao(
      Avaliacao avaliacao,
      ) {
    final index = _avaliacoes.indexWhere(
          (item) => item.id == avaliacao.id,
    );

    if (index == -1) return;

    _avaliacoes[index] = avaliacao;
  }

  void removerAvaliacao(String id) {
    _avaliacoes.removeWhere(
          (avaliacao) => avaliacao.id == id,
    );
  }

  double mediaAvaliacoesDaViagem(
      String viagemId,
      ) {
    final avaliacoes = _avaliacoes
        .where(
          (avaliacao) =>
      avaliacao.viagemId == viagemId,
    )
        .toList();

    if (avaliacoes.isEmpty) {
      return 0;
    }

    final soma = avaliacoes.fold<double>(
      0,
          (total, avaliacao) =>
      total + avaliacao.nota,
    );

    return soma / avaliacoes.length;
  }

  // ============================================================
  // LIMPEZA
  // ============================================================

  void limparTudo() {
    _viagens.clear();
    _destinos.clear();
    _roteiros.clear();
    _hospedagens.clear();
    _gastos.clear();
    _checklist.clear();
    _avaliacoes.clear();
  }
}