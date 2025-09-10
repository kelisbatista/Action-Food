import 'package:flutter/material.dart';

class PaginaCadastro extends StatelessWidget{
  const PaginaCadastro({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: Text('Cadastro',),
        centerTitle: true,
        ),
      body: ListView(
        children: [
            Image.asset('assets/logoaction.png', width: 200, height: 200,),

            Column(
              children: [

                Text('Cadastre seu login', 
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black ,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',)
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Senha',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Confirmar Senha',
                    ),
                  ),
                ),
                SizedBox(height: 20),


                Text('Dados Pessoais', 
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Nome Completo',
                    ),  
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Telefone',
                    ),  
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.badge),
                      labelText: 'CPF',
                    ),  
                  ),
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    // Ação ao pressionar o botão de cadastro


                    Navigator.pushNamed(context, '/principal');
                  },
                  child: 
                  Text('Cadastrar'),
                )

              ],
            ),
          ],
        ),
    );
  }
}