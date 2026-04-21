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
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const PantallaBienvenida(),
    );
  }
}

// --- PANTALLA DE BIENVENIDA ---
class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // CONTAINER: Para el fondo y espaciado
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          // COLUMN: Alineación vertical de elementos
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CINEMAS",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.movie_filter,
              size: 100,
              color: Colors.indigo,
            ), // Icono de tu borrador
            const SizedBox(height: 20),
            const Text("BIENVENIDO", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 50),

            // Botones CONTAINER
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantallaLogin()),
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    "Iniciar sesión",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Crear Cuenta",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
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
                color: Colors.grey[300],
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
                  "Descripción de la película.",
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "INICIO DE SESIÓN",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: "Usuario")),
            const TextField(
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
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
