import 'package:flutter/material.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({super.key});

  @override
  State<Pedidos> createState() => _PedidosState();
}
  class _PedidosState extends State<Pedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        automaticallyImplyLeading: false,
        leading: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/principal');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[500],
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 25),
          ),
        backgroundColor: Colors.orange[500],
      ),
      body: const Center(
        child: PedidosWidget(),
      ),
    );
  }
}

class PedidosWidget  extends StatefulWidget {
  const PedidosWidget({super.key});

  @override
  State<Pedidos> createState() => _PedidosState();
}
  class _PedidosWidgetState extends State<Pedidos> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Text('Pedidos Widget'),
    );
  }
}