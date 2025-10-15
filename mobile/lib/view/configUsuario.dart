import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigUsuario extends StatefulWidget {
  const ConfigUsuario({super.key});

  @override
  State<ConfigUsuario> createState() => _ConfigUsuarioState();
}

class _ConfigUsuarioState extends State<ConfigUsuario> {
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _loading = false;

  Future<void> _atualizarTelefone() async {
    final user = _auth.currentUser;
    final telefone = _telefoneController.text.trim();

    if (user == null || telefone.isEmpty) return;

    setState(() => _loading = true);
    try {
      await _firestore.collection('usuarios').doc(user.uid).update({
        'telefone': telefone,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Telefone atualizado com sucesso!')),
      );
      _telefoneController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar telefone: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _atualizarSenha() async {
    final novaSenha = _senhaController.text.trim();
    final user = _auth.currentUser;

    if (user == null || novaSenha.isEmpty) return;

    setState(() => _loading = true);
    try {
      await user.updatePassword(novaSenha);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha atualizada com sucesso!')),
      );
      _senhaController.clear();
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao atualizar senha.';
      if (e.code == 'requires-recent-login') {
        msg = 'Por segurança, faça login novamente para alterar sua senha.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _excluirConta() async {
    final user = _auth.currentUser;
    if (user == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text(
          'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _loading = true);
              try {
                await _firestore.collection('usuarios').doc(user.uid).delete();
                await user.delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Conta excluída com sucesso!')),
                );
                Navigator.pushReplacementNamed(context, '/login');
              } on FirebaseAuthException catch (e) {
                String msg = 'Erro ao excluir conta.';
                if (e.code == 'requires-recent-login') {
                  msg = 'Por segurança, faça login novamente antes de excluir.';
                }
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(msg)));
              } finally {
                setState(() => _loading = false);
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: const Text(
          'Configurações do Usuário',
          style: TextStyle(color: Color.fromARGB(255, 9, 9, 9)),
        ),
        automaticallyImplyLeading: false,
        leading: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/principal');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[500],
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 25),
          ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 14, 14, 14)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_pin,
                      size: 100,
                      color: Color.fromARGB(255, 221, 132, 58),
                    ),
                    const Text(
                      'Gerencie suas informações',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Atualizar telefone
                    TextField(
                      controller: _telefoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Novo telefone',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _atualizarTelefone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 221, 132, 58),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Atualizar Telefone',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Atualizar senha
                    TextField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Nova senha',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _atualizarSenha,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 221, 132, 58),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Atualizar Senha',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Excluir conta
                    ElevatedButton.icon(
                      onPressed: _excluirConta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 213, 35, 35),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon:
                          const Icon(Icons.delete_forever, color: Colors.white),
                      label: const Text(
                        'Excluir Conta',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}
