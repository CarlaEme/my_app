import 'package:flutter/material.dart';

void main() {
  runApp(const CinemasApp());
}

class CinemasApp extends StatelessWidget {
  const CinemasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinemas',
      // Agregamos un tema oscuro general para que combine con el cine
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.red),
      home: const PantallaBienvenida(),
    );
  }
}

// --- PANTALLA DE BIENVENIDA (MODIFICADA PARA TU ACTIVIDAD) ---
class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // STACK: Para encimar el texto sobre la imagen
        children: [
          // 1. LA IMAGEN DE FONDO
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/imagen_principal.jpeg",
                ), // Asegúrate que el nombre coincida con tu archivo
                fit: BoxFit.cover, // Cubre toda la pantalla
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(
                    0.1,
                  ), // Capa oscura para leer mejor el texto
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // 2. EL CONTENIDO (Nombre, Bienvenida y Botón)
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Bienvenido",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 450),

                // Botón Iniciar Sesión con Container para diseño personalizado
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaLogin(),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[900],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- PANTALLA DE DETALLE ---
class PantallaDetalle extends StatelessWidget {
  const PantallaDetalle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de Película")),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[800],
                child: const Icon(Icons.image, size: 100),
              ),
              Container(
                width: double.infinity,
                color: Colors.black54,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Título de la Película",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 5),
                    Text(" 4.5 | Acción | 2h 15min"),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Reseña",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Descripción de la película que vendrá desde la base de datos.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- PANTALLA DE LOGIN ---
class PantallaLogin extends StatelessWidget {
  const PantallaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Acceso")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "INICIO DE SESIÓN",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(
                labelText: "Usuario",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PantallaDetalle(),
                ),
              ),
              child: const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}
