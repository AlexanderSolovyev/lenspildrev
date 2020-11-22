import 'package:flutter/material.dart';
import 'package:s3/model/event.dart';
import 'package:provider/provider.dart';
import 'package:s3/ui/pages/common/event_tile.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    final snapshot = Provider.of<List<EventModel>>(context);
    return Builder(builder: (context) {
      return SingleChildScrollView(
        child: Column(
          children: [
            ...snapshot.map((event) => EventTile(event: event)),
          ],
        ),
      );
    });
  }

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
