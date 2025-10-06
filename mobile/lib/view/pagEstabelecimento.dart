import 'package:flutter/material.dart';

class Pagestabelecimento extends StatefulWidget{
  final String idEstab;
  const Pagestabelecimento(this.idEstab, {super.key});
  
  @override
  State<Pagestabelecimento> createState() => _PagEstabelecimentoState();
}

class _PagEstabelecimentoState extends State<Pagestabelecimento>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página do Estabelecimento'),
      ),
      body: Column(
        children: [
          const Text('Detalhes do Estabelecimento'),
          ElevatedButton(
            onPressed: () {
              // Ação ao adicionar ao carrinho
            },
            child: const Text('Adicionar ao Carrinho'),
          ),
          ElevatedButton(
            onPressed: () {
              // Ação ao visualizar o carrinho
              Navigator.pushNamed(context, '/carrinho');
            },
            child: const Text('Ver Carrinho'),
          ),
          ElevatedButton(
            onPressed: () {
              // Ação ao voltar para a tela principal
              Navigator.pop(context);
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
    }   
  }