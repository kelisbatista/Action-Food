import 'package:flutter/material.dart';
import 'package:action_food/pedidoService.dart';
import 'package:action_food/view/statusPedido.dart';

class Carrinho extends StatefulWidget {
  final List<Map<String, dynamic>> itensCarrinho;
  final String idEstab;
  final String nomeEstab;

<<<<<<< HEAD
  Carrinho(this.nomeEstab,this.idEstab,{required this.itensCarrinho, super.key}) {
    for (var item in itensCarrinho) {
      item['estabId'] = idEstab;
    }
  }
=======
  const Carrinho(this.idEstab, {required this.itensCarrinho, super.key});
>>>>>>> dc04efcea4d70608698f37ae6fe683755f940a32

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
<<<<<<< HEAD
      // Cria pedido no Firestore
      final orderId =
          await pedidoService.criarPedido(widget.nomeEstab,widget.idEstab,widget.itensCarrinho, total);

      // Atualiza status do pedido para "pendente"
=======
      final orderId = await pedidoService.criarPedido(
        widget.idEstab,
        widget.itensCarrinho,
        total,
      );
>>>>>>> dc04efcea4d70608698f37ae6fe683755f940a32
      await pedidoService.atualizarStatus(orderId, 'pendente');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StatusPedido(idPedido: orderId)),
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
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 2,
        title: const Text(
          'Carrinho',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.itensCarrinho.isEmpty
          ? const Center(
              child: Text(
                'Seu carrinho está vazio 🛒',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.itensCarrinho.length,
                    itemBuilder: (context, i) {
                      final item = widget.itensCarrinho[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          color: Colors.orange[200],
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange[200],
                              child: const Icon(Icons.fastfood,
                                  color: Color.fromARGB(255, 73, 73, 73)),
                            ),
                            title: Text(
                              item['nome'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              'Qtd: ${item['qty']}   |   R\$ ${(item['preco'] * item['qty']).toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removerItem(i),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Rodapé com total e botão
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total: R\$ ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: finalizarPedido,
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF9E14B), Color(0xFFFFA500)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orangeAccent.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Finalizar Pedido',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
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
