import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusPedido extends StatelessWidget {
  final String idPedido;

  const StatusPedido({required this.idPedido, super.key});

  // Função que retorna cor de acordo com o status
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

  // Função que retorna ícone de acordo com o status
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
      appBar: AppBar(title: const Text('Status do Pedido')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dados = snapshot.data!;
          final status = dados['status_pedido'] ?? 'desconhecido';
          final total = dados['total'] ?? 0.0;
          final items = List<Map<String, dynamic>>.from(dados['items'] ?? []);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pedido ID: $idPedido',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(iconeDoStatus(status),
                        color: corDoStatus(status), size: 30),
                    const SizedBox(width: 10),
                    Text(
                      'Status: $status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: corDoStatus(status),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Itens:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Text(
                            'Qtd: ${item['qty']} - R\$ ${(item['price'] * item['qty']).toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                const Divider(),
                Text('Total: R\$ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // volta para a tela anterior
                  },
                  child: const Text('Voltar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
