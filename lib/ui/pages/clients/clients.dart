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
}
