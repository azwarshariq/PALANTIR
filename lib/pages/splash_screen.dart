import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/auth/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
          () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainPage())),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xff100D49)),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Color(0xff100D49),
                      backgroundImage: AssetImage('images/1.png'),
                      radius: 100.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Text(
                      "PALANTIR",
                      style: GoogleFonts.raleway(
                        color: const Color(0xffB62B37),
                        fontWeight: FontWeight.w300,
                        fontSize: 24.0,
                        letterSpacing: 3,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: const Color(0xffB62B37),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Indoor Navigation System",
                        style: GoogleFonts.raleway(
                          color: const Color(0xffB62B37),
                          fontWeight: FontWeight.w300,
                          fontSize: 18.0,
                        ),
                    )
                  ],
                ))
          ])
        ],
      ),
    );
  }
}