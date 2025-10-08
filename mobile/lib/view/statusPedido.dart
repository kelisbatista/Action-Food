import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusPedido extends StatelessWidget {
  final String idPedido;

  const StatusPedido({required this.idPedido, super.key});

  // Cor do status
  Color corDoStatus(String status) {
    switch (status) {
      case 'criando':
        return Colors.grey;
      case 'pendente':
        return Colors.orange;
      case 'pago':
        return Colors.green;
      case 'preparando':
        return Colors.blue;
      case 'pronto para retirar':
        return Colors.purple;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  // Ícone do status
  IconData iconeDoStatus(String status) {
    switch (status) {
      case 'criando':
        return Icons.hourglass_empty;
      case 'pendente':
        return Icons.pending_actions;
      case 'pago':
        return Icons.check_circle;
      case 'preparando':
        return Icons.kitchen;
      case 'pronto para retirar':
        return Icons.shopping_bag;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final docRef =
        FirebaseFirestore.instance.collection('orders').doc(idPedido);

    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: const Text(
          'Status do Pedido',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[500],
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
        ),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dados = snapshot.data!;
          final status = dados['status_pedido'] ?? 'desconhecido';
          final total = (dados['total'] ?? 0).toDouble();
          final items = List<Map<String, dynamic>>.from(dados['items'] ?? []);

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informações principais
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[200],
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pedido ID: $idPedido',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(iconeDoStatus(status),
                              color: corDoStatus(status), size: 28),
                          const SizedBox(width: 10),
                          Text(
                            'Status: ${status.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: corDoStatus(status),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Lista de itens
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final preco = (item["preco"] is num)
                          ? item["preco"].toDouble()
                          : double.tryParse(item["preco"].toString()) ?? 0.0;
                      final qtd = (item["qty"] is num)
                          ? item["qty"]
                          : int.tryParse(item["qty"].toString()) ?? 1;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.orange[200],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 4),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.fastfood, size: 30),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['nome'] ?? 'Produto sem nome',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Qtd: $qtd'),
                                ],
                              ),
                            ),
                            Text(
                              'R\$ ${(preco * qtd).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Total
                Text(
                  'Total: R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                // Botão voltar
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 10,
                      backgroundColor:
                          const Color.fromRGBO(249, 225, 75, 100),
                      foregroundColor: Colors.black,
                      fixedSize: const Size(250, 50),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/principal');
                    },
                    child: const Text('Voltar'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
