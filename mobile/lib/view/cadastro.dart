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
          email: emailCtrl.text.trim(), password: senhaCtrl.text.trim());
      final uid = cred.user!.uid;

      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'email': emailCtrl.text.trim(),
        'nome': nomeCtrl.text.trim(),
        'telefone': telefoneCtrl.text.trim(),
        'cpf': cpfCtrl.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacementNamed(context, '/principal');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Image.asset('assets/logoaction.png', width: 200, height: 200),
          Column(
            children: [
              const Text('Cadastre seu login',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email), labelText: 'Email')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: senhaCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock), labelText: 'Senha')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Nome Completo')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: telefoneCtrl,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone), labelText: 'Telefone')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: cpfCtrl,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.badge), labelText: 'CPF')),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: cadastrar, child: const Text('Cadastrar'))
            ],
          ),
        ],
      ),
    );
  }
}
