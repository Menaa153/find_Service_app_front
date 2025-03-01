import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(), // ruta de registro
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/main') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => MainScreen(
              token: args['token']!,
              nombreUsuario: args['nombre']!,
            ),
          );
        }
        return null;
      },
    );
  }
}


