import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/presentation/bloc/order_calendar_bloc.dart';
import 'package:s3/features/app/presentation/widgets/event_tile.dart';
import 'package:s3/features/app/presentation/widgets/message_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:s3/features/app/presentation/pages/order_add.dart';

class OrderCalendarePage extends StatefulWidget {
  @override
  _OrderCalendarePageState createState() => _OrderCalendarePageState();
}

class _OrderCalendarePageState extends State<OrderCalendarePage>
    with TickerProviderStateMixin {
  DateTime selectedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.twoWeeks;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCalendarBloc, OrderCalendarState>(
        builder: (context, state) {
      var ordersForDay = [];
      var orders = [];
      if (state is OrdersLoading) {
        return CircularProgressIndicator();
      } else if (state is OrdersLoaded) {
        ordersForDay = state.ordersForDay;
        orders = state.orders;
        dispachGetOrdersForDay(selectedDay);
      }
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MessageHandler(),
            buildTableCalendar(context, ordersForDay, orders),
            ...ordersForDay.map((order) => EventTile(event: order)),
            Align(
              alignment: Alignment.topRight,
              child: FlatButton(
                textColor: ThemeData.dark().textSelectionColor,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEventPage(
                      selectedDay: selectedDay,
                      newOrder: true,
                    ),
                  ),
                ),
                child: Text('ДОБАВИТЬ ЗАКАЗ'),
              ),
            ),
          ],
        ),
      );
    });
  }

  TableCalendar buildTableCalendar(BuildContext context, ordersForDay, orders) {
    return TableCalendar(
      firstDay: DateTime.utc(2019),
      lastDay: DateTime.utc(2030),
      focusedDay: selectedDay,
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'месяц',
        CalendarFormat.twoWeeks: '2 недели'
      },
      locale: 'ru_RU',
      eventLoader: (day) => getOrdersForBuilder(day, orders),
      calendarFormat: calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          calendarFormat = format;
        });
      },
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: ThemeData.dark().textSelectionColor,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonDecoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        formatButtonTextStyle: TextStyle(color: Colors.white),
        formatButtonShowsNext: false,
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: (date, orders) {
        dispachGetOrdersForDay(date);
        setState(() {
          selectedDay = date;
        });
      },
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, orders) => Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            )),
        todayBuilder: (context, date, orders) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            date.day.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void dispachGetOrdersForDay(DateTime day) {
    BlocProvider.of<OrderCalendarBloc>(context).add(GetOrdersForDay(day));
  }

  List<Order?> getOrdersForBuilder(DateTime day, List<Order?> orders) {
    final List<Order?> ordersForDay = orders
        .where((order) => (order!.eventDate!.year == day.year &&
            order.eventDate!.month == day.month &&
            order.eventDate!.day == day.day))
        .toList();
    return ordersForDay;
  }
}
