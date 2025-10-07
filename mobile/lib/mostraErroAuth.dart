import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void mostrarErroAuth(
    BuildContext context, FirebaseAuthException e, String tipo) {
  String mensagem = 'Ocorreu um erro. Tente novamente.';

  // Diferencia os erros de login e cadastro
  switch (e.code) {
    case 'user-not-found':
      if (tipo == 'login') mensagem = 'Email não encontrado.';
      break;
    case 'wrong-password':
      if (tipo == 'login') mensagem = 'Senha incorreta.';
      break;
    case 'invalid-email':
      mensagem = 'Email inválido.';
      break;
    case 'email-already-in-use':
      if (tipo == 'cadastro') mensagem = 'Esse email já está sendo usado.';
      break;
    case 'weak-password':
      if (tipo == 'cadastro') mensagem = 'Senha muito fraca.';
      break;
    case 'network-request-failed':
      mensagem = 'Falha na conexão. Verifique sua internet.';
      break;
  }

  // Mostra o alerta
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(tipo == 'login' ? 'Erro de Login' : 'Erro de Cadastro'),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
