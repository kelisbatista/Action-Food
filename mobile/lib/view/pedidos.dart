import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Pedidos extends StatefulWidget {
  final String idUser;
  final String idEstab = '';

  const Pedidos(this.idUser, {super.key});

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {

  Map<String, dynamic>? estabData;
  List<Map<String, dynamic>> produtos = [];

  void initState() {
    super.initState();
    _loadEstabelecimento();
  }

  Future<void> _loadEstabelecimento() async {
    try {
      // Busca o documento do estabelecimento
      final estabDoc = await FirebaseFirestore.instance
          .collection('estabelecimentos')
          .doc(widget.idEstab)
          .get();

      if (estabDoc.exists && mounted) {
        setState(() {
          estabData = estabDoc.data();
        });
      }
    } catch (e) {
      print("Erro ao carregar estabelecimento: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        backgroundColor: Colors.orange[500],
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
          onPressed: () {
            Navigator.pushNamed(context, '/principal');
          },
        ),
      ),

      backgroundColor: Colors.orange[50],

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: widget.idUser)
            .snapshots(),
        builder: (context, snapshot) {
          // Enquanto carrega
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se não tiver pedidos
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum pedido encontrado.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final pedidos = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Histórico de Pedidos:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidos[index].data() as Map<String, dynamic>;
                      final nomeEstab =
                          estabData?['nomeEstabelecimento'] ?? 'Estabelecimento não encontrado';
                      final status =
                          pedido['status_pedido'] ?? 'Status não informado';

                      return Card(
                        color: Colors.orange[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: ListTile(
                          leading: const Icon(Icons.receipt_long),
                          title: Text(
                            nomeEstab,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "Status: $status",
                            style: TextStyle(
                              color: _corStatus(status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Aqui você pode abrir uma tela de detalhes do pedido
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _corStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pago':
        return Colors.green[800]!;
      case 'pendente':
        return Colors.orange[800]!;
      case 'cancelado':
        return Colors.red[800]!;
      default:
        return Colors.grey[700]!;
    }
  }
}
