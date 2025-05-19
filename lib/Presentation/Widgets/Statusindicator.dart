import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget StatusIndicator(String status) {
  Color color;
  String text;
  switch (status) {
    case 'Completed':
      color = Colors.green;
      text = 'Completed';
      break;
    case 'Scheduled':
      color = Colors.blue;
      text = 'Scheduled';
      break;
    case 'Pending':
      color = Colors.yellow;
      text = 'Pending';
      break;
    case 'Cancelled':
      color = Colors.red;
      text = 'Cancelled';
      break;
    default:
      color = Colors.grey;
      text = 'Unknown';
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: color,
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}