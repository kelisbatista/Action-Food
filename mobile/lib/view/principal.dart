import 'package:action_food/view/pagEstabelecimento.dart';
import 'package:action_food/view/pedidos.dart';
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
  Map<String, dynamic>? estabData;
  Map<String, dynamic>? userData;
  

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadUserData();
    _loadEstab();
  }

  Future<void> _loadEstab() async {
    final estabDoc = await FirebaseFirestore.instance
        .collection('estabelecimentos')
        .doc()
        .get();

    if (estabDoc.exists && mounted) {
      setState(() {
        estabData = estabDoc.data as Map<String, dynamic>;
      });
    }
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user!.uid)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>;
        });
      }
    }
  }

  void _logout() async {


    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
    drawer: Drawer(
  child: Column(
    children: [
      Container(
        padding: const EdgeInsets.only(top: 40, bottom: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: Icon(Icons.person,
                  size: 55, color: Colors.orange.shade700),
            ),
            const SizedBox(height: 10),
            Text(
              userData?['nome'] ?? 'Carregando...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user?.email ?? '',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              userData?['telefone'] ?? '',
                style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 10),

      _drawerItem(
        icon: Icons.home,
        text: "Página Inicial",
        onTap: () => Navigator.pop(context),
      ),

      _drawerItem(
        icon: Icons.shopping_cart,
        text: "Pedidos",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Pedidos(user!.uid)),
          );
        },
      ),

      _drawerItem(
        icon: Icons.settings,
        text: "Configurações",
        onTap: () {
          Navigator.pushReplacementNamed(context, '/configuracoes');
        },
      ),

      const Spacer(),

      _drawerItem(
        icon: Icons.logout,
        text: "Sair",
        isDestructive: true,
        onTap: _logout,
      ),
      const SizedBox(height: 20),
    ],
  ),
),    
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Builder(
              builder: (context) => ListView(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: const Icon(Icons.menu,
                              color: Colors.black, size: 40),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Image.asset('assets/logoaction.png',
                        width: 150, height: 150),
                  ),
                  const Center(
                    child: Text(
                      'Bem-vindo à Página Principal!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('estabelecimentos')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Nenhum estabelecimento encontrado.",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        );
                      }

                      final estabelecimentos = snapshot.data!.docs;

                      return Column(
                        children: estabelecimentos.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Estabs(
                            "assets/logoaction.png",
                            data['nome'] ?? 'Nome indisponível',
                            data['descricao'] ?? 'Descrição indisponível',
                            doc.id,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

Widget _drawerItem({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
  bool isDestructive = false,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: isDestructive ? Colors.red : Colors.orange[700],
      size: 28,
    ),
    title: Text(
      text,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: isDestructive ? Colors.red : Colors.black87,
      ),
    ),
    onTap: onTap,
  );
}


class Estabs extends StatelessWidget {
  final String imagemEstab;
  final String nomeEstab;
  final String descricaoEstab;
  final String idEstab;

  const Estabs(
    this.imagemEstab,
    this.nomeEstab,
    this.descricaoEstab,
    this.idEstab, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
        context,
        MaterialPageRoute(
    builder: (_) => PagEstabelecimento(idEstab),
  ),
);

      },
      child: Container(
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
          children: [
            Image.asset(imagemEstab, width: 80, height: 80),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
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
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    descricaoEstab,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
