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
        primarySwatch: Colors.teal,
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

class _MyHomePageState extends State<MyHomePage> {
  late int _numeroSecreto;
  int _intentosRestantes = 3;
  final int _maxIntentos = 3;
  String _mensaje = '';
  final TextEditingController _controller = TextEditingController();
  bool _juegoTerminado = false;
  bool _juegoPerdido = false;

  List<int> _historialIntentos = [];

  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  void _iniciarJuego() {
    setState(() {
      _numeroSecreto = Random().nextInt(100) + 1;
      _intentosRestantes = _maxIntentos;
      _mensaje = '🎯 ¡Adivina el número del 1 al 100!';
      _juegoTerminado = false;
      _juegoPerdido = false;
      _historialIntentos.clear();
      _controller.clear();
    });
  }

  void _usarPista() {
    if (_juegoTerminado || _juegoPerdido) return;

    setState(() {
      _intentosRestantes--;

      if (_intentosRestantes <= 0) {
        _mensaje = '💥 Te quedaste sin intentos.\nEra $_numeroSecreto';
        _juegoPerdido = true;
      } else {
        if (_numeroSecreto % 2 == 0) {
          _mensaje =
              '🔎 Pista: El número es PAR.\nTe quedan $_intentosRestantes intentos';
        } else {
          _mensaje =
              '🔎 Pista: El número es IMPAR.\nTe quedan $_intentosRestantes intentos';
        }
      }
    });
  }

  void _verificarAdivinanza() {
    if (_juegoTerminado || _juegoPerdido) return;

    final int? adivinanza = int.tryParse(_controller.text);
    if (adivinanza == null) return;

    setState(() {
      _historialIntentos.add(adivinanza);
      _intentosRestantes--;
      _controller.clear();

      if (adivinanza == _numeroSecreto) {
        _mensaje = '🏆 ¡Correcto!';
        _juegoTerminado = true;
      } else if (_intentosRestantes == 0) {
        _mensaje = '💥 Perdiste. Era $_numeroSecreto';
        _juegoPerdido = true;
      } else if (adivinanza < _numeroSecreto) {
        _mensaje = '📈 Muy bajo';
      } else {
        _mensaje = '📉 Muy alto';
      }
    });
  }

  Color _colorProgreso() {
    if (_intentosRestantes >= 2) return Colors.green;
    if (_intentosRestantes == 1) return Colors.orange;
    return Colors.red;
  }

  Color _colorIntento(int numero) {
    if (numero == _numeroSecreto) return Colors.green;
    if (numero < _numeroSecreto) return Colors.blue;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    double progreso = _intentosRestantes / _maxIntentos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎯 Juego Mental Pro"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔥 Barra de progreso
            LinearProgressIndicator(
              value: progreso,
              color: _colorProgreso(),
              backgroundColor: Colors.grey.shade300,
              minHeight: 10,
            ),

            const SizedBox(height: 20),

            Text(
              _mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              enabled: !_juegoTerminado && !_juegoPerdido,
              decoration: const InputDecoration(
                hintText: 'Ingresa tu número',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed:
                  (_juegoTerminado || _juegoPerdido) ? null : _verificarAdivinanza,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text("🎯 Intentar"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed:
                  (_juegoTerminado || _juegoPerdido) ? null : _usarPista,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text("🔎 Pista (-1 intento)"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Historial de intentos:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 🔥 Historial
            SizedBox(
              height: 120,
              child: ListView.builder(
                itemCount: _historialIntentos.length,
                itemBuilder: (context, index) {
                  int numero = _historialIntentos[index];
                  return Text(
                    "Intento ${index + 1}: $numero",
                    style: TextStyle(
                      color: _colorIntento(numero),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            if (_juegoTerminado || _juegoPerdido)
              OutlinedButton(
                onPressed: _iniciarJuego,
                child: const Text("🔄 Jugar de nuevo"),
              ),
          ],
        ),
      ),
    );
  }
}