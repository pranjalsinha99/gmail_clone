import 'dart:convert';
import 'package:flamspark/Screens/MailBody.dart';
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
  // List<Email> myEmails = [
  //   Email(
  //       body: "body",
  //       id: "id",
  //       sender: "sender",
  //       subject: "subject1",
  //       time: "time")
  // ];

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
    return parseEmails(res.body);
  }

  List<Email> parseEmails(String responseBody) {
    final parsed =
        jsonDecode(responseBody)["mails"].cast<Map<String, dynamic>>();

    return parsed.map<Email>((json) => Email.fromJson(json)).toList();
  }

  // void ini() async {
  //   getNewEmails();

  // }

  void getNewEmails() async {
    dropdownValue = 'Time';
    print("refreshing emails");
    List<Email> myList = await getEmails();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedEmails = Email.encode(myList);
    // print("encoded data");
    // log(encodedEmails);
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
    // ini();
    // setState(() {});
    // List<Email> _email = myEmails;
    print("loaded messagelist");
    deleteReq = [];
    // isDeleteView = false;

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
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     print("Pressed sort button");
                                  //   },
                                  //   child: Icon(
                                  //     Icons.sort,
                                  //     color: Colors.black,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            // MailBody(emailContent: _email.first),

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

class MailAppBar extends StatefulWidget {
  bool isDeleteView;
  MailAppBar({
    required this.isDeleteView,
    Key? key,
  }) : super(key: key);

  @override
  _MailAppBarState createState() => _MailAppBarState();
}

class _MailAppBarState extends State<MailAppBar> {
  void ini() {
    setState(() {
      widget.isDeleteView = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: TextField(
        textAlign: TextAlign.left,
        decoration: InputDecoration(hintText: "Search messages"),
        onTap: () {
          showSearch(context: context, delegate: DataSearch());
        },
      ),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white10,

      // backgroundColor: Colors.red,
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      leading: (widget.isDeleteView == true)
          ? IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back))
          : null,
      actions: [
        Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 3),
            child: IconButton(
              iconSize: 0,
              padding: const EdgeInsets.all(0),
              icon: Image.asset(
                "assets/images/icons/profileImage.png",
                width: 28,
                height: 28,
              ),
              onPressed: () {},
            )
            // child: Container(
            //   width: 28,
            //   height: 28,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.red,
            //   ),
            // ),
            )
      ],
    );
  }
}

class MailContainer extends StatefulWidget {
  final Email email;
  final Color iconColor;
  final Function updateParent;
  final Function mailListCallback;
  MailContainer(
      {required this.updateParent,
      required this.mailListCallback(),
      required this.email,
      required this.iconColor,
      Key? key})
      : super(key: key);

  @override
  _MailContainerState createState() => _MailContainerState();
}

class _MailContainerState extends State<MailContainer> {
  void selectEmail() {
    setState(() {
      isClicked = !isClicked;
      if (isClicked) {
        deleteReq.add(widget.email.id);
      } else if (!isClicked) {
        deleteReq.remove(widget.email.id);
      }
      if (deleteReq.isNotEmpty) {
      } else {}
      print(deleteReq.toString());
      // print(isDeleteView);
    });
  }

  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        selectEmail();
      },
      onTap: () {
        setState(() {
          print("clicked");
        });

        Navigator.of(context).push(
          // the new route
          MaterialPageRoute(
            builder: (BuildContext context) => MailBody(
              mailListCallback: widget.mailListCallback,
              emailContent: this.widget.email,
              iconColor: this.widget.iconColor,
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.topLeft,
        height: 80,
        decoration: BoxDecoration(
            color: isClicked ? Color(0xFFE2F0FA) : Color(0x00FFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        // color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  selectEmail();
                  // print("clicked icon");
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    //             boxShadow: [BoxShadow(
                    //   color: Colors.grey,
                    //   blurRadius: 5.0,
                    // ),],
                    shape: BoxShape.circle,
                    color: isClicked ? Color(0xFF0C6EFA) : widget.iconColor,
                  ),
                  child: isClicked
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : Text(
                          widget.email.sender.characters.first.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Container(
                  height: 56,
                  width: 264,
                  // color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/icons/chevrons-right.png",
                              width: 16,
                              height: 20,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  widget.email.sender,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF292929)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            widget.email.subject,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF292929)),
                          ),
                        ),
                        Text(
                          widget.email.body,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF5D5C5D)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    alignment: Alignment.topRight,
                    // color: Colors.yellow,
                    child: Text(
                      "02:02 am",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF5D5C5D)),
                    ),
                  ),
                ),
              )
              // Padding(
              //   padding:
              //       const EdgeInsets.only(top: 12, bottom: 12, left: 12),
              //   child: Container(
              //     height: 56,
              //     color: Colors.black,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
