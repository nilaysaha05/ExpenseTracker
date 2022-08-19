import 'package:flutter/material.dart';

SnackBar deleteInfoSnackBar = SnackBar(
  backgroundColor: Colors.grey,
  duration: const Duration(
    seconds: 2,
  ),
  content: Row(
    children: const  [
      Icon(
        Icons.info_outline,
      ),
      SizedBox(
        width: 6.0,
      ),
      Text(
        "Long Press to delete",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black
        ),
      ),
    ],
  ),
);