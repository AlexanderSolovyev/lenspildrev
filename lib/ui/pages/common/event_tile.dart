import 'package:flutter/material.dart';
import 'package:s3/model/event.dart';
import 'package:s3/ui/pages/add_event/add_event.dart';
import 'package:s3/ui/pages/view_event/view_event.dart';
import 'package:s3/ui/pages/common/status_icon_color_select.dart';

class EventTile extends StatelessWidget with StatusIconColorTextSelect {
  final EventModel? event;

  const EventTile({Key? key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          statusIconType(event!.status!),
          color: statusIconColor(event!.status!),
          size: 40.0,
        ),
        title: Text(event!.title!),
        subtitle: Text(event!.description!),
        onLongPress: () {
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
                        eventId: event!.id!,
                      )));
        },
      ),
    );
  }
}
