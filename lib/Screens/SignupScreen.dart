import 'dart:convert';

import 'package:flamspark/Models/MailModel.dart';
import 'package:flamspark/Screens/MailListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final serverIP = 'https://android-dev.homingos.com';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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

  Future<http.Response> attemptSignUp(
      String username, String password, String address) async {
    var res = await http.post(
      Uri.parse('$serverIP/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': username,
        'password': password,
        'address': address
      }),
    );
    // body: {"email": username, "password": password});

    return res;
  }

  Future<List<Email>> getEmails() async {
    var testkey = await storage.read(key: "jwt");
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
      // appBar: AppBar(
      //   backgroundColor: Color(0x00000000),
      //   elevation: 0.0,
      //   iconTheme: IconThemeData(color: Colors.black),
      // ),
      body: ListView(
        children: [
          Container(
            // width: 562,
            height: 238,
            width: 357,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/signup.png'),
                    fit: BoxFit.fitHeight)),
            // color: Colors.red,
            // child: Image.asset('assets/im
            // ages/signup.png',
            //      fit: BoxFit.fitWidth),
            child: Column(children: []),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(23, 0, 24, 0),
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
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          fontSize: 12,
                        ),
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
                    padding: const EdgeInsets.symmetric(vertical: 15.5),
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
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            fontSize: 12,
                          ),
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
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                        labelText: "Address",
                        hintText: "Enter your Address |",
                        helperText: "Address of flam app",
                        helperStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          fontSize: 12,
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          fontSize: 12,
                        ),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16),
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
                    padding: const EdgeInsets.only(top: 38),
                    child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var username = _usernameController.text;
                            var password = _passwordController.text;
                            var address = _addressController.text;

                            http.Response jwt = await attemptSignUp(
                                username.trim(), password, address);

                            if (jwt.statusCode == 201) {
                              Map<String, dynamic> user = jsonDecode(jwt.body);

                              await storage.write(
                                  key: "jwt", value: user["token"]);

                              // log(testemail.toString());

                              // List<Email> myList = await getEmails();

                              // print(myList.first.subject);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MailListScreen(
                                          // myEmails: myList,
                                          )));
                              // var testkey = await storage.read(key: "jwt");
                              // print(testkey);
                            } else {
                              displayDialog(context, "An Error Occurred",
                                  "Please Try Again Later");
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 225,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Color(0xFF4BB1F7),
                          ),
                          child: Text("Sign Up",
                              style: GoogleFonts.karla(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 0.85,
                                  fontStyle: FontStyle.normal)),
                        )),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login Instead?",
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
    );
  }
}
