import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s3/model/event.dart';
import 'package:s3/res/event_firestore_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:s3/ui/pages/common/status_icon_color_select.dart';

class EventDetailsPage extends StatelessWidget with StatusIconColorTextSelect {
  final String eventId;
  const EventDetailsPage({Key key, this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final events = Provider.of<List<EventModel>>(context);
    final event = events.firstWhere((element) => element.id == eventId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Детали заказа'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            clientCard(context, event),
            StatusSelector(event: event),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.navigation,
                      color: Colors.yellow,
                    ),
                    title: Text(
                      event.title,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.nature,
                      color: Colors.green,
                    ),
                    title: Text(
                      event.description,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 18.0,
                                  right: 28.0,
                                  top: 10.0,
                                  bottom: 18.0),
                              child: Icon(
                                Icons.today,
                                color: Colors.red,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(formatter.format(event.eventDate)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 18.0,
                                  right: 28.0,
                                  top: 10.0,
                                  bottom: 18.0),
                              child: Icon(
                                Icons.attach_money,
                                color: Colors.orange,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(event.price.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clientCard(BuildContext context, EventModel event) {
    return Card(
      child: ListTile(
        leading: Icon(
          statusIconType(event.status),
          color: statusIconColor(event.status),
          size: 40.0,
        ),
        title: Text(event.name),
        subtitle: Text(event.phone),
        trailing: Icon(
          Icons.call,
          color: Colors.greenAccent,
        ),
        onTap: () => _callNumber(event.phone),
      ),
    );
  }

  _callNumber(phone) async {
    var number = phone; //set the number here
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
    return res;
  }
}

//enum StatusValues { uncorfimed, call, look, work, completed }

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
