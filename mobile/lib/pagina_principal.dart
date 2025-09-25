import 'package:flutter/material.dart';

class PaginaPrincipal extends StatelessWidget {
  PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(

              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.menu, color: Colors.black, size: 40,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            
            Image.asset('assets/logoaction.png', width: 150, height: 150),
            Text('Bem-vindo à Página Principal!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black ,
            ),
            ),
            SizedBox(height: 20),


                  Estabs("Fulano", "Comida"),
                ],
              ),
      ),
    );
  }
}

class Estabs extends StatelessWidget {

  final String nomeEstab;
  final String descricaoEstab;

  const Estabs(this.nomeEstab, this.descricaoEstab, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400, height: 100,
      color: Colors.white,
    );
  }
}
