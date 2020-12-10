import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Utils/Route.dart' as route;

bool logined = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("[DEBUG]Checking login");
  if (!kIsWeb) logined = await route.checkLogined();
  print("[DEBUG]Checked: $logined");
  runApp(MyApp());
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
      // home: Scaffold(
      //   resizeToAvoidBottomPadding: false,
      //   body: Container(
      //     child: LoginView(),
      //   ),
      // ),
      onGenerateRoute: route.generateRoute,
      // initialRoute: logined ? route.UserViewRoute : route.LoginViewRoute,
      initialRoute: route.DriverViewRoute,
    );

  }
}
