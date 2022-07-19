import 'package:budget_tracker_app/theme/colors.dart';
import 'package:flutter/material.dart';


class TrackerCard extends StatelessWidget {
  const TrackerCard({Key? key,required this.value,
    required this.type,
    required this.iconData,
    required this.iconColor,}) : super(key: key);

  final String value;
  final String type;
  final IconData iconData;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            iconData,
            size: 20.0,
            color: iconColor,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: TextStyle(
                color: offWhite.withOpacity(0.8),
                fontSize: 12.0,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              "₹ $value",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: offWhite,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
