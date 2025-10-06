import 'package:action_food/pedidoService.dart';
import 'package:action_food/view/cadastro.dart';
import 'package:action_food/view/carrinho.dart';
import 'package:action_food/view/login.dart';
import 'package:action_food/view/principal.dart';
import 'package:action_food/view/telaInicial.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const TelaInicial(),
        '/cadastrar': (_) => const Cadastro(),
        '/login': (_) => const Login(),
        '/principal': (_) => const Principal(),
        '/carrinho': (_) => Carrinho(itensCarrinho: []),
      },
    );
  }
}
