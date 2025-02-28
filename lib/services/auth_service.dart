import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000/api/users";

  /// 🟢 **Login de usuario**
    Future<Map<String, String>?> login(String email, String password) async {
        final response = await http.post(
          Uri.parse("$baseUrl/login/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            "token": data["access"],
            "nombre": data["nombre"] ?? "Usuario" // 🔹 Si el nombre es null, usa "Usuario"
          };
        } else {
          return null;
        }
      }

  /// 🔵 **Registro de usuario**
  Future<bool> register(String username, String firstName, String lastName, String email, String phone, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "password": password,
      }),
    );

    return response.statusCode == 201;
  }

  /// 🟠 **Cambiar rol (Cliente <-> Prestador de Servicio)**
  Future<bool> cambiarRol(String token, String nuevoRol) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cambiar-rol/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"  // 🔹 Aquí se envía el token
      },
      body: jsonEncode({"role": nuevoRol}),
    );

    return response.statusCode == 200;
  }

}
