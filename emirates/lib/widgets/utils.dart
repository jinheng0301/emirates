import 'package:emirates/screens/booking_screen.dart';
import 'package:emirates/screens/home_screen.dart';
import 'package:emirates/screens/skywards_screen.dart';
import 'package:emirates/screens/trips_screen.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

final screens = [
  HomeScreen(),
  BookingScreen(),
  TripsScreen(),
  SkywardsScreen(),
];
