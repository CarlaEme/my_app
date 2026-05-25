import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'pelicula_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CinemasApp());
}

class CinemasApp extends StatelessWidget {
  const CinemasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinemas',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const PantallaBienvenida(),
    );
  }
}

// 1. PANTALLA DE BIENVENIDA

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/imagen_principal.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "BIENVENIDO",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 450),
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
                        fontSize: 16,
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

// 2. PANTALLA DE LOGIN

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acceso"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "INICIO DE SESIÓN",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Correo Electrónico",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: Colors.red),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: Colors.red),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.red[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    String correo = _correoController.text.trim();
                    String password = _passwordController.text.trim();

                    if (correo.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, llena todos los campos'),
                        ),
                      );
                      return;
                    }

                    try {
                      final consulta = await FirebaseFirestore.instance
                          .collection('usuarios')
                          .where('correo', isEqualTo: correo)
                          .where('password', isEqualTo: password)
                          .get();

                      if (consulta.docs.isNotEmpty) {
                        String nombreObtenido = consulta.docs.first.get(
                          'nombre',
                        );
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PantallaCatalogo(
                                nombreUsuario: nombreObtenido,
                              ),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Correo o contraseña incorrectos'),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: const Text(
                    "Entrar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PantallaRegistro(),
                      ),
                    );
                  },
                  child: const Text(
                    "¿No tienes cuenta? Regístrate aquí",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 3. PANTALLA DE REGISTRO

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "CREAR NUEVA CUENTA",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: "Nombre Completo",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: Colors.green),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Correo Electrónico",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: Colors.green),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: Colors.green),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    String nombre = _nombreController.text.trim();
                    String correo = _correoController.text.trim();
                    String password = _passwordController.text.trim();

                    if (nombre.isEmpty || correo.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor completa los campos'),
                        ),
                      );
                      return;
                    }
                    await FirebaseFirestore.instance
                        .collection('usuarios')
                        .add({
                          'nombre': nombre,
                          'correo': correo,
                          'password': password,
                          'fecha_registro': DateTime.now(),
                        });
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Registro Exitoso!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Registrar Cuenta",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 4. PANTALLA DE CATÁLOGO (INTEGRA API, FIRESTORE Y MENÚ DE SELECCIÓN)

class PantallaCatalogo extends StatefulWidget {
  final String nombreUsuario;
  const PantallaCatalogo({super.key, required this.nombreUsuario});

  @override
  State<PantallaCatalogo> createState() => _PantallaCatalogoState();
}

class _PantallaCatalogoState extends State<PantallaCatalogo> {
  late Future<List<dynamic>> _futuroPeliculas;

  // NUEVA VARIABLE: Guarda el catálogo seleccionado por el usuario en el menú superior
  String _catalogoSeleccionado = "Todos los Catálogos";

