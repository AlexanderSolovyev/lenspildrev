import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:s3/features/app/presentation/pages/order_view.dart';
import 'package:s3/features/app/domain/usecases/get_order_by_id.dart';

import '../../../../injection_container.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState(sl());
}

class _MessageHandlerState extends State<MessageHandler> {
  //final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final GetOrderById getOrderById;

  _MessageHandlerState(this.getOrderById);
  @override
  void initState() {
    super.initState();
    //_getToken();
    FirebaseMessaging.instance.subscribeToTopic('note');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('message=' + message.data.toString());
      final snackbar =
          SnackBar(content: Text(message.notification!.title.toString()));
      Scaffold.of(context).showSnackBar(snackbar);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final id = message.data["data"]["id"];
      //final event = await eventDBS.getSingle(id);
      final event = await getOrderById(id);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => OrderDetailsPage(
                    eventId: event!.id!,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  /*  void _getToken() async {
    String? _fcmToken = await _fcm.getToken();
  } */
}
