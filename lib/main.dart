import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Utils/Route.dart' as route;

bool logined = false;
bool connected = false;
String nextRoute = '';
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (!kIsWeb) {
      print("[DEBUG]Checking login");
      logined = await route.checkLogined();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('[DEBUG] Connected');
        connected = true;
      }
      print("[DEBUG]Checked: $logined");
      if (logined) await route.navigate().then((value) => nextRoute = value);
    }
    runApp(MyApp());
  } on SocketException catch (_) {
    print('[DEBUG] Not connected');
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      title: "Welcome",
      onGenerateRoute: route.generateRoute,
      initialRoute: logined ? route.LoadingViewRoute : route.LoginViewRoute,
    );
  }
}
