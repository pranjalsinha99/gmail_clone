import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flamspark/Models/MailModel.dart';
import 'package:flamspark/Screens/LoginScreen.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flamspark/widgets/widgets.dart';

List<String> deleteReq = [];

class MailListScreen extends StatefulWidget {
  // List<Email> myEmails;
  MailListScreen({
    // required this.myEmails,
    Key? key,
  }) : super(key: key);

  @override
  _MailListScreenState createState() => _MailListScreenState();
}

class _MailListScreenState extends State<MailListScreen> {
  final _storage = FlutterSecureStorage();
  final serverIP = 'https://android-dev.homingos.com';
  String dropdownValue = 'Time';

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<List<Email>> loadEmails() async {
    print("getting emails from sharedprefs");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String emailsString = prefs.getString('Emails').toString();
    return Email.decode(emailsString);
  }

  Future<List<Email>> getEmails() async {
    print("getting emails from api");
    var testkey = await _storage.read(key: "jwt");
    var res = await http.get(
      Uri.parse('$serverIP/getAllMails'),
      headers: <String, String>{
        'x-access-token': testkey.toString(),
      },
    );
    if (res.statusCode != 200) {
      displayDialog(context, "Session Timeout", "Please Login Again");
      Navigator.of(context).pushAndRemoveUntil(
        // the new route
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(
            storage: _storage,
          ),
        ),

        (Route route) => false,
      );
    }
    return parseEmails(res.body);
  }

  List<Email> parseEmails(String responseBody) {
    final parsed =
        jsonDecode(responseBody)["mails"].cast<Map<String, dynamic>>();

    return parsed.map<Email>((json) => Email.fromJson(json)).toList();
  }

  void getNewEmails() async {
    dropdownValue = 'Time';
    print("refreshing emails");
    List<Email> myList = await getEmails();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedEmails = Email.encode(myList);

    print("updating Sharedprefs");
    await prefs.setString('Emails', encodedEmails);
  }

  @override
  void initState() {
    getNewEmails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDeleteView = false;
    print("loaded messagelist");
    deleteReq = [];

    return Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    var x = await this._storage.readAll();
                    print(x);
                    setState(() {
                      this._storage.deleteAll();
                    });
                    x = await this._storage.readAll();
                    print(x);

                    Navigator.of(context).pushAndRemoveUntil(
                      // the new route
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(
                          storage: _storage,
                        ),
                      ),

                      (Route route) => false,
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Color(0xFF4BB1F7),
                    ),
                    child: Text("Log Out",
                        style: GoogleFonts.karla(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 0.85,
                            fontStyle: FontStyle.normal)),
                  )),
            ],
          ),
        ),
        body: FutureBuilder<List<Email>>(
            future: loadEmails(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Email>> emailSnapshot) {
              if (emailSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              } else {
                if (emailSnapshot.hasError)
                  return Center(child: Text('Error: ${emailSnapshot.error}'));
                else {
                  List<Email> myEmails = emailSnapshot.requireData;
                  return Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 12,
                      ),
                      child: RefreshIndicator(
                        color: Colors.red,
                        onRefresh: () async {
                          getNewEmails();
                          setState(() {});
                        },
                        child: ListView(
                          children: [
                            Container(
                              height: 44,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0x26000000)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: MailAppBar(
                                isDeleteView: isDeleteView,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 9, bottom: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "RECIPIENTS",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  DropdownButton<String>(
                                    value: this.dropdownValue,
                                    onChanged: (String? newValue) async {
                                      if (newValue == "Name") {
                                        myEmails.sort((a, b) =>
                                            a.sender.compareTo(b.sender));
                                        List<Email> myList = myEmails;
                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        final String encodedEmails =
                                            Email.encode(myList);
                                        // print("encoded data");
                                        // log(encodedEmails);

                                        await prefs.setString(
                                            'Emails', encodedEmails);
                                        setState(() {
                                          dropdownValue = 'Name';
                                          print(myEmails.first.sender);
                                        });
                                      } else {
                                        myEmails.sort((a, b) =>
                                            HttpDate.parse(a.time).compareTo(
                                                HttpDate.parse(b.time)));
                                        List<Email> myList = myEmails;
                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        final String encodedEmails =
                                            Email.encode(myList);
                                        // print("encoded data");
                                        // log(encodedEmails);

                                        await prefs.setString(
                                            'Emails', encodedEmails);
                                        setState(() {
                                          dropdownValue = 'Time';
                                          print(myEmails.first.time);
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.sort,
                                      color: Colors.black,
                                    ),
                                    items: <String>['Time', 'Name']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                            ...myEmails.map((e) => MailContainer(
                                mailListCallback: () {
                                  setState(() {});
                                },
                                updateParent: (bool l) {
                                  isDeleteView = l;
                                },
                                email: e,
                                iconColor: Color(
                                        (math.Random().nextDouble() * 0xFFFFFF)
                                            .toInt())
                                    .withOpacity(1.0))),
                          ],
                        ),
                      ));
                }
              }
            }));
  }
}
