import 'package:action_food/view/carrinho.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PagEstabelecimento extends StatefulWidget {
  final String idEstab; 
  const PagEstabelecimento(this.idEstab, {super.key});

  @override
  State<PagEstabelecimento> createState() => _PagEstabelecimentoState();
}

class _PagEstabelecimentoState extends State<PagEstabelecimento> {

  Map<String, dynamic>? estabData;
  List<Map<String, dynamic>> produtos = [];
  List<Map<String, dynamic>> itensCarrinho = [];

  @override
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

        final produtosSnapshot = await FirebaseFirestore.instance
            .collection('estabelecimentos')
            .doc(widget.idEstab)
            .collection('produtos')
            .get();

        if (mounted) {
          setState(() {
            produtos = produtosSnapshot.docs
                .map((doc) => doc.data())
                .toList();
          });
        }
      }
    } catch (e) {
      print("Erro ao carregar estabelecimento: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(estabData?['nome'] ?? 'Estabelecimento'),
        backgroundColor: Colors.orange[500],
      ),

      backgroundColor: Colors.orange[50],
      body: estabData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                    "Produtos disponíveis:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                  // Lista de produtos
                  Expanded(
                    child: produtos.isEmpty
                        ? const Center(
                            child: Text("Nenhum produto cadastrado."),
                          )
                        : ListView.builder(
                            itemCount: produtos.length,
                            itemBuilder: (context, index) {
                              final produto = produtos[index];
                              return Card(
                                color: Colors.orange[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 4),
                                child: ListTile(
                                  leading: const Icon(Icons.fastfood),
                                  title: Text(
                                    produto['nome'] ?? 'Produto sem nome',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    produto['descricao'] ??
                                        'Sem descrição',
                                  ),
                                  trailing: Text(
                                    produto['preco'] != null
                                        ? 'R\$ ${produto['preco']}'
                                        : 'R\$ -',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    var preco = produto['preco'] ?? 0.0;
                                    preco = double.tryParse(preco.toString()) ?? 0.0;
                                    // Adiciona o produto ao carrinho
                                    final itemPedido = {
                                      'nome': produto['nome'],
                                      'preco': preco,
                                      'qty': 1,
                                      'imageUrl': produto['imagemUrl'] ?? '',
                                    };
                                    setState((){
                                      itensCarrinho.add(itemPedido);
                                    });
                                     Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (_) => Carrinho(itensCarrinho: itensCarrinho),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
        
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
