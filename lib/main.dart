import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s3/model/event.dart';
import 'package:s3/res/auth_service.dart';
import 'package:s3/ui/pages/clients/clients.dart';
import 'package:s3/ui/pages/sign_in/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:s3/ui/pages/event_calendare/event_calendare.dart';
import 'package:s3/ui/pages/add_event/add_event.dart';
import 'package:s3/res/event_firestore_service.dart';

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
          initialData: null,
        ),
        StreamProvider<List<EventModel>>(
          create: (_) => eventDBS.streamList(),
          initialData: [],
        )
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
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return TabsController();
    }
    return SignIn();
  }
}

class TabsController extends StatefulWidget {
  @override
  _TabsControllerState createState() => _TabsControllerState();
}

class _TabsControllerState extends State<TabsController>
    with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ленспидрев.рф'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                context.read<AuthService>().signOut();
              }),
        ],
        bottom: TabBar(controller: controller, tabs: [
          Tab(
            icon: Icon(
              Icons.calendar_today,
            ),
            text: 'Календарь',
          ),
          Tab(
            icon: Icon(Icons.person),
            text: 'Клиенты',
          )
        ]),
      ),
      body: TabBarView(controller: controller, children: <Widget>[
        EventCalendarePage(),
        ClientsPage(),
      ]),
    );
  }
}
