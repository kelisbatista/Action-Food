import 'package:flutter/material.dart';
import 'package:action_food/pedidoService.dart';
import 'package:action_food/view/statusPedido.dart';

class Carrinho extends StatefulWidget {
  final List<Map<String, dynamic>> itensCarrinho;
  const Carrinho({required this.itensCarrinho, super.key});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  final PedidoService pedidoService = PedidoService();

  double get total => widget.itensCarrinho
      .fold(0, (soma, item) => soma + item['price'] * item['qty']);

  void removerItem(int indice) {
    setState(() {
      widget.itensCarrinho.removeAt(indice);
    });
  }

  Future<void> finalizarPedido() async {
    try {
      // Cria pedido no Firestore
      final orderId =
          await pedidoService.criarPedido(widget.itensCarrinho, total);

      // Atualiza status do pedido para "pendente"
      await pedidoService.atualizarStatus(orderId, 'pendente');

      if (!mounted) return;

      // Navega direto para a tela de status do pedido
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StatusPedido(idPedido: orderId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao finalizar pedido: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(
        title: const Text('Carrinho'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/principal');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            child: const Text('Voltar'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.itensCarrinho.length,
              itemBuilder: (context, i) {
                final item = widget.itensCarrinho[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.orange[200],
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      item['imageUrl'] != null
                          ? Image.network(item['imageUrl'],
                              width: 60, height: 60)
                          : Image.asset('assets/logoaction.png',
                              width: 60, height: 60),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Qtd: ${item['qty']}'),
                            Text(
                                'R\$ ${(item['price'] * item['qty']).toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removerItem(i),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text('Total: R\$ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: finalizarPedido,
                  child: const Text('Finalizar Pedido'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
