import 'package:flutter/material.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/presentation/widgets/event_tile.dart';
import 'package:s3/features/app/presentation/widgets/message_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:s3/features/app/presentation/pages/order_add.dart';
import 'package:provider/provider.dart';

class EventCalendarePage extends StatefulWidget {
  @override
  _EventCalendarePageState createState() => _EventCalendarePageState();
}

class _EventCalendarePageState extends State<EventCalendarePage>
    with TickerProviderStateMixin {
  var _events = [];
  List<Order?>? _selectedEvents;
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  //final GetUserDetails getUserDetails;

  // _EventCalendarePageState(this.getUserDetails);

  @override
  void initState() {
    super.initState();
    _selectedEvents = [];
    _selectedDay = DateTime.now();
    // _selectedEvents = _events[_selectedDay] ?? [];
  }

  List<Order?> _getEventsForDay(DateTime day) {
    List<Order?> data = [];
    _events.forEach((event) {
      if (event.eventDate.year == day.year &&
          event.eventDate.month == day.month &&
          event.eventDate.day == day.day) data.add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    //final firebaseUser = context.watch<User?>();
    //final Future<UserDetails> userDetails = getUserDetails(firebaseUser!.uid);
    final snapshot = Provider.of<List<Order?>>(context);
    return Builder(builder: (context) {
      List<Order?> allEvents = snapshot;
      if (allEvents.isNotEmpty) {
        _events = allEvents;
      }
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MessageHandler(),
            TableCalendar(
              firstDay: DateTime.utc(2019),
              lastDay: DateTime.utc(2030),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              availableCalendarFormats: const {
                CalendarFormat.month: 'месяц',
                CalendarFormat.twoWeeks: '2 недели'
              },
              locale: 'ru_RU',
              eventLoader: (day) => _getEventsForDay(day),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
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
              onDaySelected: (date, events) {
                setState(() {
                  _selectedDay = date;
                  _selectedEvents = _getEventsForDay(date);
                });
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayBuilder: (context, date, events) => Container(
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
            ),
            ..._selectedEvents!.map((event) => EventTile(event: event)),
            Align(
              alignment: Alignment.topRight,
              child: FlatButton(
                textColor: ThemeData.dark().textSelectionColor,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEventPage(selectedDay: _selectedDay),
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
}