import 'package:budget_tracker_app/theme/colors.dart';
import 'package:flutter/material.dart';

class IncomeTile extends StatelessWidget {
  const IncomeTile({
    Key? key,
    required this.value,
    required this.note,
  }) : super(key: key);

  final double value;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 22.0,
        vertical: 8.0,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 25.0,
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color:grey.withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 0.8,
            offset: const Offset(1,1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_down_outlined,
                color: Colors.greenAccent[700],
                size: 30.0,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                note,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            "+₹$value",
            style:  TextStyle(
                color: Colors.greenAccent[700],
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
