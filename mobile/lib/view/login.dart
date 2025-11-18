import 'package:action_food/mostraErroAuth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: senhaCtrl.text.trim(),
      );
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/principal');
    } on FirebaseAuthException catch (e) {
      mostrarErroAuth(context, e, 'login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(backgroundColor: Colors.orange[500]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('Faça seu login',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Image.asset('assets/logoaction.png', width: 200, height: 200),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          fillColor: Colors.orangeAccent,
                          filled: true)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: senhaCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Senha',
                          fillColor: Colors.orangeAccent,
                          filled: true)),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                elevation: 10,
                backgroundColor: const Color.fromRGBO(249, 225, 75, 100),
                foregroundColor: Colors.black,
                fixedSize: const Size(250, 50),
                textStyle:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
