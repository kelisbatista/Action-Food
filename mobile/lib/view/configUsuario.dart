import 'package:action_food/pipeTelefone.dart';
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
        'telefone': PipeTelefone.pipeTelefone(telefone),
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
        msg = 'Por segurança, faça login novamente.';
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
          'Tem certeza que deseja excluir sua conta? Essa ação é permanente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Erro: faça login novamente para excluir.')),
                );
              } finally {
                setState(() => _loading = false);
              }
            },
            child: const Text('Excluir'),
          )
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.orange[600]),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        elevation: 0,
        title: const Text(
          'Configurações do Usuário',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
          onPressed: () => Navigator.pushNamed(context, '/principal'),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Card principal
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Ícone Usuário
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange[50],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.orange[600],
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Gerencie suas informações',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // TELEFONE
                        TextField(
                          controller: _telefoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(
                              'Novo telefone', Icons.phone_iphone),
                        ),
                        const SizedBox(height: 12),

                        // Botão atualizar telefone
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _atualizarTelefone,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: Colors.orange[600],
                            ),
                            child: const Text(
                              'Atualizar Telefone',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // SENHA
                        TextField(
                          controller: _senhaController,
                          obscureText: true,
                          decoration: _inputDecoration(
                              'Nova senha', Icons.lock_outline),
                        ),
                        const SizedBox(height: 12),

                        // Botão atualizar senha
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _atualizarSenha,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: Colors.orange[600],
                            ),
                            child: const Text(
                              'Atualizar Senha',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // EXCLUIR CONTA
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _excluirConta,
                            icon: const Icon(Icons.delete_forever),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            label: const Text(
                              'Excluir Conta',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
