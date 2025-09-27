import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[500],
        appBar: AppBar(
          backgroundColor: Colors.orange[500],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logoaction.png', width: 200, height: 200),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
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
                    child: TextField(
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/principal');
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  elevation: 10,
                  backgroundColor: Color.fromRGBO(249, 225, 75, 100),
                  foregroundColor: Colors.black,
                  fixedSize: Size(250, 50),
                  textStyle:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                child: Text('Login'),
              )
            ],
          ),
        ));
  }
}
