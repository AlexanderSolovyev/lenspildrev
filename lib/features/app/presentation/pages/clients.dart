import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3/features/app/presentation/bloc/order_calendar_bloc.dart';
import 'package:s3/features/app/presentation/widgets/event_tile.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    var orders = [];
    return BlocBuilder<OrderCalendarBloc, OrderCalendarState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return CircularProgressIndicator();
        } else if (state is OrdersLoaded) {
          orders = state.orders;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              ...orders.map((event) => EventTile(event: event)),
            ],
          ),
        );
      },
    );
  }
}
