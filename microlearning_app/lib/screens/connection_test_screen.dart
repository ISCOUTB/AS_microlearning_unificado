import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Connection Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ConnectionTestScreen(),
    );
  }
}

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  String _status = '❓ No probado aún';
  bool _isLoading = false;
  List<String> _results = [];

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _results.clear();
      _status = '🔄 Probando conexión...';
    });

    try {
      // Test 1: Verificar que el servidor esté activo
      final response = await http
          .get(Uri.parse('http://localhost:8000/'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          _results.add('✅ Servidor Backend: Conectado');
        });
      }

      // Test 2: Obtener usuarios
      final usersResponse = await http
          .get(Uri.parse('http://localhost:8000/usuarios'))
          .timeout(const Duration(seconds: 5));

      if (usersResponse.statusCode == 200) {
        final users = jsonDecode(usersResponse.body);
        setState(() {
          _results.add('✅ Endpoint /usuarios: OK');
          _results.add('   Total de usuarios: ${users.length}');
        });
      }

      // Test 3: Obtener videos
      final videosResponse = await http
          .get(Uri.parse('http://localhost:8000/videos'))
          .timeout(const Duration(seconds: 5));

      if (videosResponse.statusCode == 200) {
        setState(() {
          _results.add('✅ Endpoint /videos: OK');
        });
      }

      // Test 4: Obtener conjuntos
      final conjuntosResponse = await http
          .get(Uri.parse('http://localhost:8000/conjuntos'))
          .timeout(const Duration(seconds: 5));

      if (conjuntosResponse.statusCode == 200) {
        final conjuntos = jsonDecode(conjuntosResponse.body);
        setState(() {
          _results.add('✅ Endpoint /conjuntos: OK');
          _results.add('   Total de conjuntos: ${conjuntos.length}');
        });
      }

      setState(() {
        _status = '✅ ¡Conexión Exitosa!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _results.add('❌ Error: $e');
        _status = '❌ Error de Conexión';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Conexión API'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status indicator
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _status.contains('✅')
                      ? Colors.green.shade100
                      : _status.contains('❌')
                          ? Colors.red.shade100
                          : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _status.contains('✅')
                        ? Colors.green
                        : _status.contains('❌')
                            ? Colors.red
                            : Colors.blue,
                  ),
                ),
                child: Text(
                  _status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _status.contains('✅')
                        ? Colors.green
                        : _status.contains('❌')
                            ? Colors.red
                            : Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // Test button
              ElevatedButton(
                onPressed: _isLoading ? null : _testConnection,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Probar Conexión',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 30),

              // Results
              if (_results.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resultados:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._results.map((result) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            result,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Courier',
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Text(
                  '📝 Asegúrate de que:\n'
                  '1. El servidor FastAPI esté corriendo en localhost:8000\n'
                  '2. La BD esté sincronizada\n'
                  '3. Haya usuarios registrados para pruebas',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
