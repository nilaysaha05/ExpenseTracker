import 'package:budget_tracker_app/theme/colors.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    Key? key,
    required this.value,
    required this.note,
    required this.date,
    required this.type,
  }) : super(key: key);



  final double value;
  final String note;
  final String type;
  final DateTime date;


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
            color: grey.withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 0.8,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_circle_up_outlined,
                    color: Colors.redAccent[700],
                    size: 30.0,
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    type,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0,left: 5.0),
                child: Text(
                  "${date.day}-${date.month}",
                  style:  TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "-₹$value",
                style: TextStyle(
                    color: Colors.redAccent[700],
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  note,
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
