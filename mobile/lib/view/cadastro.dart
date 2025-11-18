import 'package:action_food/mostraErroAuth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  final nomeCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();

  Future<void> cadastrar() async {
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: senhaCtrl.text.trim(),
      );

      final uid = cred.user!.uid;

      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'email': emailCtrl.text.trim(),
        'nome': nomeCtrl.text.trim(),
        'telefone': telefoneCtrl.text.trim(),
        'cpf': cpfCtrl.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/principal');
    } on FirebaseAuthException catch (e) {
      mostrarErroAuth(context, e, 'cadastro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Image.asset('assets/logoaction.png', width: 200, height: 200),
          Column(
            children: [
              const Text('Junte-se a nós!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      fillColor: Colors.orangeAccent,
                      prefixIcon: Icon(Icons.email), 
                      filled: true,
                      labelText: 'Email')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: senhaCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                        fillColor: Colors.orangeAccent,
                        filled: true,
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Senha')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(
                        fillColor: Colors.orangeAccent,
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Nome Completo')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: telefoneCtrl,
                    decoration: const InputDecoration(
                        fillColor: Colors.orangeAccent,
                        filled: true,
                        prefixIcon: Icon(Icons.phone), 
                        labelText: 'Telefone')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: cpfCtrl,
                    decoration: const InputDecoration(
                        fillColor: Colors.orangeAccent,
                        filled: true,
                        prefixIcon: Icon(Icons.badge), 
                        labelText: 'CPF')),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: cadastrar, 
                  style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                elevation: 10,
                backgroundColor: const Color.fromRGBO(249, 225, 75, 100),
                foregroundColor: Colors.black,
                fixedSize: const Size(250, 50),
                textStyle:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
                  
                  child: const Text('Cadastrar'))
            ],
          ),
        ],
      ),
    );
  }
}
