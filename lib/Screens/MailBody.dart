import 'dart:convert';

import 'package:flamspark/Models/MailModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class MailBody extends StatefulWidget {
  final Function mailListCallback;
  final Color iconColor;
  Email emailContent;
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
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    print(widget.emailContent.time);
    print(HttpDate.parse(widget.emailContent.time));
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

    String _mailBody = widget.emailContent.body;
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
      body: ListView(
        shrinkWrap: true,
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
                          widget.emailContent.subject,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.openSans(
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF292929)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 29,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 7),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 43,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              // color: Colors.blue,
                              ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.iconColor),
                                  child: Text(
                                    widget.emailContent.sender.characters.first
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 25),
                                child: Container(
                                  // clipBehavior: Clip.antiAlias,
                                  // decoration: BoxDecoration(color: Colors.blue),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Flexible(
                                          child: Text(
                                            widget.emailContent.sender,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.openSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Color(0xFF292929)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          "to me",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 43,
                        color: Colors.red,
                        width: 50,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 47, left: 41),
                  child: Container(
                    child: Text(
                      _mailBody,
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
  }
}
