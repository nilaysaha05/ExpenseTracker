import 'package:flutter/material.dart';

const Color offWhite = Color(0xffede9f0);
const Color peach = Color(0xffF6B1A2);
const Color deepPurple = Colors.deepPurpleAccent;
const Color purpleAccent = Colors.purpleAccent;
const Color grey = Color(0xff9CADBF);
const Color purple = Color(0xffA84D92);
const Color blue = Color(0xff3946d6);
const Color blue1 = Color(0xff38A4E4);

final List<Color> gradientColors = [
  peach,
  purpleAccent,
  deepPurple,
  blue,
  blue1,
];

final List<BoxShadow> boxShadow1 = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.4),
    blurRadius: 6,
    spreadRadius: 0.5,
    offset: const Offset(0, 0),
  ),
];
