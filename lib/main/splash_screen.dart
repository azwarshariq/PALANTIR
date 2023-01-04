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
          .pushReplacement(MaterialPageRoute(builder: (context) => MainPage())),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/backgrounds/Splash Screen.png"),
          )
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage("assets/backgrounds/Splash Screen.png"),
                      fit: BoxFit.cover
                  )
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image(
                          image:AssetImage('images/logos/PALANTIR logo White.png')
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      Text(
                        "PALANTIR",
                        style: GoogleFonts.raleway(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w200,
                          fontSize: 40,
                          letterSpacing: 4,
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
                        color: const Color(0xffffffff),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text(
                        "Indoor Navigation System",
                          style: GoogleFonts.raleway(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w200,
                            fontSize: 18.0,
                          ),
                      )
                    ],
                  ))
            ])
          ],
        ),
      ),
    );
  }
}