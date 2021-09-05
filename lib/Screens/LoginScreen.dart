import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              // width: 562,
              height: 374,
              width: 375,
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(23, 28, 24, 0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
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
                    padding: const EdgeInsets.only(top: 15.5, bottom: 38),
                    child: TextFormField(
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
                  TextButton(
                      onPressed: () {},
                      child: Container(
                        alignment: Alignment.center,
                        width: 225,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Color(0xFF4BB1F7),
                        ),
                        child: Text("Login",
                            style: GoogleFonts.karla(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 0.85,
                                fontStyle: FontStyle.normal)),
                      )),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Signup Instead?",
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
