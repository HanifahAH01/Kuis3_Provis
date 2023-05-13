import 'package:flutter/material.dart';
import 'second_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Route',
      routes: {
        '/': (context) => const MyHome(),
        '/layar2': (context) => const LayarKedua()
      },
    );
  }
}

//perlu  dipisah karena Navigator perlu punya parent Material App
class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Route'),
      ),
      body: Center(
          child: ElevatedButton(
              child: const Text('Ke screen Kedua'),
              onPressed: () {
                Navigator.of(context).pushNamed("/layar2");
              })),
    );
  }
}
