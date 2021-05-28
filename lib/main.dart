import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s3/features/app/domain/usecases/auth_state_changes.dart';
import 'package:s3/features/app/domain/usecases/get_orders.dart';
import 'package:s3/features/app/domain/usecases/user_sign_out.dart';
import 'package:s3/features/app/presentation/pages/clients.dart';
import 'package:s3/features/app/presentation/pages/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:s3/features/app/presentation/pages/order_calendare.dart';
import 'package:s3/features/app/presentation/pages/order_add.dart';
import 'package:s3/injection_container.dart' as di;
import 'features/app/domain/entities/order.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  //await initializeDateFormatting('ru_RU');
  runApp(MyApp(
    authStateChanges: sl(),
    getOrders: sl(),
  ));
}

class MyApp extends StatelessWidget {
  final AuthStateChanges authStateChanges;
  final GetOrders getOrders;

  const MyApp(
      {Key? key, required this.authStateChanges, required this.getOrders})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthStateChanges>(
            //create: (_) => AuthStateChanges(FirebaseAuth.instance),
            create: (_) => AuthStateChanges(authStateChanges.repository)),
        StreamProvider(
          create: (context) =>
              context.read<AuthStateChanges>().authStateChanges,
          initialData: null,
        ),
        StreamProvider<List<Order?>>(
          create: (_) => getOrders.getOrders,
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
      return TabsController(
        userSignOut: sl(),
      );
    }
    return SignIn();
  }
}

class TabsController extends StatefulWidget {
  final UserSignOut userSignOut;

  TabsController({Key? key, required this.userSignOut}) : super(key: key);
  @override
  _TabsControllerState createState() => _TabsControllerState(userSignOut);
}

class _TabsControllerState extends State<TabsController>
    with TickerProviderStateMixin {
  final UserSignOut userSignOut;
  late TabController controller;

  _TabsControllerState(this.userSignOut);

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
                userSignOut();
              }),
        ],
        bottom: TabBar(controller: controller, tabs: [
          Tab(
            icon: Icon(
              Icons.calendar_today,
            ),
            text: 'Заказы',
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
