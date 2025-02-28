import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  final String token;

  PerfilScreen({required this.token});

  void cerrarSesion(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mi Cuenta")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 40, backgroundColor: Colors.grey[300]),
                SizedBox(width: 16),
                TextButton(onPressed: () {}, child: Text("Editar foto de perfil")),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            _infoUsuario("Nombre", "Juanito"),
            _infoUsuario("Apellido", "Perez"),
            _infoUsuario("Correo", "jua*****@gmail.com"),
            _infoUsuario("Teléfono", "320****432"),
            _infoUsuario("Servicios", "Cliente"),
            SizedBox(height: 16),
            Divider(),
            _opcionCuenta("Cambiar contraseña", Icons.lock, () {}),
            _opcionCuenta("Eliminar cuenta", Icons.delete, () {}),
            _opcionCuenta("Cerrar sesión", Icons.exit_to_app, () => cerrarSesion(context)),
          ],
        ),
      ),
    );
  }

  Widget _infoUsuario(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(valor),
        ],
      ),
    );
  }

  Widget _opcionCuenta(String texto, IconData icono, VoidCallback accion) {
    return ListTile(
      title: Text(texto),
      leading: Icon(icono),
      onTap: accion,
    );
  }
}
