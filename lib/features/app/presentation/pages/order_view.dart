import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/presentation/widgets/status_icon_color_select.dart';
import 'package:s3/features/app/presentation/widgets/status_selector.dart';

class EventDetailsPage extends StatelessWidget with StatusIconColorTextSelect {
  final String? eventId;
  const EventDetailsPage({Key? key, this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final events = Provider.of<List<Order?>>(context);
    final event = events.firstWhere((element) => element!.id == eventId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Детали заказа'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            clientCard(context, event!),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.navigation,
                      color: Colors.yellow,
                    ),
                    title: Text(
                      event.title!,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.nature,
                      color: Colors.green,
                    ),
                    title: Text(
                      event.description!,
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
                              child: Text(formatter.format(event.eventDate!)),
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
            StatusSelector(event: event)
          ],
        ),
      ),
    );
  }

  Widget clientCard(BuildContext context, Order event) {
    return Card(
      child: ListTile(
        leading: Icon(
          statusIconType(event.status!),
          color: statusIconColor(event.status!),
          size: 40.0,
        ),
        title: Text(event.name!),
        subtitle: Text(event.phone!),
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
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    return res;
  }
}
