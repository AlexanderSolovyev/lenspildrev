import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s3/res/auth_service.dart';
import 'package:s3/ui/pages/sign_in/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:s3/ui/pages/event_calendare/event_calendare.dart';
import 'package:s3/ui/pages/add_event/add_event.dart';

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
