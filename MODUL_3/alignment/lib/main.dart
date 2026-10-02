import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alignment',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Alignment'),
        ),

        // HASIL AKHIR PRAKTIKUM LANGKAH 9
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Suhu:',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),

              Text(
                '25°C',
                style: TextStyle(
                  fontSize: 75,
                ),
              ),

              Icon(
                Icons.sunny,
                color: Colors.amber,
                size: 45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ======================================================
// WIDGET KOTAK BIRU JEMPOL
// Digunakan pada langkah praktikum sebelumnya
// ======================================================

class KotakBiruJempol extends StatelessWidget {
  const KotakBiruJempol({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.thumb_up,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}


// ======================================================
// WIDGET KOTAK BIRU JEMPOL KECIL
// Digunakan pada langkah praktikum sebelumnya
// ======================================================

class KotakBiruJempolKecil extends StatelessWidget {
  const KotakBiruJempolKecil({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.thumb_up,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}