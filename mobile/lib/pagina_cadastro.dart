import 'package:flutter/material.dart';

class PaginaCadastro extends StatelessWidget{
  const PaginaCadastro({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: Text('Cadastro',
        textAlign: TextAlign.center)
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logoaction.png', width: 200, height: 200,),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Nome',
                      fillColor: Colors.orange[100],
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                      fillColor: Colors.orange[100],
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Senha',
                      fillColor: Colors.orange[100],
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );

  }
}