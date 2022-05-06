import 'package:flutter/material.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/presentation/pages/order_add.dart';
import 'package:s3/features/app/presentation/pages/order_view.dart';
import 'package:s3/features/app/presentation/widgets/status_icon_color_select.dart';

class EventTile extends StatelessWidget with StatusIconColorTextSelect {
  final Order? event;

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
        subtitle: Text(event!.description! + '\n' + event!.name!),
        isThreeLine: true,
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEventPage(
                note: event,
                newOrder: false,
              ),
            ),
          );
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OrderDetailsPage(
                        eventId: event!.id!,
                      )));
        },
      ),
    );
  }
}