  @override
  void initState() {
    super.initState();
    _futuroPeliculas = PeliculaService().consultarCartelera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hola, ${widget.nombreUsuario}"),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.filter_list, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                const Text(
                  "Catálogo: ",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                DropdownButton<String>(
                  value: _catalogoSeleccionado,
                  dropdownColor: const Color(0xFF1E1E1E),
                  underline: Container(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 226, 204, 6),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  items:
                      <String>[
                        'Todos los Catálogos',
                        'Estrenos Mundiales (API)',
                        'Añadidas por Admin (Firebase)',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? nuevoCatalogo) {
                    if (nuevoCatalogo != null) {
                      setState(() {
                        _catalogoSeleccionado = nuevoCatalogo;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.amber),
            tooltip: "Administración",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PantallaAdmin()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "Cerrar Sesión",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const PantallaBienvenida(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('peliculas').snapshots(),
        builder: (context, snapshotFirestore) {
          return FutureBuilder<List<dynamic>>(
            future: _futuroPeliculas,
            builder: (context, snapshotAPI) {
              if (snapshotAPI.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                );
              }

              List<dynamic> listaCompleta = [];

              bool incluirAPI =
                  _catalogoSeleccionado == "Todos los Catálogos" ||
                  _catalogoSeleccionado == "Estrenos Mundiales (API)";
              bool incluirFirebase =
                  _catalogoSeleccionado == "Todos los Catálogos" ||
                  _catalogoSeleccionado == "Añadidas por Admin (Firebase)";

              if (snapshotAPI.hasData && incluirAPI) {
                listaCompleta.addAll(snapshotAPI.data!);
              }
              if (snapshotFirestore.hasData && incluirFirebase) {
                for (var doc in snapshotFirestore.data!.docs) {
                  var datos = doc.data() as Map<String, dynamic>;
                  datos['id_firestore'] = doc.id;
                  listaCompleta.insert(0, datos);
                }
              }

              if (listaCompleta.isEmpty) {
                return const Center(
                  child: Text("No hay películas en este catálogo."),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  itemCount: listaCompleta.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final pelicula = listaCompleta[index];

                    String titulo =
                        pelicula['title'] ?? pelicula['titulo'] ?? 'Sin título';
                    String urlImagen =
                        'https://via.placeholder.com/500x750?text=No+Image';

                    if (pelicula['poster_path'] != null) {
                      urlImagen =
                          'https://image.tmdb.org/t/p/w500${pelicula['poster_path']}';
                    } else if (pelicula['imagen_url'] != null &&
                        pelicula['imagen_url'].toString().isNotEmpty) {
                      urlImagen = pelicula['imagen_url'];
                    }

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PantallaDetalle(datosPelicula: pelicula),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.network(
                              urlImagen,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (c, e, s) => const Center(
                                child: Icon(Icons.broken_image, size: 50),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              color: Colors.black87,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                titulo,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 5. PANTALLA DE DETALLE

class PantallaDetalle extends StatelessWidget {
  final Map<String, dynamic> datosPelicula;
  const PantallaDetalle({super.key, required this.datosPelicula});

  @override
  Widget build(BuildContext context) {
    String titulo =
        datosPelicula['title'] ?? datosPelicula['titulo'] ?? 'Sin título';
    String sinopsis =
        datosPelicula['overview'] ??
        datosPelicula['sinopsis'] ??
        'Sin sinopsis.';

    String anio =
        datosPelicula['release_date'] ?? datosPelicula['anio'] ?? 'N/A';
    if (anio.length > 4) anio = anio.substring(0, 4);

    String director = datosPelicula['director'] ?? 'No especificado';
    String genero = datosPelicula['genero'] ?? 'General';

    String urlImagen = 'https://via.placeholder.com/500x300?text=No+Image';
    if (datosPelicula['backdrop_path'] != null) {
      urlImagen =
          'https://image.tmdb.org/t/p/w500${datosPelicula['backdrop_path']}';
    } else if (datosPelicula['imagen_url'] != null) {
      urlImagen = datosPelicula['imagen_url'];
    }

    return Scaffold(
      appBar: AppBar(title: Text(titulo), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              urlImagen,
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                height: 230,
                color: Colors.grey[900],
                child: const Icon(Icons.image, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Chip(
                        label: Text("Año: $anio"),
                        backgroundColor: Colors.red[900],
                      ),
                      const SizedBox(width: 10),
                      Chip(
                        label: Text("Género: $genero"),
                        backgroundColor: Colors.grey[800],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Director: $director",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.amber,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Sinopsis",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sinopsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. PANTALLA DE ADMINISTRACIÓN (ALTA, BAJA Y EDICIÓN INTEGRADA)

class PantallaAdmin extends StatefulWidget {
  const PantallaAdmin({super.key});

  @override
  State<PantallaAdmin> createState() => _PantallaAdminState();
}

class _PantallaAdminState extends State<PantallaAdmin> {
  final _tituloCtrl = TextEditingController();
  final _anioCtrl = TextEditingController();
  final _directorCtrl = TextEditingController();
  final _generoCtrl = TextEditingController();
  final _sinopsisCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();

  String? _idSeleccionado;
  bool _editando = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _anioCtrl.dispose();
    _directorCtrl.dispose();
    _generoCtrl.dispose();
    _sinopsisCtrl.dispose();
    _imgCtrl.dispose();
    super.dispose();
  }

  void _limpiarFormulario() {
    _tituloCtrl.clear();
    _anioCtrl.clear();
    _directorCtrl.clear();
    _generoCtrl.clear();
    _sinopsisCtrl.clear();
    _imgCtrl.clear();
    setState(() {
      _idSeleccionado = null;
      _editando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administración de Catálogo"),
        backgroundColor: const Color.fromARGB(255, 224, 147, 46),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      _editando ? "EDITAR PELÍCULA" : "ALTA DE PELÍCULA",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _editando
                            ? const Color.fromRGBO(177, 140, 29, 1)
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _tituloCtrl,
                      decoration: const InputDecoration(
                        labelText: "Título",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _anioCtrl,
                      decoration: const InputDecoration(
                        labelText: "Año",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _directorCtrl,
                      decoration: const InputDecoration(
                        labelText: "Director",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _generoCtrl,
                      decoration: const InputDecoration(
                        labelText: "Género",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _sinopsisCtrl,
                      decoration: const InputDecoration(
                        labelText: "Sinopsis",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _imgCtrl,
                      decoration: const InputDecoration(
                        labelText: "URL de la Imagen Portada",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // BOTÓN PRINCIPAL ACCIÓN
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: _editando
                            ? const Color.fromARGB(255, 199, 132, 44)
                            : Colors.green[700],
                      ),
                      icon: Icon(_editando ? Icons.edit_note : Icons.add),
                      label: Text(
                        _editando
                            ? "Actualizar en Catálogo"
                            : "Guardar en Catálogo",
                      ),
                      onPressed: () async {
                        if (_tituloCtrl.text.isEmpty ||
                            _sinopsisCtrl.text.isEmpty)
                          return;

                        var datosMapa = {
                          'titulo': _tituloCtrl.text.trim(),
                          'anio': _anioCtrl.text.trim(),
                          'director': _directorCtrl.text.trim(),
                          'genero': _generoCtrl.text.trim(),
                          'sinopsis': _sinopsisCtrl.text.trim(),
                          'imagen_url': _imgCtrl.text.trim(),
                        };

                        if (_editando && _idSeleccionado != null) {
                          // ACCIÓN ACTUALIZAR (UPDATE) EN FIRESTORE
                          await FirebaseFirestore.instance
                              .collection('peliculas')
                              .doc(_idSeleccionado)
                              .update(datosMapa);

                          if (context.mounted)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Película actualizada con éxito'),
                              ),
                            );
                        } else {
                          // ACCIÓN GUARDAR (NUEVO REGISTRO) EN FIRESTORE
                          await FirebaseFirestore.instance
                              .collection('peliculas')
                              .add(datosMapa);

                          if (context.mounted)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Película añadida con éxito'),
                              ),
                            );
                        }

                        _limpiarFormulario();
                      },
                    ),

                    // BOTÓN CANCELAR
                    if (_editando) ...[
                      const SizedBox(height: 10),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color.fromARGB(
                            255,
                            173,
                            25,
                            15,
                          ),
                        ),
                        icon: const Icon(Icons.cancel),
                        label: const Text("Cancelar Edición"),
                        onPressed: _limpiarFormulario,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),

          // VISTA DE SELECCIÓN Y ELIMINACIÓN
          Expanded(
            flex: 5,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('peliculas')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item = docs[index];
                    return ListTile(
                      title: Text(item['titulo'] ?? 'Sin título'),
                      subtitle: Text(
                        "Director: ${item['director'] ?? 'Sin director'}",
                      ),

                      onTap: () {
                        setState(() {
                          _idSeleccionado = item.id;
                          _editando = true;

                          _tituloCtrl.text = item['titulo'] ?? '';
                          _anioCtrl.text = item['anio'] ?? '';
                          _directorCtrl.text = item['director'] ?? '';
                          _generoCtrl.text = item['genero'] ?? '';
                          _sinopsisCtrl.text = item['sinopsis'] ?? '';
                          _imgCtrl.text = item['imagen_url'] ?? '';
                        });
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('peliculas')
                              .doc(item.id)
                              .delete();

                          if (_idSeleccionado == item.id) _limpiarFormulario();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
