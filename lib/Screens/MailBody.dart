import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MailBody extends StatefulWidget {
  MailBody({Key? key}) : super(key: key);

  @override
  _MailBodyState createState() => _MailBodyState();
}

class _MailBodyState extends State<MailBody> {
  String _mailBody =
      "Dear Tom Riddle, We are glad to inform you that your order from Piccolo with Flam app and 1 other is arriving earlier than expected. It will reach you by the end of today.Dear Tom Riddle, We are glad to inform you that your order from Piccolo with Flam app and 1 other is arriving earlier than expected. It will reach you by the end of today.Dear Tom Riddle, We are glad to inform you that your order from Piccolo with Flam app and 1 other is arriving earlier than expected. It will reach you by the end of today.Dear Tom Riddle, We are glad to inform you that your order from Piccolo with Flam app and 1 other is arriving earlier than expected. It will reach you by the end of today.Dear Tom Riddle, We are glad to inform you that your order from Piccolo with Flam app and 1 other is arriving earlier than expected. It will reach you by the end of today.Dear Tom Riddle, We are glad to inform you that your order from Piccolo with Flam app and 1 other is arriving earlier than expected. It will reach you by the end of today.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
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
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(21, 20, 21, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Subject",
                      style: GoogleFonts.openSans(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF292929)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                Padding(
                  padding: const EdgeInsets.only(top: 38),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "House of Slytherin",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF292929)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "to me",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text("May 6"),
                      )
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
