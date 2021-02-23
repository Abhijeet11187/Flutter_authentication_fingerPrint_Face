import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_demo/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  SharedPreferences prefs;
  void initState() {
    super.initState();
    _initiateSharedPreference();
  }

  _initiateSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  _body() {
    return Center(
      child: Container(
          height: 200,
          child: Column(
            children: [
              Text(
                "Welcome to Dashboard",
                style: TextStyle(
                    height: 5, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  _logout() {
    prefs.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text('Welcome to Bashobard'),
          actions: [
            IconButton(icon: Icon(Icons.power_settings_new), onPressed: _logout)
          ],
        ),
        body: _body());
  }
}
