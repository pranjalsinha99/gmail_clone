import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0x00000000),
      //   elevation: 0.0,
      //   iconTheme: IconThemeData(color: Colors.black),
      // ),
      body: ListView(
        children: [
          Container(
            // width: 562,
            height: 238,
            width: 357,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(23, 0, 24, 0),
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
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          fontSize: 12,
                        ),
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
                    padding: const EdgeInsets.symmetric(vertical: 15.5),
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
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            fontSize: 12,
                          ),
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
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                        labelText: "Address",
                        hintText: "Enter your Address |",
                        helperText: "Address of flam app",
                        helperStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          fontSize: 12,
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          fontSize: 12,
                        ),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16),
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
                    padding: const EdgeInsets.only(top: 38),
                    child: TextButton(
                        onPressed: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: 225,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Color(0xFF4BB1F7),
                          ),
                          child: Text("Sign Up",
                              style: GoogleFonts.karla(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 0.85,
                                  fontStyle: FontStyle.normal)),
                        )),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login Instead?",
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
