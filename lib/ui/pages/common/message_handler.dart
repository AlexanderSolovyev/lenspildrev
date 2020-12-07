import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:s3/res/event_firestore_service.dart';
import 'package:s3/ui/pages/view_event/view_event.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _getToken();
    _fcm.subscribeToTopic('note');

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      final snackbar =
          SnackBar(content: Text(message['notification']['title']));
      Scaffold.of(context).showSnackBar(snackbar);
    }, onResume: (Map<String, dynamic> message) async {
      final id = message["data"]["id"];
      final event = await eventDBS.getSingle(id);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EventDetailsPage(
                    eventId: event.id,
                  )));
    }, onLaunch: (Map<String, dynamic> message) async {
      final id = message["data"]["id"];
      final event = await eventDBS.getSingle(id);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EventDetailsPage(
                    eventId: event.id,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _getToken() async {
    String _fcmToken = await _fcm.getToken();
  }
}
