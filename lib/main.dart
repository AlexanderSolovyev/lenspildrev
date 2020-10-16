import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s3/res/auth_service.dart';
import 'package:s3/res/event_firestore_service.dart';
import 'package:s3/ui/pages/add_event.dart';
import 'package:s3/ui/pages/sign_in.dart';
import 'package:s3/ui/pages/view_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'model/event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await initializeDateFormatting('ru_RU');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale('ru')],
        title: 'ленспидрев.рф',
        theme: ThemeData.dark(
            //primarySwatch: Colors.orange,
            ),
        home: AuthWrapper(),
        routes: {
          "add_event": (_) => AddEventPage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomePage();
    }
    return SignIn();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Row(
              children: [
                Container(
                  height: 60.0,
                ),
              ],
            )),
          ],
        ),
        shape: CircularNotchedRectangle(),
      ),
      appBar: AppBar(
        title: Text('ленспидрев.рф'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                context.read<AuthService>().signOut();
              }),
        ],
      ),
      body: StreamBuilder<List<EventModel>>(
          stream: eventDBS.streamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventModel> allEvents = snapshot.data;
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
                  )
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'add_event'),
      ),
    );
  }
}
