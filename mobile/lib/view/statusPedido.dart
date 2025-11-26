import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusPedido extends StatelessWidget {
  final String idPedido;

  const StatusPedido({required this.idPedido, super.key});

  // ------------------ COR DO STATUS ------------------
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
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  // ------------------ ÍCONE DO STATUS ------------------
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
        return Icons.help_outline;
    }
  }

  Future<String> getTelefone(String estabId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('estabelecimentos')
          .doc(estabId)
          .get();

      return doc.data()?['telefone'] ?? '';
    } catch (e) {
      print("Erro ao buscar telefone: $e");
      return '';
    }
  }

  Future<String> getChavePix(String estabId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('estabelecimentos')
          .doc(estabId)
          .get();

      return doc.data()?['pix'] ?? '';
    } catch (e) {
      print("Erro ao buscar chave PIX: $e");
      return '';
    }
  }

  // ------------------ FORMATAR TELEFONE (GARANTIR DDI) ------------------
  String formatarWhats(String telefone) {
    String digits = telefone.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length == 11) {
      return "55$digits"; // BR + DDD + número
    }
    return digits;
  }

  @override
  Widget build(BuildContext context) {
    final docRef =
        FirebaseFirestore.instance.collection('orders').doc(idPedido);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: const Text(
          'Status do Pedido',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
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
          final nomeEstab = dados['nomeEstab'] ?? 'Estabelecimento';
          final tipoPagamento = dados['tipoPagamento'] ?? '';
          final estabId = dados['estabId'] ?? '';

          return FutureBuilder<List<String>>(
            future: Future.wait([getChavePix(estabId), getTelefone(estabId)]),
            builder: (context, asyncSnap) {
              if (!asyncSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final chavePix = asyncSnap.data![0];
              final telefoneEstab = asyncSnap.data![1];

              final telefoneFormatado = formatarWhats(telefoneEstab);

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------------------- HEADER --------------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeEstab,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Pedido ID: $idPedido',
                              style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(iconeDoStatus(status),
                                  color: Colors.black87, size: 28),
                              const SizedBox(width: 10),
                              const Text(
                                'Status:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: corDoStatus(status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: const TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // -------------------- ITENS --------------------
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['nome'] ?? 'Item sem nome',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text('Qtd: $qtd'),
                                    ],
                                  ),
                                ),
                                Text(
                                  'R\$ ${(preco * qtd).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // -------------------- PIX + WHATS --------------------
 // -------------------- PIX + WHATS --------------------
if (tipoPagamento.contains('pix') && chavePix.isNotEmpty)
  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Pague com PIX',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),

      // CAIXA ESTILIZADA
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [

            // Linha da chave PIX
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chave PIX:',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),

                // BOTÃO DE COPIAR ESTILIZADO
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // amarelo
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: chavePix));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Chave PIX copiada!')),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.copy, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Copiar',
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // BOTÃO WHATS VERDE
            if (telefoneFormatado.isNotEmpty)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // COR DO WHATS
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  elevation: 6,
                ),
                onPressed: () async {
                  final mensagem = Uri.encodeComponent(
                      "Olá! Acabei de realizar um pedido e gostaria de confirmar.");
                  final url =
                      "https://wa.me/$telefoneFormatado?text=$mensagem";

                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  }
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wechat_sharp, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Enviar mensagem no WhatsApp',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ],
  ),

                    const SizedBox(height: 20),

                    // -------------------- TOTAL --------------------
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Total: R\$ ${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
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
                            onPressed: () =>
                                Navigator.pushNamed(context, '/principal'),
                            child: const Text('Voltar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
