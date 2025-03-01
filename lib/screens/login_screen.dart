import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });

    final response = await authService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      Navigator.pushReplacementNamed(
        context,
        '/main',
        arguments: {
          "token": response["token"]!,
          "nombre": response["nombre"]!,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Credenciales inválidas")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Correo")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Contraseña"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: isLoading ? CircularProgressIndicator() : Text("Iniciar Sesión"),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text("¿No tienes cuenta? Regístrate aquí"),
            ),
          ],
        ),
      ),
    );
  }
}
