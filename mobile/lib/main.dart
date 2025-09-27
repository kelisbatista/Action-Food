import 'package:action_food/view/cadastro.dart';
import 'package:action_food/view/pagina_inicial.dart';
import 'package:action_food/view/principal.dart';
import 'package:flutter/material.dart';
import 'view/login.dart';
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
        theme: ThemeData(
          primarySwatch: Colors.orange,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.black,
              elevation: 10,
              backgroundColor: Color.fromRGBO(249, 225, 75, 100),
              foregroundColor: Colors.black,
              fixedSize: Size(250, 50),
              textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.orange[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => TelaInicial(),
          '/login': (context) => Login(),
          '/cadastrar': (context) => Cadastro(),
          '/principal': (context) => Principal(),
        });
  }
}
