import 'package:flutter/material.dart';

class DestinationsCard extends StatelessWidget {
  late final String country;
  late final String city;
  late final String image;
  late final int price;

  DestinationsCard({
    required this.country,
    required this.city,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image, width: double.infinity, height: height * .7),
            Text(country, style: TextStyle(fontSize: 20)),
            Text(city, style: TextStyle(fontSize: 25)),
            Text('Price: MYR$price', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
