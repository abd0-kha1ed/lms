import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularState extends StatelessWidget {
  const CircularState({
    super.key,
    required this.count,
    required this.color,
    required this.lable,
    this.onTap,
  });
  final int count;
  final Color color;
  final String lable;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 70,
            lineWidth: 8,
            percent: count / 2500, // Assuming a max value of 10
            center: Text(
              "$count",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            progressColor: color,
            backgroundColor: Colors.grey[300]!,
          ),
          const SizedBox(height: 8),
          Text(
            lable,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
