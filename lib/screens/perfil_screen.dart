import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import 'convertirse_prestador_screen.dart';


class PerfilScreen extends StatefulWidget {
  final String token;
  final String username;

  PerfilScreen({required this.token, required this.username});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

void cerrarSesion(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/login');
}

class _PerfilScreenState extends State<PerfilScreen> {
  File? _image;
  bool _isLoading = true;
  String nombre = '', apellido = '', email = '', telefono = '', _role = '', _profilePictureUrl = '';
  bool isEditingName = false, isEditingEmail = false, isEditingPhone = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Cargar datos del perfil cuando inicie la pantalla
  }

  // Método para cargar los datos del perfil
  Future<void> _loadProfileData() async {
    try {
      // Llamada a la API para obtener el perfil
      var profile = await ApiService().obtenerPerfil(widget.token);
    
      // Imprimir la respuesta de la API en la consola para ver los datos
      print(profile);  // Aquí es donde estamos verificando la respuesta de la API

      // Asignar los valores recibidos del perfil a las variables de estado
      setState(() {
        nombre = profile['nombre'] ?? '';  // Asegúrate de que el campo de nombre es correcto
        apellido = profile['apellido'] ?? '';
        email = profile['email'] ?? '';
        telefono = profile['telefono'] ?? '';
        _role = profile['role'] ?? '';  // Se añade el role aquí
        _profilePictureUrl = profile['profile_picture'] ?? '';  // Asignamos la URL de la imagen
        emailController.text = email;
        phoneController.text = telefono;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading profile: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para cargar la imagen de perfil
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Método para subir la imagen
  Future<void> _uploadProfilePicture() async {
    if (_image == null) return;
  
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/api/users/upload-profile-picture/'),
    );

    // Agregar el token de autenticación
    request.headers['Authorization'] = 'Bearer ${widget.token}';
  
    // Agregar la imagen como archivo multipart
    request.files.add(await http.MultipartFile.fromPath('profile_picture', _image!.path));

    // Enviar la solicitud
    final response = await request.send();

    // Verificar la respuesta
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Foto de perfil actualizada")),
      );
      _loadProfileData();  // Recargar los datos del perfil después de actualizar la foto
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al subir la foto de perfil")),
      );
    }
  }

  // Método para cambiar la contraseña
  Future<void> _changePassword(String oldPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/users/change-password/'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
      body: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Contraseña cambiada exitosamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cambiar la contraseña")),
      );
    }
  }

  // Método para eliminar la cuenta
  Future<void> _deleteAccount() async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/users/delete/'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 204) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar la cuenta")),
      );
    }
  }

  // Redirigir al formulario de "Convertirse en prestador"
  void _goToConvertirsePrestador() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConvertirsePrestadorScreen(token: widget.token)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mi Cuenta")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Muestra un indicador de carga mientras obtenemos los datos
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostrar foto de perfil
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profilePictureUrl.isNotEmpty
                          ? NetworkImage(_profilePictureUrl)  // Si hay URL de imagen, la mostramos 
                          : AssetImage('assets/default_profile.png') as ImageProvider, // Imagen predeterminada si no hay imagen
                      child: _image == null
                          ? Icon(Icons.camera_alt, color: Colors.white)
                          : Container(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: _uploadProfilePicture,
                    child: Text("Editar Foto de Perfil"),
                  ),
                  SizedBox(height: 16),
                  // Mostrar los campos de información
                  _infoUsuario("Nombre Completo", "$nombre $apellido"),
                  _infoUsuario("Correo", email),
                  _infoUsuario("Teléfono", telefono),
                  _infoUsuario("Rol", _role),
                  Divider(),
                  SizedBox(height: 16),
                  // Condición para mostrar el botón solo si el rol es "cliente"
                  if (_role == "cliente") 
                    _opcionCuenta("Convertirse en prestador de servicio", Icons.change_circle_outlined, () {
                      _goToConvertirsePrestador();
                    }),
                  // Cambiar Contraseña
                  _opcionCuenta("Cambiar Contraseña", Icons.lock, () {
                    _showChangePasswordDialog();
                  }),
                  // Eliminar Cuenta
                  _opcionCuenta("Eliminar Cuenta", Icons.delete, () {
                    _showDeleteAccountDialog(); 
                  }),
                  // Cerrar sesión
                  _opcionCuenta("Cerrar sesión", Icons.exit_to_app, () => cerrarSesion(context)),
                ],
              ),
            ),
    );
  }

  // Mostrar el diálogo de cambio de contraseña
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController oldPasswordController = TextEditingController();
        TextEditingController newPasswordController = TextEditingController();
        return AlertDialog(
          title: Text("Cambiar Contraseña"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Contraseña Actual"),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Nueva Contraseña"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _changePassword(
                  oldPasswordController.text,
                  newPasswordController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text("Cambiar"),
            ),
          ],
        );
      },
    );
  }

  // Mostrar el diálogo de eliminación de cuenta
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmar eliminación de cuenta"),
          content: Text("¿Estás seguro de que deseas eliminar tu cuenta?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _deleteAccount();
                Navigator.of(context).pop();
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  // Widget para mostrar la información del usuario
  Widget _infoUsuario(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(valor),
        ],
      ),
    );
  }

  // Widget para las opciones de cuenta
  Widget _opcionCuenta(String texto, IconData icono, VoidCallback accion) {
    return ListTile(
      title: Text(texto),
      leading: Icon(icono),
      onTap: accion,
    );
  }
}
