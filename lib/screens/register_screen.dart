import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void register() async {
    setState(() {
      isLoading = true;
    });

    final success = await authService.register(
      usernameController.text,
      firstNameController.text,
      lastNameController.text,
      emailController.text,
      phoneController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registro exitoso, ahora puedes iniciar sesión")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en el registro")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Cuenta")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: "Usuario")),
            Row(
              children: [
                Expanded(child: TextField(controller: firstNameController, decoration: InputDecoration(labelText: "Nombre"))),
                SizedBox(width: 10),
                Expanded(child: TextField(controller: lastNameController, decoration: InputDecoration(labelText: "Apellido"))),
              ],
            ),
            Row(
              children: [
                Expanded(child: TextField(controller: emailController, decoration: InputDecoration(labelText: "Correo Electrónico"))),
                SizedBox(width: 10),
                Expanded(child: TextField(controller: phoneController, decoration: InputDecoration(labelText: "Teléfono"))),
              ],
            ),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Contraseña"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: isLoading ? CircularProgressIndicator() : Text("Crear Cuenta"),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("¿Ya tienes cuenta? Inicia sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
