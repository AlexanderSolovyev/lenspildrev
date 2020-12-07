import 'package:flutter/material.dart';
import 'package:s3/model/event.dart';
import 'package:s3/res/event_firestore_service.dart';
import 'package:s3/ui/pages/common/status_icon_color_select.dart';

class StatusSelector extends StatefulWidget {
  final EventModel event;
  const StatusSelector({Key key, this.event}) : super(key: key);

  @override
  _StatusSelector createState() => _StatusSelector(event: event);
}

class _StatusSelector extends State<StatusSelector>
    with StatusIconColorTextSelect {
  EventModel event;
  _StatusSelector({Key key, this.event}) : super();
  //StatusValues _character = event.status;

  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: StatusValues.values.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: statusText(StatusValues.values[index]),
                    leading: Radio(
                      activeColor: statusIconColor(StatusValues.values[index]),
                      value: StatusValues.values[index],
                      groupValue: event.status,
                      onChanged: (StatusValues value) {
                        setState(() {
                          event.status = value;
                          eventDBS.updateData(widget.event.id, {
                            "status": event.status.toString().split('.')[1]
                          });
                        });
                      },
                    ));
              }),
        ],
      ),
    );
  }
}
