import 'package:flutter/material.dart';
import 'package:s3/ui/pages/common/message_handler.dart';
import 'package:s3/ui/pages/view_event/view_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:s3/model/event.dart';
import 'package:s3/ui/pages/add_event/add_event.dart';
import 'package:provider/provider.dart';

class EventCalendarePage extends StatefulWidget {
  @override
  _EventCalendarePageState createState() => _EventCalendarePageState();
}

class _EventCalendarePageState extends State<EventCalendarePage>
    with TickerProviderStateMixin {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  var _selectedDay;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
    _selectedDay = DateTime.now();
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  List<dynamic> _selectEvents(List<EventModel> allEvents) {
    List<dynamic> data = [];
    allEvents.forEach((event) {
      if (data == null) data = [];
      if (event.eventDate.year == _selectedDay.year &&
          event.eventDate.month == _selectedDay.month &&
          event.eventDate.day == _selectedDay.day) data.add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = Provider.of<List<EventModel>>(context);
    return Builder(builder: (context) {
      if (snapshot != null) {
        List<EventModel> allEvents = snapshot;
        if (allEvents.isNotEmpty) {
          _events = _groupEvents(allEvents);
          _selectedEvents = _selectEvents(allEvents);
        } else {
          _events = {};
          _selectedEvents = [];
        }
      }
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MessageHandler(),
            TableCalendar(
              availableCalendarFormats: const {
                CalendarFormat.month: 'месяц',
                CalendarFormat.twoWeeks: '2 недели',
                CalendarFormat.week: 'неделя'
              },
              locale: 'ru_RU',
              events: _events,
              initialCalendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(
                  markersColor: ThemeData.dark().textSelectionColor,
                  canEventMarkersOverflow: true,
                  todayColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
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
                  _selectedEvents = events;
                  _selectedDay = date;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _controller,
            ),
            ..._selectedEvents.map(
              (event) => Card(
                child: ListTile(
                  leading: Icon(
                    statusIconType(event),
                    color: statusIconColor(event),
                    size: 40.0,
                  ),
                  title: Text(event.title),
                  subtitle: Text(event.description),
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEventPage(note: event),
                      ),
                    );
                  },
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EventDetailsPage(
                                  event: event,
                                )));
                  },
                ),
              ),
            ),
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

  Color statusIconColor(EventModel event) {
    switch (event.status) {
      case StatusValues.work:
        return Colors.green;
      case StatusValues.uncorfimed:
        return Colors.grey;
      case StatusValues.call:
        return Colors.purple;
      case StatusValues.look:
        return Colors.yellow;
      case StatusValues.completed:
        return Colors.blue;
      default:
        return null;
    }
  }

  IconData statusIconType(EventModel event) {
    switch (event.status) {
      case StatusValues.work:
        return Icons.nature_people;
      case StatusValues.uncorfimed:
        return Icons.clear;
      case StatusValues.call:
        return Icons.call;
      case StatusValues.look:
        return Icons.camera_alt;
      case StatusValues.completed:
        return Icons.done;
      default:
        return null;
    }
  }
}
