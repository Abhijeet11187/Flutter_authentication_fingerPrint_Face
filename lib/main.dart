import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/choose_Biometric_Screen.dart';
import 'Screens/dashboard_Screen.dart';
import 'Screens/login_screen.dart';

void main() async {
  print("In main");
  WidgetsFlutterBinding.ensureInitialized();
  print("In initaillized");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("In instance");

  bool islogin = prefs.getBool('LOGIN_STATUS');
  print("In login");

  bool biometricStatus = prefs.getBool('BIOMETRICSTATUS');
  print("In biomeertics");

  islogin == null ? islogin = false : islogin = islogin;
  biometricStatus == null
      ? biometricStatus = false
      : biometricStatus = biometricStatus;

  print("Status  $islogin");
  runApp(MyApp(
    bioMetricStatus: biometricStatus,
    loginStatus: islogin,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  bool loginStatus;
  bool bioMetricStatus;
  MyApp({this.bioMetricStatus, this.loginStatus}) {}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/login': (context) => MyApp(
              bioMetricStatus: false,
              loginStatus: false,
            ),
        // '/dashboard': (context) => Dashboard(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        loginStatus: loginStatus,
        biometricStatus: bioMetricStatus,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.loginStatus, this.biometricStatus})
      : super(key: key);
  final String title;
  final bool loginStatus;
  final bool biometricStatus;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.loginStatus
            ? ChooseBiometric(
                biometricStatus: widget.biometricStatus,
              )
            : Login());
  }
}
