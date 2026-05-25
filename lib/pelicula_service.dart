import 'dart:convert';
import 'package:http/http.dart' as http;

class PeliculaService {
  // Llave real obtenida de TMDb
  final String _apiKey = "afeb6906a4711a65f705365cc8432512";

  Future<List<dynamic>> consultarCartelera() async {
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

        return peliculas; // <--- Llista de la API
      } else {
        print("Error del servidor: ${respuesta.statusCode}");
        return []; // Si hay error, devuelve lista vacía
      }
    } catch (e) {
      print("Error al conectar: $e");
      return []; // Si hay excepción, devuelve lista vacía
    }
  }
}
