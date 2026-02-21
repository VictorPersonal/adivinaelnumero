import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late int _numeroSecreto;
  late int _maxNumero;
  late int _maxIntentos;

  int _intentosRestantes = 0;
  int _intentosUsados = 0;
  int? _record;

  bool _modoDificil = false;
  bool _juegoTerminado = false;

  String _mensaje = '';
  final TextEditingController _controller = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _animacion;

  @override
  void initState() {
    super.initState();
    _cargarRecord();

    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animacion = Tween<double>(begin: 1, end: 1.4).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _configurarModo();
  }

  void _configurarModo() {
    if (_modoDificil) {
      _maxNumero = 200;
      _maxIntentos = 4;
    } else {
      _maxNumero = 50;
      _maxIntentos = 7;
    }
    _iniciarJuego();
  }

  Future<void> _cargarRecord() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _record = prefs.getInt('record');
    });
  }

  Future<void> _guardarRecord(int intentos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('record', intentos);
    _cargarRecord();
  }

  void _iniciarJuego() {
    setState(() {
      _numeroSecreto = Random().nextInt(_maxNumero) + 1;
      _intentosRestantes = _maxIntentos;
      _intentosUsados = 0;
      _juegoTerminado = false;
      _mensaje = "🎯 Adivina entre 1 y $_maxNumero";
      _controller.clear();
    });
  }

  void _verificar() {
    if (_juegoTerminado) return;

    final numero = int.tryParse(_controller.text);
    if (numero == null) return;

    setState(() {
      _intentosRestantes--;
      _intentosUsados++;
      _controller.clear();

      if (numero == _numeroSecreto) {
        _mensaje = "🏆 ¡Correcto!";
        _juegoTerminado = true;
        _animController.forward(from: 0);

        if (_record == null || _intentosUsados < _record!) {
          _guardarRecord(_intentosUsados);
        }
      } else if (_intentosRestantes == 0) {
        _mensaje = "💥 Era $_numeroSecreto";
        _juegoTerminado = true;
      } else if (numero < _numeroSecreto) {
        _mensaje = "📈 Muy bajo";
      } else {
        _mensaje = "📉 Muy alto";
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progreso = _intentosRestantes / _maxIntentos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎯 Juego Nivel 3"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔥 Switch de dificultad
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Fácil"),
                Switch(
                  value: _modoDificil,
                  onChanged: (value) {
                    setState(() {
                      _modoDificil = value;
                      _configurarModo();
                    });
                  },
                ),
                const Text("Difícil"),
              ],
            ),

            const SizedBox(height: 10),

            Text("🏅 Récord: ${_record ?? '-'} intentos"),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: progreso,
              color: progreso > 0.5
                  ? Colors.green
                  : progreso > 0.25
                      ? Colors.orange
                      : Colors.red,
              minHeight: 10,
            ),

            const SizedBox(height: 20),

            // 🔥 AnimatedContainer
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _mensaje,
                style: TextStyle(
                  fontSize: _juegoTerminado ? 26 : 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Icono animado
            ScaleTransition(
              scale: _animacion,
              child: Icon(
                Icons.emoji_events,
                size: 60,
                color: _juegoTerminado ? Colors.amber : Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              enabled: !_juegoTerminado,
              decoration: const InputDecoration(
                hintText: "Ingresa tu número",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _juegoTerminado ? null : _verificar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text("Intentar"),
            ),

            const SizedBox(height: 10),

            if (_juegoTerminado)
              OutlinedButton(
                onPressed: _iniciarJuego,
                child: const Text("🔄 Nuevo Juego"),
              ),
          ],
        ),
      ),
    );
  }
}