import 'package:flutter/material.dart';

class ApiItemDetail extends StatelessWidget {
  const ApiItemDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ItemDetail',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Poppins',
              color: Colors.white),
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
