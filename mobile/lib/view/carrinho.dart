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
      .fold(0, (soma, item) => soma + item['preco'] * item['qty']);


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
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: const Text('Carrinho'),
        automaticallyImplyLeading: false,
        leading:
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[500],
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 25),
          ),
      ),
      body: Column(
        children: 
        [
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.itensCarrinho.length,
              itemBuilder: (context, i) {
                final item = widget.itensCarrinho[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.orange[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['nome'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Qtd: ${item['qty']}'),
                            Text(
                                'R\$ ${(item['preco'] * item['qty'])}'),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    elevation: 10,
                    backgroundColor: const Color.fromRGBO(249, 225, 75, 100),
                    foregroundColor: Colors.black,
                    fixedSize: const Size(250, 50),
                    textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  onPressed: finalizarPedido,
                  child: const Text('Finalizar Pedido'),
                ),
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
