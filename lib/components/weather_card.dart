import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget(this.city, this.temperature, this.localtime, {super.key});
  final String city;
  final double temperature;
  final String localtime;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 2.0, color: const Color.fromARGB(255, 13, 41, 125)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city,
              style: const TextStyle(fontSize: 32, fontFamily: 'Carlito'),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${temperature.toString()} °C',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Carlito'),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              localtime,
              style: const TextStyle(fontSize: 20, fontFamily: 'Carlito'),
            ),
          ],
        ),
      ),
    );
  }
}
