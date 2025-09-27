import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 50,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/logoaction.png',
                  width: 200,
                  height: 200,
                ),
              ),
              Text(
                'Action Food',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    elevation: 10,
                    backgroundColor: Color.fromRGBO(249, 225, 75, 100),
                    foregroundColor: Colors.black,
                    fixedSize: Size(250, 50),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cadastrar');
                  },
                  child: Text('Cadastrar-se'),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  elevation: 10,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  fixedSize: Size(250, 50),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Ir para Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
