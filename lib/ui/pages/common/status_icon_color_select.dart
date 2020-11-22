import 'package:flutter/material.dart';
import 'package:s3/model/event.dart';

class StatusIconColorSelect {
  Color statusIconColor(EventModel event) {
    switch (event.status) {
      case StatusValues.work:
        return Colors.green;
      case StatusValues.uncorfimed:
        return Colors.grey;
      case StatusValues.call:
        return Colors.purple;
      case StatusValues.look:
        return Colors.yellow;
      case StatusValues.completed:
        return Colors.blue;
      default:
        return null;
    }
  }

  IconData statusIconType(EventModel event) {
    switch (event.status) {
      case StatusValues.work:
        return Icons.nature_people;
      case StatusValues.uncorfimed:
        return Icons.clear;
      case StatusValues.call:
        return Icons.call;
      case StatusValues.look:
        return Icons.camera_alt;
      case StatusValues.completed:
        return Icons.done;
      default:
        return null;
    }
  }
}
