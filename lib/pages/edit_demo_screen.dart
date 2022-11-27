import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/router_class.dart';
import '../classes/user_class.dart';
import 'edit_screen.dart';

class EditDemoScreen extends StatefulWidget {

  EditDemoScreen({
    super.key,
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding
  });

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );

  buildingObject currentBuilding = new buildingObject(
      "",
      "",
      "",
      0
  );

  List<buildingObject> buildingInstances = [];

  List<floorObject> floorInstances = [];

  List<routerObject> routerInstances = [];

  @override
  State<EditDemoScreen> createState() => _EditDemoScreenState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
    this.currentBuilding
  );
}

class _EditDemoScreenState extends State<EditDemoScreen> {

  _EditDemoScreenState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
    this.currentBuilding
  );

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );

  buildingObject currentBuilding = new buildingObject(
      "",
      "",
      "",
      0
  );

  List<buildingObject> buildingInstances = [];

  List<floorObject> floorInstances = [];

  List<routerObject> routerInstances = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff100D49),
        elevation: 10,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xff100D49)),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                         Text(
                          "How to edit floorplan",
                          style: GoogleFonts.raleway(
                            color: Colors.white60,
                            fontWeight: FontWeight.w300,
                            fontSize: 24,

                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Expanded(
                              child: Text(
                                "Step 1: Tap on floorplan to get X & Y coordinates of the router",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          backgroundColor: Color(0xff100D49),
                          backgroundImage: AssetImage('images/step1.jpeg'),
                          radius: 120.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Step 2: Tap on add button to add router name and MAC address",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                ),
                            ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          backgroundColor: Color(0xff100D49),
                          backgroundImage: AssetImage('images/step2.jpeg'),
                          radius: 120.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CircleAvatar(
                          //Add Button
                          radius: 35.0,
                          backgroundColor: const Color(0xFFCD4F69),
                          child: IconButton(
                            icon: Icon(Icons.arrow_circle_right_rounded),
                            color: Color.fromARGB(255, 255, 254, 254),
                            iconSize: 30,
                            splashColor: const Color(0xDACD4F69),
                            splashRadius: 45,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditScreen(
                                      userInstance: this.userInstance,
                                      buildingInstances: this.buildingInstances,
                                      floorInstances: this.floorInstances,
                                      routerInstances: this.routerInstances,
                                      currentBuilding: this.currentBuilding
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}