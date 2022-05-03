import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3/features/app/domain/usecases/get_orders.dart';
import 'package:s3/features/app/domain/usecases/order_create.dart';
import 'package:s3/features/app/domain/usecases/order_update.dart';
import 'package:s3/features/app/presentation/bloc/auth_bloc.dart';
import 'package:s3/features/app/presentation/bloc/order_calendar_bloc.dart';
import 'package:s3/features/app/presentation/cubit/clients_cubit.dart';
import 'package:s3/features/app/presentation/pages/clients.dart';
import 'package:s3/features/app/presentation/pages/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:s3/features/app/presentation/pages/order_calendare.dart';
import 'package:s3/features/app/presentation/pages/order_add.dart';
import 'package:s3/injection_container.dart' as di;
import 'features/app/domain/usecases/auth_state_changes.dart';
import 'features/app/domain/usecases/user_sign_in.dart';
import 'features/app/domain/usecases/user_sign_out.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  //await initializeDateFormatting('ru_RU');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          //create: (_) => AuthStateChanges(FirebaseAuth.instance),
          create: (_) => AuthBloc(
            sl<AuthStateChanges>(),
            sl<UserSignIn>(),
            sl<UserSignOut>(),
          )..add(AppStarted()),
        ),
        BlocProvider<OrderCalendarBloc>(
          create: (_) => OrderCalendarBloc(
              sl<GetOrders>(), sl<OrderUpdate>(), sl<OrderCreate>())
            ..add(LoadOrders()),
        ),
        BlocProvider<ClientsCubit>(
            create: (context) =>
                ClientsCubit(context.read<OrderCalendarBloc>())),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return TabsController();
        }
        if (state is Unauthenticated) {
          return SignIn();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class TabsController extends StatefulWidget {
  TabsController({Key? key}) : super(key: key);
  @override
  _TabsControllerState createState() => _TabsControllerState();
}

class _TabsControllerState extends State<TabsController>
    with TickerProviderStateMixin {
  late TabController controller;

  _TabsControllerState();

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
              onPressed: () => dispatchSignOut()),
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
        OrderCalendarePage(),
        ClientsPage(),
      ]),
    );
  }

  void dispatchSignOut() async {
    BlocProvider.of<AuthBloc>(context).add(UserLogOut());
  }
}
