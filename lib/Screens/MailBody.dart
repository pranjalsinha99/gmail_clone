import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flamspark/Models/MailModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MailBody extends StatefulWidget {
  final Function mailListCallback;
  final Color iconColor;
  final Email emailContent;
  MailBody(
      {required this.emailContent,
      required this.mailListCallback,
      required this.iconColor,
      Key? key})
      : super(key: key);

  @override
  _MailBodyState createState() => _MailBodyState();
}

class _MailBodyState extends State<MailBody> {
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final storage = FlutterSecureStorage();

  Future<List<Email>> loadEmails() async {
    print("getting emails from sharedprefs");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String emailsString = prefs.getString('Emails').toString();
    return Email.decode(emailsString);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.emailContent.time);

    print(
        DateFormat('kk:mm a').format(HttpDate.parse(widget.emailContent.time)));
    final serverIP = 'https://android-dev.homingos.com';

    Future<http.Response> deleteEmail() async {
      var testkey = await storage.read(key: "jwt");
      var res = await http.delete(
        Uri.parse('$serverIP/deleteMailsByIds'),
        headers: <String, String>{
          'x-access-token': testkey.toString(),
        },
        body: jsonEncode(<String, dynamic>{
          "ids": [widget.emailContent.id]
        }),
      );
      return res;
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                widget.mailListCallback();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
                onPressed: () async {
                  await deleteEmail().then((value) =>
                      {print(value.statusCode), Navigator.of(context).pop()});
                },
                icon: Image.asset(
                  "assets/images/icons/deleteIcon.png",
                  width: 15,
                  height: 18,
                ))
          ],
          backgroundColor: Color(0x00FFFFFF),
          elevation: 0,
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
                  List<Email> allEmails = emailSnapshot.requireData;
                  return ScrollablePositionedList.builder(
                    scrollDirection: Axis.horizontal,
                    initialScrollIndex: allEmails.indexWhere((element) =>
                        element.id.contains(widget.emailContent
                            .id)), //you can pass the desired index here//
                    itemCount: allEmails.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(21, 20, 21, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    // color: Colors.blue,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            allEmails[index].subject,
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.openSans(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF292929)),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            height: 29,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFEEEEEE),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 7),
                                              child: Text(
                                                "Inbox",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF1F2024)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 38),
                                    child: Container(
                                      height: 43,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          // color: Colors.orange,
                                          ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3, right: 15),
                                            child: Container(
                                              height: 32,
                                              width: 32,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: widget.iconColor),
                                              child: Text(
                                                allEmails[index]
                                                    .sender
                                                    .characters
                                                    .first
                                                    .toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  allEmails[index].sender,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: Color(0xFF292929)),
                                                ),
                                                Text(
                                                  "to me",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25, top: 6),
                                            child: Container(
                                              height: 43,
                                              // color: Colors.red,
                                              child: Text(
                                                DateFormat('kk:mm a').format(
                                                    HttpDate.parse(
                                                        allEmails[index].time)),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff686B70),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 47, left: 41),
                                    child: Container(
                                      child: Text(
                                        allEmails[index].body,
                                        style: TextStyle(
                                            fontSize: 14,
                                            height: 1.78,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                  );
                }
              }
            }));
  }
}
