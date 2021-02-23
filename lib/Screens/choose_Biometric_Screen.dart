import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_Screen.dart';

class ChooseBiometric extends StatefulWidget {
  bool biometricStatus;
  ChooseBiometric({this.biometricStatus});
  @override
  _ChooseBiometricState createState() => _ChooseBiometricState();
}

class _ChooseBiometricState extends State<ChooseBiometric> {
  SharedPreferences prefs;
  bool _cancelSignout = true;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  void initState() {
    super.initState();
    _initiateSharedPreference();
  }

  _initiateSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print("here -- ");
      print(e);
    }

    if (!mounted) return isAvailable;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

    return isAvailable;
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
      if (Platform.isIOS) {
        if (listOfBiometrics.contains(BiometricType.face)) {
          // Face ID.
        } else if (listOfBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    print(listOfBiometrics);
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    // setState(() {
    //   _cancelSignout = false;
    // });
    try {
      print("in the try");

      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to view Dashboard",
        useErrorDialogs: true,
        stickyAuth: true,
        sensitiveTransaction: true,
        androidAuthStrings: AndroidAuthMessages(
            cancelButton: 'Cancel',
            signInTitle: 'SignInTitle',
            fingerprintHint: '',
            fingerprintNotRecognized: 'Not Recognized',
            fingerprintSuccess: 'Authenticated',
            fingerprintRequiredTitle: 'REquired Fingerprint'),
      );
      print("Done Authenticated Status: $isAuthenticated");
    } on PlatformException catch (e) {
      print("Here__");
      print(e);
    }

    if (!mounted) return;

    isAuthenticated ? print('User is authenticated!') : _nnavgate();

    if (isAuthenticated) {
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     '/dashboard', (Route<dynamic> route) => false);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    }
  }

  _gotoDashBoard(biometricStatus) async {
    biometricStatus
        ? prefs.setBool('BIOMETRICSTATUS', true)
        : prefs.setBool('BIOMETRICSTATUS', false);

    print(
        "---------------------------------------- ------------ Status isssss $biometricStatus");
    // _authenticateUser();

    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Dashboard(),
      ),
    );
  }

  _nnavgate() {
    // setState(() {
    //   _cancelSignout = true;
    // });
  }

  Widget _biometricText() {
    return Text(
      'Want to enable Biometric ?',
      style: TextStyle(height: 5, fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _acceptButton() {
    return IconButton(
      icon: Icon(
        Icons.check,
        color: Colors.green,
        size: 35,
      ),
      onPressed: () {
        _gotoDashBoard(true);
      },
    );
  }

  Widget _rejectButton() {
    return IconButton(
      icon: Icon(
        Icons.not_interested,
        color: Colors.red,
        size: 35,
      ),
      onPressed: () {
        _gotoDashBoard(false);
      },
    );
  }

  Widget _body() {
    return Center(
      child: Container(
        height: 250,
        width: 200,
        child: Column(
          children: [
            _biometricText(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_acceptButton(), _rejectButton()],
            )
          ],
        ),
      ),
    );
  }

  activateBioMetrics() async {
    if (await _isBiometricAvailable()) {
      await _getListOfBiometricTypes();
      await _authenticateUser();
    }
  }

  _signout() {
    prefs.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  Widget _scanBiometrics() {
    activateBioMetrics();
    return _cancelSignout
        ? Center(
            child: Container(
              height: 120,
              width: 120,
              child: Column(
                children: [
                  RaisedButton(
                    onPressed: _signout,
                    child: Text("SignOut"),
                  ),
                  RaisedButton(
                    onPressed: _authenticateUser,
                    child: Text("Scan"),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: widget.biometricStatus ? _scanBiometrics() : _body());
  }
}
