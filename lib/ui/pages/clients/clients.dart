import 'package:flutter/material.dart';
import 'package:s3/model/event.dart';
import 'package:provider/provider.dart';
import 'package:s3/ui/pages/add_event/add_event.dart';
import 'package:s3/ui/pages/view_event/view_event.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  Map<DateTime, List<dynamic>> _events;

  @override
  void initState() {
    super.initState();
    _events = {};
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = Provider.of<List<EventModel>>(context);
    return Builder(
        //stream: eventDBS.streamList(),
        builder: (context) {
      if (snapshot != null) {
        List<EventModel> allEvents = snapshot;
        if (allEvents.isNotEmpty) {
        } else {
          _events = {};
        }
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            ...snapshot.map(
              (event) => Card(
                child: ListTile(
                  leading: Icon(
                    event.status == StatusValues.uncorfimed
                        ? Icons.clear
                        : event.status == StatusValues.call
                            ? Icons.call
                            : event.status == StatusValues.look
                                ? Icons.camera_alt
                                : event.status == StatusValues.work
                                    ? Icons.nature_people
                                    : Icons.done,
                    color: event.status == StatusValues.uncorfimed
                        ? Colors.grey
                        : event.status == StatusValues.call
                            ? Colors.purple
                            : event.status == StatusValues.look
                                ? Colors.yellow
                                : event.status == StatusValues.work
                                    ? Colors.green
                                    : Colors.blue,
                    size: 40.0,
                  ),
                  title: Text(event.title),
                  subtitle: Text(event.description),
                  onLongPress: () {
                    print(event.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEventPage(note: event),
                      ),
                    );
                  },
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EventDetailsPage(
                                  event: event,
                                )));
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
