import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/auth/main_page.dart';
import 'package:palantir_ips/main/home_page_user.dart';
import 'home_page.dart';

class Pilot extends StatefulWidget {
  const Pilot({Key? key}) : super(key: key);

  @override
  State<Pilot> createState() => _PilotState();
}

class _PilotState extends State<Pilot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 70,
          title: Text(
            'Palantir',
            style: GoogleFonts.raleway(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w200,
              fontSize: 27,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              image: DecorationImage(
                  image: AssetImage("assets/elements/AppBar Edit.png"),
                  fit: BoxFit.cover
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .push(
                    MaterialPageRoute(
                        builder: (context) => MainPage()
                    )
                );
              },
            )
          ],
        ),

        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button to proceed as Mapper
                ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .push(
                      MaterialPageRoute(
                          builder: (context) => HomePage()
                      )
                  ),
                  style: ElevatedButton.styleFrom(
                    animationDuration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Color(0xFF577EA4),
                    shadowColor: Color(0xAA577EA4),
                    padding: EdgeInsets.all(20),
                  ),

                  child: Text(
                    'Proceed As Mapper',
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox(height:30),
                // Button to proceed as User
                ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .push(
                      MaterialPageRoute(
                          builder: (context) => HomePageUser()
                      )
                  ),

                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      //to set border radius to button
                        borderRadius: BorderRadius.circular(20)
                    ),
                    backgroundColor: const Color(0xFF739DC7),
                    shadowColor: Color(0xAA739DC7),
                    padding: EdgeInsets.all(20),
                  ),
                  child: Text(
                    'Proceed As User',
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height:30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

