import 'dart:async';
import 'dart:convert';
import 'package:flamspark/Screens/MailListScreen.dart';
import 'package:flamspark/Screens/SignupScreen.dart';
import 'package:flamspark/Models/MailModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  final FlutterSecureStorage storage;

  LoginScreen({
    Key? key,
    required this.storage,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final serverIP = 'https://android-dev.homingos.com';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"))
          ],
        ),
      );

  Future<http.Response> attemptLogIn(String username, String password) async {
    var res = await http.post(
      Uri.parse('$serverIP/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'email': username, 'password': password}),
    );

    return res;
  }

  Future<List<Email>> getEmails() async {
    var testkey = await widget.storage.read(key: "jwt");
    var res = await http.get(
      Uri.parse('$serverIP/getAllMails'),
      headers: <String, String>{
        'x-access-token': testkey.toString(),
      },
    );
    return parseEmails(res.body);
  }

  List<Email> parseEmails(String responseBody) {
    final parsed =
        jsonDecode(responseBody)["mails"].cast<Map<String, dynamic>>();

    return parsed.map<Email>((json) => Email.fromJson(json)).toList();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    // width: 562,
                    height: 374,
                    width: 375,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/signup.png'),
                            fit: BoxFit.fitHeight)),

                    child: Column(children: []),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(23, 28, 24, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a email';
                            }
                            return null;
                          },
                          controller: _usernameController,
                          decoration: InputDecoration(
                              hintText: "Enter your mail |",
                              helperText: "example@flamapp.com",
                              helperStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0, 0, 0, 0.6),
                                fontSize: 12,
                              ),
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                  fontSize: 16),
                              labelText: "Email",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color: Color.fromRGBO(0, 0, 0, 0.12))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color: Color.fromRGBO(0, 0, 0, 0.12))),
                              fillColor: Colors.red),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.5, bottom: 38),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Enter your Password |",
                                helperText: "example@flamapp.com",
                                helperStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                  fontSize: 12,
                                ),
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(0, 0, 0, 0.5),
                                    fontSize: 16),
                                labelText: "Password",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: Color.fromRGBO(0, 0, 0, 0.12))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: Color.fromRGBO(0, 0, 0, 0.12))),
                                fillColor: Colors.red),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var username = _usernameController.text;
                                var password = _passwordController.text;
                                showLoaderDialog(context);
                                http.Response jwt = await attemptLogIn(
                                    username.trim(), password);

                                if (jwt.statusCode == 201) {
                                  Map<String, dynamic> user =
                                      jsonDecode(jwt.body);

                                  await widget.storage
                                      .write(key: "jwt", value: user["token"]);

                                  Navigator.of(context).pushAndRemoveUntil(
                                    // the new route
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MailListScreen(),
                                    ),

                                    (Route route) => false,
                                  );
                                } else {
                                  Navigator.pop(context);
                                  displayDialog(context, "An Error Occurred",
                                      "No account was found matching that username and password");
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 225,
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Color(0xFF4BB1F7),
                              ),
                              child: Text("Login",
                                  style: GoogleFonts.karla(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 0.85,
                                      fontStyle: FontStyle.normal)),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen()));
                            },
                            child: Text(
                              "Signup Instead?",
                              style: TextStyle(
                                  color: Color(0xFF0C6EFA),
                                  fontWeight: FontWeight.w400),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
