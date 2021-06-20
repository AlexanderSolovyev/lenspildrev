import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/presentation/bloc/order_calendar_bloc.dart';
import 'package:s3/features/app/presentation/widgets/status_icon_color_select.dart';
import 'package:s3/features/app/presentation/widgets/status_selector.dart';

class OrderDetailsPage extends StatelessWidget with StatusIconColorTextSelect {
  final String? eventId;
  const OrderDetailsPage({Key? key, this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    String languageCode = Localizations.localeOf(context).languageCode;

    //final orders = Provider.of<List<Order?>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Детали заказа'),
      ),
      body: BlocBuilder<OrderCalendarBloc, OrderCalendarState>(
          builder: (context, state) {
        final orders = state.orders;
        final order = orders.firstWhere((element) => element!.id == eventId);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              clientCard(context, order!),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.navigation,
                        color: Colors.orange,
                      ),
                      title: Text(
                        order.title!,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.nature,
                        color: Colors.green,
                      ),
                      title: Text(
                        order.description!,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.camera_alt,
                        color: Colors.yellow,
                      ),
                      title: Text(
                        order.estimate ?? '',
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 18.0,
                                    right: 28.0,
                                    top: 8.0,
                                    bottom: 18.0),
                                child: Icon(
                                  Icons.today,
                                  color: Colors.red,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                    DateFormat("d MMMM yyyy", languageCode)
                                        .format(order.eventDate!)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 18.0),
                                child: Icon(
                                  Icons.attach_money,
                                  color: Colors.orange,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(order.price.toString()),
                                //child: Text(order.estimate ?? ''),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              StatusSelector(event: order)
            ],
          ),
        );
      }),
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
    var number = phone;
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    return res;
  }
}
