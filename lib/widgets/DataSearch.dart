import 'package:flamspark/Models/MailModel.dart';
import 'package:flamspark/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

List<String> recentSearch = [];

class DataSearch extends SearchDelegate<String> {
  List<String> sublist = [];

  List<Email> allEmails = [];

  loadEmails() async {
    print("getting emails from sharedprefs");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String emailsString = prefs.getString('Emails').toString();
    allEmails = Email.decode(emailsString);
    allEmails.forEach((element) {
      sublist.add(element.sender);
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Email> results = [];
    if (query != "") {
      if (!recentSearch.contains(query)) {
        recentSearch.add(query);
      }

      allEmails.forEach((element) {
        if (element.body.contains(query) ||
            element.sender.contains(query) ||
            element.subject.contains(query)) {
          results.add(element);
        }
      });
      if (results.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return MailContainer(
                    mailListCallback: () {},
                    updateParent: () {},
                    email: results[index],
                    iconColor:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0));
              }),
        );
      } else
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              'assets/images/search.png',
              height: 220,
              width: 220,
            )),
            Text(
              "No matches for $query",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0x4D000000)),
            )
          ],
        );
    } else
      return Center(
          child: Image.asset(
        'assets/images/search.png',
        height: 220,
        width: 220,
      ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    loadEmails();
    if (query == "") {
      if (recentSearch.isNotEmpty) {
        return ListView.builder(
          itemCount: recentSearch.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.history),
              title: Text(recentSearch[index]),
            );
          },
        );
      } else
        return Center(
            child: Image.asset(
          'assets/images/search.png',
          height: 220,
          width: 220,
        ));
    } else {
      List<String> a = [];
      sublist.forEach((element) {
        if (element.contains(query) && !a.contains(element)) {
          a.add(element);
        }
      });
      return ListView.builder(
        itemCount: a.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(a[index]),
            onTap: () {
              if (!recentSearch.contains(a[index])) {
                recentSearch.add(a[index]);
              }
            },
          );
        },
      );
    }
  }
}
