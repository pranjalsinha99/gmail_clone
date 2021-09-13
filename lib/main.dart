import 'package:flamspark/Models/MailModel.dart';
import 'package:flamspark/Screens/LoginScreen.dart';
import 'package:flamspark/Screens/MailBody.dart';

import 'package:flamspark/Screens/MailListScreen.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flamspark',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                )),
                backgroundColor: Colors.white,
              );
            if (snapshot.data == 200) {
              // List<Email> oneMail = [
              //   Email(
              //       body: "body",
              //       id: "id",
              //       sender: "sender",
              //       subject: "subject",
              //       time: "time")
              // ];
              return MailListScreen(
                  // myEmails: oneMail,
                  );
            } else {
              return LoginScreen(storage: storage);
            }
          }),
    );
  }
}
