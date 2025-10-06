import 'package:action_food/view/carrinho.dart';
import 'package:action_food/view/configUsuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  User? user;
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> itensCarrinho = [];
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        if (mounted) {
          setState(() {
            userData = doc.data() as Map<String, dynamic>;
          });
        }
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange[300]),
              child: Text(
                userData == null ? 'Olá! Usuário' : 'Olá, ${userData!['nome']}',
                style: const TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Página Inicial'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/configuracoes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Pedidos'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Carrinho(itensCarrinho: itensCarrinho),
                  ),
                );
              },
            ),
            ListTile(
              minVerticalPadding: 400,
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Builder(
              builder: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.menu,
                                color: Colors.black, size: 40),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                      ],
                    ),
                    Image.asset('assets/logoaction.png',
                        width: 150, height: 150),
                    Text(
                      'Bem-vindo à Página Principal!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Aqui você lista os estabelecimentos
                    const Estabs("assets/logoaction.png", "Fulano", "Comida"),
                    const Estabs("assets/logoaction.png", "Ciclano", "Lanches"),
                  ],
                ),
              ),
            ),
    );
  }
}

class Estabs extends StatelessWidget {
  final String imagemEstab;
  final String nomeEstab;
  final String descricaoEstab;

  const Estabs(this.imagemEstab, this.nomeEstab, this.descricaoEstab,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
        color: Colors.orange[200],
      ),
      width: 350,
      height: 100,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(imagemEstab, width: 80, height: 80),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nomeEstab,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                descricaoEstab,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
