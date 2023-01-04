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
              color: const Color(0xFF204E7A),
              fontWeight: FontWeight.w200,
              fontSize: 27,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              image: DecorationImage(
                  image: AssetImage("assets/elements/AppBar Upload.png"),
                  fit: BoxFit.cover
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Color(0xFF204E7A),
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
                Container(
                  height: 230,
                  width: 320,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/elements/Pilot Mapper Container.png"),
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 40),
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Proceed as Mapper",
                        style: GoogleFonts.raleway(
                          color: Color(0xFF204E7A),
                          fontWeight: FontWeight.w300,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 15,),
                      FloatingActionButton(
                        child: Icon(Icons.maps_home_work_outlined),
                        splashColor:  Color(0xAA204E7A),
                        heroTag: 'btn1',
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF204E7A),
                        onPressed: () => Navigator.of(context)
                          .push(
                          MaterialPageRoute(
                              builder: (context) => HomePage()
                          )
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height:30),
                // Button to proceed as User
                Container(
                  height: 230,
                  width: 320,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/elements/Pilot User Container.png"),
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 40),
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Proceed as User",
                        style: GoogleFonts.raleway(
                          color: Color(0xFF204E7A),
                          fontWeight: FontWeight.w300,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 15,),
                      FloatingActionButton(
                        child: Icon(Icons.location_on_outlined),
                        splashColor:  Color(0xAA204E7A),
                        heroTag: 'btn2',
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF204E7A),
                        onPressed: () => Navigator.of(context)
                            .push(
                            MaterialPageRoute(
                                builder: (context) => HomePageUser()
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

