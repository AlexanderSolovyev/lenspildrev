import 'package:flutter/material.dart';
import 'package:s3/model/event.dart';

class StatusIconColorTextSelect {
  Color statusIconColor(StatusValues status) {
    switch (status) {
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

  IconData statusIconType(StatusValues status) {
    switch (status) {
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

  Text statusText(StatusValues status) {
    switch (status) {
      case StatusValues.work:
        return Text('Работаем');
      case StatusValues.uncorfimed:
        return Text('Отменен');
      case StatusValues.call:
        return Text('Звонить');
      case StatusValues.look:
        return Text('Оценка');
      case StatusValues.completed:
        return Text('Завершен');
      default:
        return null;
    }
  }
}
