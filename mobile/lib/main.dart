import 'package:action_food/pagina_cadastro.dart';
import 'package:action_food/tela_inicial.dart';
import 'package:flutter/material.dart';
import 'pagina_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TelaInicial(),
        '/login': (context) => PaginaLogin(),
        '/cadastrar': (context) => PaginaCadstro(),
      }
    );
  }
}
