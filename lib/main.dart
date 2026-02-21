import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina el Número',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal, // 🔥 CAMBIO DE COLOR
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late int _numeroSecreto;
  int _intentos = 0;
  int _intentosRestantes = 3; // 🔥 AHORA SOLO 3 INTENTOS
  String _mensaje = '';
  final TextEditingController _controller = TextEditingController();
  bool _juegoTerminado = false;
  bool _juegoPerdido = false;

  final List<String> _mensajesIniciales = [
    '🚀 ¡Vamos genio! Solo tienes 3 oportunidades',
    '🔥 ¿Serás capaz de vencer al juego?',
    '🎲 El destino está en tus manos (3 intentos)',
    '😎 Demuestra tu poder mental en 3 intentos',
  ];

  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  void _iniciarJuego() {
    setState(() {
      _numeroSecreto = Random().nextInt(100) + 1;
      _intentos = 0;
      _intentosRestantes = 3; // 🔥 reinicia en 3
      _mensaje = _mensajesIniciales[Random().nextInt(_mensajesIniciales.length)];
      _juegoTerminado = false;
      _juegoPerdido = false;
      _controller.clear();
    });
  }

  void _verificarAdivinanza() {
    if (_juegoTerminado || _juegoPerdido) return;

    final texto = _controller.text.trim();
    if (texto.isEmpty) {
      _mostrarMensajeTemporal('🤔 Escribe un número primero', Colors.orange);
      return;
    }

    final int? adivinanza = int.tryParse(texto);
    if (adivinanza == null || adivinanza < 1 || adivinanza > 100) {
      _mostrarMensajeTemporal('🚫 Solo números entre 1 y 100', Colors.orange);
      return;
    }

    setState(() {
      _intentos++;
      _intentosRestantes--;
      _controller.clear();

      if (adivinanza == _numeroSecreto) {
        _mensaje =
            '🏆 ¡Eres increíble! 🏆\nLo lograste en $_intentos intento(s)';
        _juegoTerminado = true;
      } else if (_intentosRestantes == 0) {
        _mensaje =
            '💥 ¡Se acabó! 💥\nEl número era $_numeroSecreto';
        _juegoPerdido = true;
      } else if (adivinanza < _numeroSecreto) {
        _mensaje =
            '📈 ¡Sube más! Te quedan $_intentosRestantes oportunidades';
      } else {
        _mensaje =
            '📉 ¡Baja un poco! Te quedan $_intentosRestantes oportunidades';
      }
    });
  }

  void _mostrarMensajeTemporal(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
      ),
    );
  }

  Color _getMensajeColor() {
    if (_juegoTerminado) return Colors.green;
    if (_juegoPerdido) return Colors.red;
    if (_mensaje.contains('Sube')) return Colors.blue;
    if (_mensaje.contains('Baja')) return Colors.red;
    return Colors.teal; // 🔥 cambio a teal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎯 Juego Mental"),
        backgroundColor: Colors.teal, // 🔥 AppBar teal
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade50,
              Colors.white,
              Colors.teal.shade50,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _mensaje,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _getMensajeColor(),
                  ),
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  enabled: !_juegoTerminado && !_juegoPerdido,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu número',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _verificarAdivinanza(),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed:
                      (_juegoTerminado || _juegoPerdido) ? null : _verificarAdivinanza,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // 🔥 botón teal
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "🎯 Intentar",
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 15),

                if (_juegoTerminado || _juegoPerdido)
                  OutlinedButton(
                    onPressed: _iniciarJuego,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.teal,
                    ),
                    child: const Text("🔄 Jugar de nuevo"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}