import 'package:flamspark/Screens/LoginScreen.dart';
import 'package:flamspark/Screens/MailBody.dart';
import 'package:flamspark/Screens/MailListScreen.dart';
import 'package:flamspark/Screens/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

const SERVER_IP = 'https://android-dev.homingos.com';
final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<int> get jwtOrEmpty async {
    var jwtcode = await storage.read(key: "jwt");
    if (jwtcode == null) {
      return 0;
    }
    var res = await http.get(
      Uri.parse('$SERVER_IP/verifyToken'),
      headers: <String, String>{
        'x-access-token': jwtcode,
      },
    );
    print(res);
    print(res.statusCode);
    return res.statusCode;
  }

  // Future<http.Response> attemptLogIn(String jwtCode) async {
  //   var res = await http.post(
  //     Uri.parse('$SERVER_IP/verifyToken'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  // body: {"email": username, "password": password});

  //   return res;
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data == 200) {
              return MailListScreen();
            } else {
              return LoginScreen(storage: storage);
            }
          }),
    );
  }
}
