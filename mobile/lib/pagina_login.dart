import 'package:flutter/material.dart';

class PaginaLogin extends StatelessWidget{
  const PaginaLogin({super.key});


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
      ),
      body:
      Center(
        child:
          Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
          child: 
          Image.asset('assets/logoaction.png', width: 200, height: 200,)
          ),            
        
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
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    fillColor: Colors.white,
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
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
            ],
          ),

          ElevatedButton(
            onPressed: () {
              // Ação ao pressionar o botão de login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(249, 225, 75 , 100),
              foregroundColor: Colors.black,
              fixedSize: Size(250, 50),
              textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),  
            ),
            child: 
            Text('Login'),
          )
        ],
      ),        
    )
    );
  }
}


