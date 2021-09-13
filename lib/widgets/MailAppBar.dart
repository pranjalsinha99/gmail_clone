import 'package:flutter/material.dart';

import 'DataSearch.dart';

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
            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 5),
            child: Hero(
              tag: 'profile',
              child: Image.asset(
                "assets/images/icons/profileImage.png",
                height: 28,
                width: 28,
              ),
            ))
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'profile',
        child: Image.asset(
          "assets/images/icons/profileImage.png",
          height: 280,
          width: 280,
        ),
      ),
    );
  }
}
