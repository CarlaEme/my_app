import 'dart:convert';
import 'package:http/http.dart' as http;

class PeliculaService {
  // Tu llave real obtenida de TMDb
  final String _apiKey = "afeb6906a4711a65f705365cc8432512";

  Future<void> consultarCartelera() async {
    // Definimos la URL para obtener películas populares en español
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&language=es-MX',
    );

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final Map<String, dynamic> datos = jsonDecode(respuesta.body);
        final List peliculas = datos['results'];

        print("--- CONEXIÓN EXITOSA CON TMDB ---");
        print("Se recuperaron ${peliculas.length} películas para tu catálogo.");

        // Imprime el nombre de la primera película en la consola
        if (peliculas.isNotEmpty) {
          print("Película de estreno: ${peliculas[0]['title']}");
        }
      } else {
        print("Error del servidor: ${respuesta.statusCode}");
      }
    } catch (e) {
      print("Error al conectar: $e");
    }
  }
}
