import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/pages/upload_redirect_screen.dart';
import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/router_class.dart';
import '../classes/user_class.dart';
import 'add_building.dart';
import 'edit_redirect_screen.dart';

class Controller extends StatefulWidget {
  Controller({Key? key, required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances})
      : super(key: key);

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );

  List<buildingObject> buildingInstances = [];

  List<floorObject> floorInstances = [];

  List<routerObject> routerInstances = [];

  @override
  State<Controller> createState() => _ControllerState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances
  );
}

class _ControllerState extends State<Controller> {

  _ControllerState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances
      );

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );

  List<buildingObject> buildingInstances = [];

  List<floorObject> floorInstances = [];

  List<routerObject> routerInstances = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Controller.png"),
              fit: BoxFit.cover
          )
      ),

      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Home Page',
            style: GoogleFonts.raleway(
              color: Colors.white60,
              fontWeight: FontWeight.w300,
              fontSize: 30,
            ),
          ),

          backgroundColor: const Color(0xffB62B37),
          elevation: 10,
          toolbarOpacity: 0.9,
          shadowColor: const Color(0xff100D49),
        ),

        backgroundColor: Colors.black54,
        body: Container(
          padding: const EdgeInsets.only(left: 60, right: 40, top: 0),
          child: Form(
            child: Center(
              child: Column(
                children: [
                const SizedBox(
                height: 150.0,
              ),

              SizedBox(
                height: 70, //height of button
                width: 250, //width of button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffB62B37), //background color of button
                    elevation: 8, //elevation of button
                    shape: RoundedRectangleBorder(
                      //to set border radius to button
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.all(20),
                    shadowColor: Color(0xFFCD4F69),
                ),
                onPressed: () => Navigator.of(context)
                  .push(
                  MaterialPageRoute(
                    builder: (context) => AddBuilding(
                      userInstance: userInstance,
                      buildingInstances: buildingInstances,
                      floorInstances: floorInstances,
                      routerInstances: routerInstances,
                    )
                  )
                ),
                  //code to execute when this button is pressed.

                child: Text(
                  "Add New Building",
                  style: GoogleFonts.raleway(
                    color: Colors.white60,
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
              )
            ),

            //--------------------------------------------------------------------------
            const SizedBox(
              height: 50.0,
            ),

            //----------------------Upload Floor Plan Button------------------------
            SizedBox(
                height: 70, //height of button
                width: 250, //width of button
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffB62B37), //background color of button
                      elevation: 8, //elevation of button
                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.all(20),
                      shadowColor: Color(0xFFCD4F69),
                    ),
                    onPressed:/* () => Navigator.of(context)
                        .push(
                        MaterialPageRoute(
                            builder: (context) => UploadRedirectScreen(
                              userInstance: this.userInstance,
                              buildingInstances: this.buildingInstances,
                              floorInstances: this.floorInstances,
                              routerInstances: this.routerInstances,
                            )
                        )
                    )*/ null,
                    child: Text(
                      "Upload Floor Plan",
                      style: GoogleFonts.raleway(
                        color: Colors.white60,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    )
                )
            ),

            //--------------------------------------------------------------------------
            const SizedBox(
              height: 50.0,
            ),

            //----------------------Edit Floor Plan Button------------------------
            SizedBox(
                height: 70, //height of button
                width: 250, //width of button
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffB62B37), //background color of button
                      elevation: 8, //elevation of button
                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.all(20),
                      shadowColor: Color(0xFFCD4F69),
                    ),
                    onPressed: /*() => Navigator.of(context)
                        .push(
                        MaterialPageRoute(
                            builder: (context) => EditRedirectScreen()
                        )
                    )*/ null,
                    child: Text(
                      "Edit Floor Plan",
                      style: GoogleFonts.raleway(
                        color: Colors.white60,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    )
                )
            ),

            //--------------------------------------------------------------------------
            const SizedBox(
              height: 50.0,
            ),
            //----------------------Collect Position Data Button------------------------
            SizedBox(
                height: 70, //height of button
                width: 250, //width of button
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffB62B37), //background color of button
                      elevation: 8, //elevation of button
                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.all(20),
                      shadowColor: Color(0xFFCD4F69),
                    ),
                    onPressed: () {
                      //code to execute when this button is pressed.
                    },
                    child: Text(
                      "Collect Position Data",
                      style: GoogleFonts.raleway(
                        color: Colors.white60,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    )
                )
            ),
            //--------------------------------------------------------------------------
            const SizedBox(
              height: 50.0,
              ),
            ],
          )),
        ),
      ),
      ),
    );
  }
}