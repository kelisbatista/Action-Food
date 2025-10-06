import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PedidoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Cria um novo pedido no Firestore
  /// [itens] → lista de itens do carrinho
  /// [total] → valor total do pedido
  Future<String> criarPedido(
      List<Map<String, dynamic>> itens, double total) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docPedido = _db.collection('orders').doc();
    final orderId = docPedido.id;

    await docPedido.set({
      'userId': uid,
      'items': itens,
      'total': total,
      'status_pedido': 'criando', // status inicial
      'createdAt': FieldValue.serverTimestamp(),
    });

    return orderId;
  }

  /// Atualiza o status de um pedido
  /// [orderId] → ID do pedido
  /// [novoStatus] → 'criando', 'pendente', 'pago', 'preparando', 'pronto para retirar', 'cancelado'
  Future<void> atualizarStatus(String orderId, String novoStatus) async {
    final docRef = _db.collection('orders').doc(orderId);

    final Map<String, dynamic> dadosAtualizacao = {
      'status_pedido': novoStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Se status for pendente (PIX gerado), adiciona campo mp_createdAt
    if (novoStatus == 'pendente') {
      dadosAtualizacao['mp_createdAt'] = FieldValue.serverTimestamp();
    }

    try {
      await docRef.update(dadosAtualizacao);
      print('Pedido $orderId atualizado para status: $novoStatus');
    } catch (e) {
      print('Erro ao atualizar status do pedido $orderId: $e');
      throw Exception('Não foi possível atualizar o status do pedido.');
    }
  }

  /// Salva os dados do pagamento PIX no pedido
  Future<void> adicionarPagamento(
      String orderId, Map<String, dynamic> pagamento) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'mp_payment': pagamento,
      });
      print('Pagamento PIX adicionado ao pedido $orderId');
    } catch (e) {
      print('Erro ao adicionar pagamento PIX: $e');
      throw Exception('Não foi possível adicionar o pagamento PIX.');
    }
  }

  /// Função auxiliar para marcar o pedido como pago
  Future<void> marcarComoPago(String orderId) async {
    await atualizarStatus(orderId, 'pago');
  }

  /// Função auxiliar para marcar pedido como preparando
  Future<void> marcarComoPreparando(String orderId) async {
    await atualizarStatus(orderId, 'preparando');
  }

  /// Função auxiliar para marcar pedido pronto para retirar
  Future<void> marcarComoProntoParaRetirar(String orderId) async {
    await atualizarStatus(orderId, 'pronto para retirar');
  }

  /// Função auxiliar para cancelar pedido
  Future<void> cancelarPedido(String orderId) async {
    await atualizarStatus(orderId, 'cancelado');
  }

  /// Salva os dados do pagamento PIX no pedido
  Future<void> salvarDadosPix(String orderId, Map<String, dynamic> mp) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'mp_payment': mp,
      });
      print('Dados do PIX salvos no pedido $orderId');
    } catch (e) {
      print('Erro ao salvar dados do PIX: $e');
      throw Exception('Não foi possível salvar os dados do PIX.');
    }
  }
}
