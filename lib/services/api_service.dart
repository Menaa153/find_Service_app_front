import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000/api/users";


  Future<bool> convertirEnPrestador(String token, String categoria, String descripcion, double lat, double lon) async {
    final response = await http.post(
      Uri.parse("$baseUrl/convertir-a-prestador/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "categoria": categoria,
        "descripcion": descripcion,
        "lat": lat,
        "lon": lon
      }),
    );

    return response.statusCode == 200;
  }

  Future<List<dynamic>> buscarPrestadores(double lat, double lon, String categoria) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/buscar-prestadores/?lat=$lat&lon=$lon&categoria=${categoria.toLowerCase()}")); // 🔹 Convertir a minúsculas

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al buscar prestadores");
    }
  }

  Future<Map<String, dynamic>> obtenerPerfil(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/perfil/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener el perfil");
    }
  }
}