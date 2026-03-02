import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Persona {
  final String nombre;
  final String apellido;
  final int edad;

  Persona({required this.nombre, required this.apellido, required this.edad});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _inicioSesion();
}

class _inicioSesion extends State<MyHomePage> {
  final String _usuario = 'admin';
  final String _clave = '12345';

  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio de sesión")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre de usuario',
                    hintText: 'Ingrese su nombre de usuario',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _claveController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                    hintText: 'Ingrese su contraseña',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_usuarioController.text == _usuario &&
                        _claveController.text == _clave) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Inicio de sesión exitoso')),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => _principal()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Usuario o contraseña incorrectos'),
                        ),
                      );
                    }
                  },
                  child: Text('Iniciar sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _principal extends StatefulWidget {
  @override
  State<_principal> createState() => _Pantallaprincipal();
}

class _Pantallaprincipal extends State<_principal> {
  int _pantalla = 0;
  final List<Persona> _registros = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  void agregarPersona() {
    final String nombre = _nombreController.text;
    final String apellido = _apellidoController.text;
    final int edad = int.tryParse(_edadController.text) ?? 0;

    if (nombre.isNotEmpty && apellido.isNotEmpty && edad > 0) {
      setState(() {
        _registros.add(Persona(nombre: nombre, apellido: apellido, edad: edad));
        _nombreController.clear();
        _apellidoController.clear();
        _edadController.clear();
      });
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Registro guardado')));
  }

  void eliminarPersona(int index) {
    setState(() {
      _registros.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Registro eliminado')));
  }

  void _cambiarPantalla(int index) {
    setState(() {
      _pantalla = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pantallasDinamicas = [
      _Registro(
        nombreController: _nombreController,
        apellidoController: _apellidoController,
        edadController: _edadController,
        onGuardar: agregarPersona,
      ),
      _listaRegistros(registros: _registros, onEliminar: eliminarPersona),
      _Buscadorregistros(registros: _registros),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Aplicación de Registros')),
      body: pantallasDinamicas[_pantalla],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(color: Colors.blueAccent),
        selectedItemColor: Colors.blueAccent,
        currentIndex: _pantalla,
        onTap: _cambiarPantalla,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.app_registration),
            label: 'Registros',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.list),
            label: 'Lista de registros',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.search),
            label: 'Buscar en registros',
          ),
        ],
      ),
    );
  }
}

class _Registro extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final TextEditingController edadController;
  final VoidCallback onGuardar;

  const _Registro({
    required this.nombreController,
    required this.apellidoController,
    required this.edadController,
    required this.onGuardar,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre de la persona',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: apellidoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Apellido',
                  hintText: 'Ingrese el apellido de la persona',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: edadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Edad',
                  hintText: 'Ingrese la edad de la persona',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: onGuardar, child: Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}

class _listaRegistros extends StatelessWidget {
  final List<Persona> registros;
  final Function(int) onEliminar;
  const _listaRegistros({required this.registros, required this.onEliminar});

  @override
  Widget build(BuildContext context) {
    if (registros.isEmpty) {
      return Center(child: Text('No hay registros en la lista'));
    }
    return ListView.builder(
      itemCount: registros.length,
      itemBuilder: (context, index) {
        final persona = registros[index];
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          iconColor: Colors.lightBlueAccent,
          leading: Icon(Icons.person),
          title: Text('${persona.nombre} ${persona.apellido}'),
          subtitle: Text('Edad: ${persona.edad} años'),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.blueAccent),
            onPressed: () => onEliminar(index),
          ),
        );
      },
    );
  }
}

class _Buscadorregistros extends StatefulWidget {
  final List<Persona> registros;

  const _Buscadorregistros({required this.registros});

  @override
  State<_Buscadorregistros> createState() => _BuscadorregistrosState();
}

class _BuscadorregistrosState extends State<_Buscadorregistros> {
  final TextEditingController _busquedaController = TextEditingController();
  List<Persona> _resultadosBusqueda = [];

  @override
  void initState() {
    super.initState();
    _resultadosBusqueda = [];
  }

  void _buscar() {
    setState(() {
      final String busqueda = _busquedaController.text.toLowerCase();
      if (busqueda.isEmpty) {
        _resultadosBusqueda = [];
      } else {
        _resultadosBusqueda = widget.registros.where((persona) {
          final nombreCompleto = '${persona.nombre} ${persona.apellido}'
              .toLowerCase();
          return nombreCompleto.contains(busqueda);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _busquedaController,
            decoration: InputDecoration(
              labelText: 'Buscar por nombre o apellido de la persona',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _buscar,
              ),
            ),
            onSubmitted: (_) => _buscar(),
          ),
        ),
        Expanded(
          child: _resultadosBusqueda.isEmpty
              ? Center(
                  child: Text(
                    'No se encontro el registro ${_busquedaController.text}',
                  ),
                )
              : ListView.builder(
                  itemCount: _resultadosBusqueda.length,
                  itemBuilder: (context, index) {
                    final persona = _resultadosBusqueda[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      iconColor: Colors.lightBlueAccent,
                      leading: Icon(Icons.person),
                      title: Text('${persona.nombre} ${persona.apellido}'),
                      subtitle: Text('Edad: ${persona.edad} años'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
