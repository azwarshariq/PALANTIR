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
    required this.currentBuilding,
    required this.currentFloor
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

  floorObject currentFloor = new floorObject(
      "",
      "",
      "",
      0,
      ""
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
    this.currentBuilding,
    this.currentFloor
  );
}

class _EditDemoScreenState extends State<EditDemoScreen> {

  _EditDemoScreenState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
    this.currentBuilding,
    this.currentFloor
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
  floorObject currentFloor = new floorObject(
      "",
      "",
      "",
      0,
      ""
  );

  List<buildingObject> buildingInstances = [];

  List<floorObject> floorInstances = [];

  List<routerObject> routerInstances = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        iconTheme: IconThemeData(
          color: const Color(0xff204E7A), //change your color here
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xffffffff)),
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
                            color: Color(0xFF204E7A),
                            fontWeight: FontWeight.w400,
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
                                  color: Color(0xFF204E7A),
                                  fontWeight: FontWeight.w300,
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
                          backgroundColor: Color(0xffffffff),
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
                                    color: Color(0xFF204E7A),
                                  fontWeight: FontWeight.w300,
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
                          backgroundColor: Color(0xffffffff),
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
                          radius: 30.0,
                          backgroundColor: const Color(0xFF44CDB1),
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward),
                            color: Color.fromARGB(255, 255, 254, 254),
                            iconSize: 30,
                            splashColor: const Color(0xDA44CDB1),
                            splashRadius: 45,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditScreen(
                                      userInstance: this.userInstance,
                                      buildingInstances: this.buildingInstances,
                                      floorInstances: this.floorInstances,
                                      routerInstances: this.routerInstances,
                                      currentBuilding: this.currentBuilding,
                                      currentFloor: this.currentFloor,
                                      alignment_x: 0,
                                      alignment_y: 0,
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