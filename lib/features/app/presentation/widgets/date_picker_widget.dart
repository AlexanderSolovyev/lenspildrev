import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/presentation/bloc/order_calendar_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickerWidget extends StatefulWidget {
  final ValueChanged<DateTime>? eventDate;

  DatePickerWidget({Key? key, this.eventDate}) : super(key: key);
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget>
    with TickerProviderStateMixin {
  late DateTime selectedDay;
  late DateTime _focusedDay;
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    _focusedDay = selectedDay;
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
      return Scaffold(body: buildTableCalendar(context, ordersForDay, orders));
    });
  }

  TableCalendar buildTableCalendar(BuildContext context, ordersForDay, orders) {
    return TableCalendar(
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      firstDay: DateTime.utc(2019),
      lastDay: DateTime.utc(2030),
      focusedDay: _focusedDay,
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
        //formatButtonShowsNext: false,
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: (date, orders) {
        dispachGetOrdersForDay(date);
        widget.eventDate!(date);
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
