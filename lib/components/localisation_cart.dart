import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget(this.city, this.temperature, this.localtime, this.text,
      {super.key});

  final String city;
  final double temperature;
  final String localtime;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${temperature.toString()} °C',
            style: const TextStyle(
              fontSize: 36,
              fontFamily: 'Carlito',
            ),
          ),
          Text(
            'City; $city',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontFamily: 'Carlito',
            ),
          ),
          Text(
            'Today is:\n $localtime',
          ),
          Text(
            '$text',
          ),
        ],
      ),
    );
  }
}
