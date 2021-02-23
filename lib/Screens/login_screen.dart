import 'package:flutter/material.dart';
import 'package:local_auth_demo/Screens/choose_Biometric_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  SharedPreferences prefs;

  void initState() {
    super.initState();
    _initiateSharedPreference();
  }

  _initiateSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  Widget _loginForm() {
    return Center(
      child: Container(
        height: 250,
        width: 300,
        child: Column(
          children: [
            // Dash(
            //     direction: Axis.vertical,
            //     length: 130,
            //     dashLength: 15,
            //     dashColor: grey),
            _getUserIdRow(),
            _getUserPasswordRow(),
            SizedBox(
              height: 20,
            ),
            _loginButton()
          ],
        ),
      ),
    );
  }

  Widget _getUserIdRow() {
    return TextFormField(
      controller: _userIdController,
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Enter User Id',
        labelText: 'User Id *',
      ),
    );
  }

  Widget _getUserPasswordRow() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        icon: Icon(Icons.pages),
        hintText: 'Enter Password',
        labelText: 'Password *',
      ),
    );
  }

  Widget _loginButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: RaisedButton(
          onPressed: _gotoNextScreen,
          textColor: Colors.white,
          color: Colors.black,
          padding: const EdgeInsets.all(0.0),
          child: Text("Login")),
    );
  }

  _gotoNextScreen() {
    if (_userIdController.text == 'a' && _passwordController.text == 'a') {
      prefs.setBool('LOGIN_STATUS', true);
      print("Checking status");
      bool biometricStatus = prefs.getBool('BIOMETRICSTATUS');
      print("Bio metric status  $biometricStatus");
      biometricStatus == null
          ? biometricStatus = false
          : biometricStatus = biometricStatus;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChooseBiometric(
                  biometricStatus: biometricStatus,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loginForm(),
    );
  }
}
