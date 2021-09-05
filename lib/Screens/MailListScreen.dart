import 'package:flutter/material.dart';

class MailListScreen extends StatefulWidget {
  const MailListScreen({Key? key}) : super(key: key);

  @override
  _MailListScreenState createState() => _MailListScreenState();
}

class _MailListScreenState extends State<MailListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: ListView(
            children: [
              Container(
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0x26000000)),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: AppBar(
                  titleSpacing: 0,
                  title: TextField(
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(hintText: "Search messages"),
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
                  actions: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "RECIPIENTS",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
              MailHeader(),
            ],
          )),
    );
  }
}

class MailHeader extends StatelessWidget {
  const MailHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 80,
      // color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                //             boxShadow: [BoxShadow(
                //   color: Colors.grey,
                //   blurRadius: 5.0,
                // ),],
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Text(
                "F",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              "House of Slytherin",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF292929)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "Sorting hat is waiting for you",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF292929)),
                        ),
                      ),
                      Text(
                        "All the best True Bloods",
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
    );
  }
}
