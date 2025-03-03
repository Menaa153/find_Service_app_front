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


  Future<void> guardarReserva(String token, String prestadorId, String fecha, String hora) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/reservas/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prestador_id': prestadorId,
        'fecha': fecha,
        'hora': hora, // Envía la hora en formato de 24 horas
      }),
    );

    if (response.statusCode == 201) {
      // Reserva exitosa
      print('Reserva guardada');
    } else {
      // Manejar el error
      print('Error al guardar la reserva: ${response.statusCode}');
    }
  }

    // Método para obtener las reservas del cliente
  Future<List<dynamic>> obtenerReservas(String token) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/reservas/cliente/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos las reservas en formato JSON
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener las reservas');
    }
  }
}

