import 'package:flutter/material.dart';

enum TipoPagamento { estab , pix }

class Pagamento extends StatefulWidget {
  const Pagamento(String idEstab, String total, {super.key});

  @override
  State<Pagamento> createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  TipoPagamento? tipoEscolhido = TipoPagamento.estab;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioGroup<TipoPagamento>(
          groupValue: tipoEscolhido,
          onChanged: (TipoPagamento? value) {
            setState(() {
              tipoEscolhido = value;
            });
          },
          child: const Column(
            children: <Widget>[
              ListTile(
                title: Text('Pagamento no estabelecimento'),
                leading: Radio<TipoPagamento>(value: TipoPagamento.estab),
              ),
              ListTile(
                title: Text('Pix'),
                leading: Radio<TipoPagamento>(value: TipoPagamento.pix),
              ),
            ],
          ),
        ),
      ], 
    );
  }
}