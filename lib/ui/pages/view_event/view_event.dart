import 'package:flutter/material.dart';
import 'package:s3/model/event.dart';
import 'package:s3/res/event_firestore_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;
  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('Детали заказа'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
}

//enum StatusValues { uncorfimed, call, look, work, completed }

class StatusSelector extends StatefulWidget {
  final EventModel event;
  const StatusSelector({Key key, this.event}) : super(key: key);

  @override
  _StatusSelector createState() => _StatusSelector(event: event);
}

class _StatusSelector extends State<StatusSelector> {
  EventModel event;
  _StatusSelector({Key key, this.event}) : super();
  //StatusValues _character = event.status;

  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
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
            title: Text(event.name),
            subtitle: Text(event.phone),
            trailing: Icon(
              Icons.call,
              color: Colors.greenAccent,
            ),
            onTap: () => _callNumber(event.phone),
          ),
        ),
        Card(
          child: Container(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Оценка'),
                  leading: Radio(
                      activeColor: Colors.yellow,
                      value: StatusValues.look,
                      groupValue: event.status,
                      onChanged: (StatusValues value) {
                        setState(() {
                          event.status = value;
                          eventDBS.updateData(widget.event.id, {
                            "status": event.status.toString().split('.')[1]
                          });
                        });
                      }),
                ),
                ListTile(
                  title: const Text('Работаем'),
                  leading: Radio(
                      activeColor: Colors.green,
                      value: StatusValues.work,
                      groupValue: event.status,
                      onChanged: (StatusValues value) {
                        setState(() {
                          event.status = value;
                          eventDBS.updateData(widget.event.id, {
                            "status": event.status.toString().split('.')[1]
                          });
                        });
                      }),
                ),
                ListTile(
                  title: const Text('Выполнен'),
                  leading: Radio(
                      activeColor: Colors.blue,
                      value: StatusValues.completed,
                      groupValue: event.status,
                      onChanged: (StatusValues value) {
                        setState(() {
                          event.status = value;
                          eventDBS.updateData(widget.event.id, {
                            "status": event.status.toString().split('.')[1]
                          });
                        });
                      }),
                ),
                ListTile(
                  title: const Text('Звонить'),
                  leading: Radio(
                      activeColor: Colors.purple,
                      value: StatusValues.call,
                      groupValue: event.status,
                      onChanged: (StatusValues value) {
                        setState(() {
                          event.status = value;
                          eventDBS.updateData(widget.event.id, {
                            "status": event.status.toString().split('.')[1]
                          });
                        });
                      }),
                ),
                ListTile(
                  title: const Text('Отменен'),
                  leading: Radio(
                      activeColor: Colors.grey,
                      value: StatusValues.uncorfimed,
                      groupValue: event.status,
                      onChanged: (StatusValues value) {
                        setState(() {
                          event.status = value;
                          eventDBS.updateData(widget.event.id, {
                            "status": event.status.toString().split('.')[1]
                          });
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _callNumber(phone) async {
    var number = phone; //set the number here
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}
