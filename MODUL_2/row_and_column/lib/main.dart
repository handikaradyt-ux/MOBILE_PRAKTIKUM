import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Row and Column',
      home: Scaffold(
        appBar: AppBar(title: Text('Row and Column')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KotakBiru(Colors.blue[200]!, "kotak 1"), 
                  SizedBox(width: 20), KotakBiru(Colors.green[200]!, "kotak 2")
                  ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KotakBiru(Colors.yellow[200]!, "kotak 3"), 
                  SizedBox(width: 20), KotakBiru(Colors.brown[200]!, "kotak 4")
                  ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KotakBiru extends StatelessWidget {
  final Color warna;
  final String teks;

  KotakBiru(this.warna, this.teks);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: warna,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, color: Colors.red, size: 40),
          SizedBox(height: 8),
          Text(
            teks,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
