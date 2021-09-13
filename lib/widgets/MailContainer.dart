import 'dart:io';

import 'package:flamspark/Models/MailModel.dart';
import 'package:flamspark/Screens/MailBody.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> deleteReq = [];

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
                      DateFormat('kk:mm a')
                          .format(HttpDate.parse(widget.email.time)),
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
