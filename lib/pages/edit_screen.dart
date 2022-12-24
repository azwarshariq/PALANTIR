import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../classes/building_class.dart';
import '../classes/elevators_class.dart';
import '../classes/floor_class.dart';
import '../classes/room_class.dart';
import '../classes/router_class.dart';
import '../classes/stairs_class.dart';
import '../classes/user_class.dart';
import 'collect_data_screen.dart';
import 'hero_dialog_route.dart';
import 'dart:math';
import 'dart:ui' as ui;

class EditScreen extends StatefulWidget {

  EditScreen({
    super.key,
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding,
    required this.currentFloor,
    required this.alignment_x,
    required this.alignment_y,
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

  double alignment_x;
  double alignment_y;

  @override
  State<EditScreen> createState() => _EditScreenState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
    this.currentBuilding,
    this.currentFloor,
    this.alignment_x,
    this.alignment_y
  );

}

TextEditingController userInput = TextEditingController();

final formKey = GlobalKey<FormState>(); //key for form

int screen = 0;
String routerAddress = " ";
double xVar = 0;
double yVar = 0;
int xyAxis = 100;
int value = 0;

String mac = "";
String routerName = "";
String roomID = "";
String stairsID = "";
String elevatorID = "";
String typeID = "";
String checkNull = "false";

List<String> listOfBSSIDs = [];

List<String> listOfRouters = [];
List<String> listOfRooms = [];
List<String> listOfStairs = [];
List<String> listOfElevators = [];
List<String> types = [];

class _EditScreenState extends State<EditScreen> {

  String? Url = " ";
  _EditScreenState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.alignment_x,
      this.alignment_y
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  double alignment_x;
  double alignment_y;

  Offset? _tapPosition;
  String _value = "";

  Future<String> getURL(image) async{
     final ref = FirebaseStorage.instance.ref().child('files/' + image);
     var url =  await ref.getDownloadURL();
     return url.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (position) {
        setState(() {
          _tapPosition = position.globalPosition;
          xVar = (((_tapPosition?.dx ?? 0) -
            (MediaQuery.of(context).size.width * 0.05)) /
            (MediaQuery.of(context).size.width * 0.9)) *
            xyAxis;

          yVar = (((_tapPosition?.dy ?? 0) -
            (MediaQuery.of(context).padding.top + kToolbarHeight)) /
            (MediaQuery.of(context).size.height * 0.7)) *
            xyAxis;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/elements/AppBar Edit.png'),
            fit: BoxFit.cover,
          ),
          iconTheme: IconThemeData(
            color: const Color(0xffffffff), //change your color here
          ),
          elevation: 0,
          title: Text(
            'Edit Floorplan',
            style: GoogleFonts.raleway(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: const Color(0x00ffffff),
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/Controller Screen.png"),
                fit: BoxFit.cover
              )
            ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      //displayFloorplan(currentFloor: currentFloor, height1: 700, width1: 400,),
                      Stack(

                          children: [

                            Container(
                              child: Column(
                                children: [

                                  FutureBuilder<String>(
                                      future: getURL(currentFloor.floorPlan),
                                      builder: (BuildContext context, AsyncSnapshot<String> url)
                                      {
                                        Url = url.data;
                                        var check = Url;
                                        if (check != null) {
                                          checkNull = "true";
                                          return Image.network(
                                            Url!,
                                            height: MediaQuery.of(context).size.height * 0.70,
                                            width: MediaQuery.of(context).size.width * 0.90,
                                            fit:BoxFit.contain,
                                          ); // Safe
                                        }
                                        else{
                                          return Center(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Loading...",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white60,
                                                    )
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              alignment: Alignment(alignment_x, alignment_y),
                              height: 600,
                              width: 350,
                              child: CustomPaint(
                                size: Size(MediaQuery.of(context).size.width * 0.05, (MediaQuery.of(context).size.width * 0.05*1.375).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                painter: RPSCustomPainter(),
                              ),
                            ),
                          ]
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                          .push(
                            HeroDialogRoute(
                              builder: (context) {
                                return PopUpItemBody(
                                    userInstance: this.userInstance,
                                    buildingInstances: this.buildingInstances,
                                    floorInstances: this.floorInstances,
                                    routerInstances: this.routerInstances,
                                    currentBuilding: this.currentBuilding,
                                    currentFloor: this.currentFloor,
                                    roomInstances: this.roomInstances,
                                    stairsInstances: this.stairsInstances,
                                    elevatorsInstances: this.elevatorsInstances,
                                );
                              }
                            )
                          );
                        },
                        child: Hero(
                          tag: 'btn2',
                          child: Material(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 56,
                              color: Color(0xff44CDB1),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.12,
                      ),

                      PopupMenuButton(
                        child: Material(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                          child: const Icon(
                            Icons.delete,
                            size: 56,
                            color: Color(0xff44CDB1),
                          ),
                        ),
                        onSelected: (value) {
                          setState(() {
                            _value = value;
                            if (_value == "router"){
                              Navigator.of(context)
                              .push(
                                HeroDialogRoute(
                                  builder: (context) {
                                    return PopUpItemBodyRouter(
                                      userInstance: this.userInstance,
                                      buildingInstances: this.buildingInstances,
                                      floorInstances: this.floorInstances,
                                      routerInstances: this.routerInstances,
                                      currentBuilding: this.currentBuilding,
                                      currentFloor: this.currentFloor,
                                      roomInstances: this.roomInstances,
                                      stairsInstances: this.stairsInstances,
                                      elevatorsInstances: this.elevatorsInstances,
                                    );
                                  }
                                )
                              );
                            }
                            else if (_value == "room"){
                              Navigator.of(context)
                              .push(
                                HeroDialogRoute(
                                  builder: (context) {
                                    return PopUpItemBodyRoom(
                                      userInstance: this.userInstance,
                                      buildingInstances: this.buildingInstances,
                                      floorInstances: this.floorInstances,
                                      routerInstances: this.routerInstances,
                                      currentBuilding: this.currentBuilding,
                                      currentFloor: this.currentFloor,
                                      roomInstances: this.roomInstances,
                                      stairsInstances: this.stairsInstances,
                                      elevatorsInstances: this.elevatorsInstances,
                                    );
                                  }
                                )
                              );
                            }
                            else if (_value == "stairs"){
                              Navigator.of(context)
                              .push(
                                HeroDialogRoute(
                                  builder: (context) {
                                    return PopUpItemBodyStairs(
                                      userInstance: this.userInstance,
                                      buildingInstances: this.buildingInstances,
                                      floorInstances: this.floorInstances,
                                      routerInstances: this.routerInstances,
                                      currentBuilding: this.currentBuilding,
                                      currentFloor: this.currentFloor,
                                      roomInstances: this.roomInstances,
                                      stairsInstances: this.stairsInstances,
                                      elevatorsInstances: this.elevatorsInstances,
                                    );
                                  }
                                )
                              );
                            }
                            else if (_value == "elevator"){
                              Navigator.of(context)
                              .push(
                                HeroDialogRoute(
                                  builder: (context) {
                                    return PopUpItemBodyElevator(
                                      userInstance: this.userInstance,
                                      buildingInstances: this.buildingInstances,
                                      floorInstances: this.floorInstances,
                                      routerInstances: this.routerInstances,
                                      currentBuilding: this.currentBuilding,
                                      currentFloor: this.currentFloor,
                                      roomInstances: this.roomInstances,
                                      stairsInstances: this.stairsInstances,
                                      elevatorsInstances: this.elevatorsInstances,
                                    );
                                  }
                                )
                              );
                            }
                          });
                        },
                        itemBuilder:(context) => [
                          PopupMenuItem(
                            child: Text("Router"),
                            value: "router",
                          ),

                          PopupMenuItem(
                            child: Text("Room"),
                            value: "room",
                          ),

                          PopupMenuItem(
                            child: Text("Stairs"),
                            value: "stairs",
                          ),

                          PopupMenuItem(
                            child: Text("Elevator"),
                            value: "elevator",
                          ),
                        ]
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),

                      CircleAvatar(
                        //Add Button
                        radius: 35.0,
                        backgroundColor: const Color(0xFFFFFFFF),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          color: Color(0xFFA11C44),
                          iconSize: 30,
                          splashColor: const Color(0xAAA11C44),
                          splashRadius: 45,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CollectDataScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  Container(
                    child: ((_tapPosition?.dx ?? 0) >
                        (MediaQuery.of(context).size.width * 0.05) &&
                        (_tapPosition?.dx ?? 0) <
                            (MediaQuery.of(context).size.width * 0.95) &&
                        (_tapPosition?.dy ?? 0) >
                            (MediaQuery.of(context).padding.top +
                                kToolbarHeight) &&
                        (_tapPosition?.dy ?? 0) <
                            (MediaQuery.of(context).size.height * 0.7) +
                                (MediaQuery.of(context).padding.top +
                                    kToolbarHeight))
                        ? Text(
                      'X : ${xVar.toString()}, Y : ${yVar.toString()}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14),
                    )
                      : null,
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ]
              )
            )
          )
        ),
      ),
    );
  }
}

class PopUpItemBody extends StatefulWidget {
  PopUpItemBody({
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding,
    required this.currentFloor,
    required this.roomInstances,
    required this.stairsInstances,
    required this.elevatorsInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  @override
  State<PopUpItemBody> createState() => _PopUpItemBodyState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorsInstances
  );
}

class _PopUpItemBodyState extends State<PopUpItemBody> {

  _PopUpItemBodyState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorInstances = [];

  Future addRouterData(String routerName, String BSSID, double xVar, double yVar) async {
    String floorRef = currentFloor.referenceId;
    // We need to store the floor's reference in all elements that we add
    // All elements will be handled using a 3 step process to add it into all controlling
    // parts of the database and local objects

    // 1. First create a Firestore document with given data
    await FirebaseFirestore.instance.collection('Routers')
      .doc(floorRef + routerName) // <-- Router Document ID (buildingID+floorName+routerName)
      .set({
        'routerName': routerName,
        'floorRef': floorRef,
        'BSSID': BSSID,
        'x': xVar,
        'y': yVar
      }
      ) //
      .then((_) => print('Added ' + routerName + ' with BSSID ' + BSSID))
      .catchError((error) => print('Add failed: $error'));

    // 2. Then create a Router Object instance, to store relevant data
    routerObject routerInstance = new routerObject(
        floorRef + routerName,      // Reference ID for Router (floorRef + routerName)
        routerName,                 // Name of Router
        floorRef,                   // Floor Reference
        BSSID,                      // BSSID of Router
        xVar,                       // x Coordinate
        yVar                        // y Coordinate
    );

    // 3. Add routerInstance to the list of all routerInstances, for further use down the line
    routerInstances.add(routerInstance);
  }

  Future addRoomData(String roomName, double xVar, double yVar) async {
    String floorRef = currentFloor.referenceId;
    // We need to store the floor's reference in all elements that we add
    // All elements will be handled using a 3 step process to add it into all controlling
    // parts of the database and local objects

    // 1. First create a Firestore document with given data
    await FirebaseFirestore.instance.collection('Rooms')
      .doc(floorRef + roomName) // <-- Room Document ID (buildingID+floorName+roomName)
      .set({
      'roomName': roomName,
      'floorRef': floorRef,
      'x': xVar,
      'y': yVar
      }
      ) //
      .then((_) => print('Added Room: ' + roomName))
      .catchError((error) => print('Add failed: $error'));

    // 2. Then create a Room Object instance, to store relevant data
    roomObject roomInstance = new roomObject(
        floorRef + roomName,      // Reference ID for Room (floorRef + roomName)
        roomName,                   // Name of Room
        floorRef,                   // Floor Reference
        xVar,                       // x Coordinate
        yVar                        // y Coordinate
    );

    // 3. Add roomInstance to the list of all roomInstances, for further use down the line
    roomInstances.add(roomInstance);
  }

  Future addStairsData(String stairsName, double xVar, double yVar) async {
    String floorRef = currentFloor.referenceId;
    // We need to store the floor's reference in all elements that we add
    // All elements will be handled using a 3 step process to add it into all controlling
    // parts of the database and local objects

    // 1. First create a Firestore document with given data
    await FirebaseFirestore.instance.collection('Stairs')
        .doc(floorRef + stairsName) // <-- Stairs Document ID (buildingID+floorName+stairsName)
        .set({
      'stairsName': stairsName,
      'floorRef': floorRef,
      'x': xVar,
      'y': yVar
    }
    ) //
        .then((_) => print('Added Stairs: ' + stairsName))
        .catchError((error) => print('Add failed: $error'));


    // 2. Then create a Stairs Object instance, to store relevant data
    stairsObject stairsInstance = new stairsObject(
        floorRef + stairsName,      // Reference ID for Stairs (floorRef + stairsName)
        stairsName,                 // Name of Stairs
        floorRef,                   // Floor Reference
        xVar,                       // x Coordinate
        yVar                        // y Coordinate
    );

    // 3. Add stairInstance to the list of all stairInstances, for further use down the line
    stairsInstances.add(stairsInstance);
  }

  Future addElevatorsData(String elevatorName, double xVar, double yVar) async {
    String floorRef = currentFloor.referenceId;
    // We need to store the floor's reference in all elements that we add
    // All elements will be handled using a 3 step process to add it into all controlling
    // parts of the database and local objects

    // 1. First create a Firestore document with given data
    await FirebaseFirestore.instance.collection('Elevators')
        .doc(floorRef + elevatorName) // <-- Elevators Document ID (buildingID+floorName+elevatorName)
        .set({
      'elevatorName': elevatorName,
      'floorRef': floorRef,
      'x': xVar,
      'y': yVar
    }
    ) //
        .then((_) => print('Added Elevator: ' + elevatorName))
        .catchError((error) => print('Add failed: $error'));

    // 2. Then create a Elevator Object instance, to store relevant data
    elevatorObject elevatorInstance = new elevatorObject(
        floorRef + elevatorName,    // Reference ID for Elevators (floorRef + elevatorName)
        elevatorName,               // Name of Elevator
        floorRef,                   // Floor Reference
        xVar,                       // x Coordinate
        yVar                        // y Coordinate
    );

    // 3. Add elevatorInstance to the list of all elevatorInstances, for further use down the line
    elevatorInstances.add(elevatorInstance);
  }

  String initialTypeValue = 'Router';
  var type = ['Router', 'Room', 'Stairs', 'Elevator'];

  void updateName(value) {
    setState(() {
      routerName = value;
    });
  }

  void updateMac(value) {
    setState(() {
      mac = value;
    });
  }

  void updateRoom(value) {
    setState(() {
      roomID = value;
    });
  }

  void updateStairs(value) {
    setState(() {
      stairsID = value;
    });
  }

  void updateElevator(value) {
    setState(() {
      elevatorID = value;
    });
  }

  bool check = false;

  // void _fetchData(BuildContext context) async {
  //   // show the loading dialog
  //   showDialog(
  //     // The user CANNOT close this dialog  by pressing outsite it
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (_) {
  //         return Dialog(
  //           // The background color
  //           backgroundColor: Colors.white,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: const [
  //                 // The loading indicator
  //                 CircularProgressIndicator(),
  //                 SizedBox(
  //                   height: 15,
  //                 ),
  //                 // Some text
  //                 Text('Loading...')
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //
  //   // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   Navigator.of(context).pop();
  // }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: 'btn2',
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton(
                      value: initialTypeValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: type.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          initialTypeValue = newValue!;
                        });
                      },
                      dropdownColor: Colors.white60,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),

                    initialTypeValue == "Router" ?
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateName(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Router ID e.g R1',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ):
                    initialTypeValue == "Room" ?
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateRoom(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Room ID e.g Room1',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ):
                    initialTypeValue == "Stairs" ?
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateStairs(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Stairs ID e.g S1',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ):
                    initialTypeValue == "Elevator" ?
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateElevator(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Elevator ID e.g E1',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ):
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    initialTypeValue == "Router" ?
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateMac(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Mac Address',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ):
                    const Divider(
                      color: Colors.white,
                      thickness: 0.5,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.5,
                    ),

                    ElevatedButton(
                      onPressed: () => {
                        if (xVar == 0 || yVar == 0)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please tap on screen to select x and y coordinates!'
                                )
                              )
                            ),
                          }
                        else
                          {
                            if(initialTypeValue == "Router")
                              {
                                if (routerName == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter router ID'
                                        )
                                      )
                                    ),
                                  }
                                else if (mac == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter MAC address')
                                      )
                                    ),
                                  }
                                else
                                  {
                                    check = false,
                                    for (int i = 0; i < listOfBSSIDs.length; i++)
                                      {
                                        if (mac == listOfBSSIDs[i])
                                          {
                                            check = true,
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'MAC Address already exists')
                                              )
                                            ),
                                          }
                                        else if (routerName == listOfRouters[i])
                                          {
                                            check = true,
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Router ID already exists')
                                              )
                                            ),
                                          }
                                        },
                                    if (check == false)
                                      {
                                        Navigator.pop(context),
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content:
                                                Text('Router Successfully Added')
                                            )
                                        ),

                                        print(mac),
                                        print(xVar),
                                        print(yVar),
                                        addRouterData(routerName, mac, xVar, yVar),
                                        listOfBSSIDs.add(mac),
                                        listOfRouters.add(routerName),
                                        types.add("Router"),
                                        mac = "",
                                        routerName = "",

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => EditScreen(
                                              userInstance: this.userInstance,
                                              buildingInstances: this.buildingInstances,
                                              floorInstances: this.floorInstances,
                                              routerInstances: this.routerInstances,
                                              currentBuilding: this.currentBuilding,
                                              currentFloor: this.currentFloor,
                                              alignment_x: ((xVar*2)/100)-1,
                                              alignment_y: ((yVar*2)/100)-1,

                                            ),
                                          ),
                                        ),
                                      }
                                  }
                              }
                            else if(initialTypeValue == "Room")
                              {
                                if (roomID == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Please enter room ID'))),
                                  }
                                else
                                  {
                                    check = false,
                                    for (int i = 0; i < listOfRooms.length; i++)
                                      {
                                        if (roomID == listOfRooms[i])
                                          {
                                            check = true,
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Room ID already exists'))),
                                          }
                                      },
                                    if (check == false)
                                      {
                                        Navigator.pop(context),
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content:
                                                Text('Room Successfully Added'))),
                                        print(xVar),
                                        print(yVar),
                                        print(roomID),
                                        addRoomData(roomID, xVar, yVar),
                                        listOfRooms.add(roomID),
                                        types.add("Room"),
                                        roomID = "",
                                      }
                                  }
                              }

                            else if(initialTypeValue == "Stairs")
                              {
                                if (stairsID == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Please enter stairs ID'))),
                                  }
                                else
                                  {
                                    check = false,
                                    for (int i = 0; i < listOfStairs.length; i++)
                                      {
                                        if (stairsID == listOfStairs[i])
                                          {
                                            check = true,
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Stairs ID already exists'))),
                                          }
                                      },
                                    if (check == false)
                                      {
                                        Navigator.pop(context),
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content:
                                                Text('Stairs Successfully Added'))),
                                        print(xVar),
                                        print(yVar),
                                        addStairsData(stairsID, xVar, yVar),
                                        listOfStairs.add(stairsID),
                                        types.add("Stairs"),
                                        stairsID = "",
                                      }
                                  }
                              }
                            else if(initialTypeValue == "Elevator")
                              {
                                if (elevatorID == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Please enter elevator ID'))),
                                  }
                                else
                                  {
                                    check = false,
                                    for (int i = 0; i < listOfElevators.length; i++)
                                      {
                                        if (elevatorID == listOfElevators[i])
                                          {
                                            check = true,
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Elevator ID already exists'))),
                                          }
                                      },
                                    if (check == false)
                                      {
                                        Navigator.pop(context),
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content:
                                                Text('Elevator Successfully Added'))),
                                        print(xVar),
                                        print(yVar),
                                        addElevatorsData(elevatorID, xVar, yVar),
                                        listOfElevators.add(elevatorID),
                                        types.add("Elevator"),
                                        elevatorID = "",
                                      }
                                  }
                              }
                          }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffA11C44) // Background color
                      ),
                      child: const Text("Add",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PopUpItemBodyRouter extends StatefulWidget {

  PopUpItemBodyRouter({
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding,
    required this.currentFloor,
    required this.roomInstances,
    required this.stairsInstances,
    required this.elevatorsInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  @override
  State<PopUpItemBodyRouter> createState() => _PopUpItemBodyRouterState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorsInstances

  );
}

class _PopUpItemBodyRouterState extends State<PopUpItemBodyRouter> {

  _PopUpItemBodyRouterState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorsInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  Future deleteRouterData(String routerName) async {
    String floorRef = currentFloor.referenceId;
    // Floor's reference needed to access Firestore document
    // To delete, need to do 2 steps

    // 1. First delete the Firestore document using Document ID (floorRef+routerName)
    await FirebaseFirestore.instance.collection('Routers')
        .doc(floorRef + routerName) // <-- Router Document ID (buildingID+floorName+routerName)
        .delete();

    // 2. Then delete the relevant object from routerInstances list
    for (int i=0; i<routerInstances.length; i++){
      if (routerInstances[i].routerName == routerName){
        routerInstances.remove(routerInstances[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              ListTile(
                title: Text("ID: ${listOfRouters[index]}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    Text("MAC: ${listOfBSSIDs[index]}")
                  ],
                ),
                trailing: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    deleteRouterData(listOfRouters[index]);
                    listOfRouters.remove(listOfRouters[index]);
                    listOfBSSIDs.remove(listOfBSSIDs[index]);
                    Navigator.pop(context, '/');

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Router Successfully Deleted!')));
                  },
                  child: Material(
                    color: Color.fromARGB(198, 255, 255, 255),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: const Icon(
                      Icons.delete,
                      size: 40,
                      color: Color(0xffA11C44),
                    ),
                  ),
                ),
              ),

            );
          },
          itemCount: listOfRouters.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,

        ),
      ),
    );
  }
}

class PopUpItemBodyRoom extends StatefulWidget {
  PopUpItemBodyRoom({
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding,
    required this.currentFloor,
    required this.roomInstances,
    required this.stairsInstances,
    required this.elevatorsInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  @override
  State<PopUpItemBodyRoom> createState() => _PopUpItemBodyRoomState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorsInstances
  );
}

class _PopUpItemBodyRoomState extends State<PopUpItemBodyRoom> {
  _PopUpItemBodyRoomState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorsInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  Future deleteRoomData(String roomName) async {
    String floorRef = currentFloor.referenceId;
    // Floor's reference needed to access Firestore document
    // To delete, need to do 2 steps

    // 1. First delete the Firestore document using Document ID (floorRef+roomName)
    await FirebaseFirestore.instance.collection('Rooms')
        .doc(floorRef + roomName) // <-- Router Document ID (buildingID+floorName+roomName)
        .delete();

    // 2. Then delete the relevant object from roomInstances list
    for (int i=0; i<roomInstances.length; i++){
      if (roomInstances[i].roomName == roomName){
        roomInstances.remove(roomInstances[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              ListTile(
                title: Text("ID: ${listOfRooms[index]}"),
                trailing: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    deleteRoomData(listOfRooms[index]);
                    listOfRooms.remove(listOfRooms[index]);
                    Navigator.pop(context, '/');

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Room Successfully Deleted!')));
                  },
                  child: Material(
                    color: Color.fromARGB(198, 255, 255, 255),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: const Icon(
                      Icons.delete,
                      size: 40,
                      color: Color(0xffB62B37),
                    ),
                  ),
                ),
              ),

            );
          },
          itemCount: listOfRooms.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,

        ),
      ),
    );
  }
}

class PopUpItemBodyStairs extends StatefulWidget {
  PopUpItemBodyStairs({
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding,
    required this.currentFloor,
    required this.roomInstances,
    required this.stairsInstances,
    required this.elevatorsInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  @override
  State<PopUpItemBodyStairs> createState() => _PopUpItemBodyStairsState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorsInstances
  );
}

class _PopUpItemBodyStairsState extends State<PopUpItemBodyStairs> {
  _PopUpItemBodyStairsState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorsInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  Future deleteStairsData(String stairsName) async {
    String floorRef = currentFloor.referenceId;
    // Floor's reference needed to access Firestore document
    // To delete, need to do 2 steps

    // 1. First delete the Firestore document using Document ID (floorRef+stairsName)
    await FirebaseFirestore.instance.collection('Stairs')
        .doc(floorRef + stairsName) // <-- Router Document ID (buildingID+floorName+stairsName)
        .delete();

    // 2. Then delete the relevant object from stairsInstances list
    for (int i=0; i<stairsInstances.length; i++){
      if (stairsInstances[i].stairsName == stairsName){
        stairsInstances.remove(stairsInstances[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              ListTile(
                title: Text("ID: ${listOfStairs[index]}"),
                trailing: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    deleteStairsData(listOfStairs[index]);
                    listOfStairs.remove(listOfStairs[index]);
                    Navigator.pop(context, '/');

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Stairs Successfully Deleted!')));
                  },
                  child: Material(
                    color: Color.fromARGB(198, 255, 255, 255),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: const Icon(
                      Icons.delete,
                      size: 40,
                      color: Color(0xffB62B37),
                    ),
                  ),
                ),
              ),

            );
          },
          itemCount: listOfStairs.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,

        ),
      ),
    );
  }
}

class PopUpItemBodyElevator extends StatefulWidget {
  PopUpItemBodyElevator({
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding,
    required this.currentFloor,
    required this.roomInstances,
    required this.stairsInstances,
    required this.elevatorsInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  @override
  State<PopUpItemBodyElevator> createState() => _PopUpItemBodyElevatorState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorsInstances
  );
}

class _PopUpItemBodyElevatorState extends State<PopUpItemBodyElevator> {
  _PopUpItemBodyElevatorState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding,
      this.currentFloor,
      this.roomInstances,
      this.stairsInstances,
      this.elevatorsInstances
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  Future deleteElevatorData(String elevatorName) async {
    String floorRef = currentFloor.referenceId;
    // Floor's reference needed to access Firestore document
    // To delete, need to do 2 steps

    // 1. First delete the Firestore document using Document ID (floorRef+elevatorName)
    await FirebaseFirestore.instance.collection('Elevators')
        .doc(floorRef + elevatorName) // <-- Router Document ID (buildingID+floorName+elevatorName)
        .delete();

    // 2. Then delete the relevant object from elevatorInstances list
    for (int i=0; i<elevatorsInstances.length; i++){
      if (elevatorsInstances[i].elevatorName == elevatorName){
        elevatorsInstances.remove(elevatorsInstances[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              ListTile(
                title: Text("ID: ${listOfElevators[index]}"),
                trailing: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    deleteElevatorData(listOfElevators[index]);
                    listOfElevators.remove(listOfElevators[index]);
                    Navigator.pop(context, '/');

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Elevator Successfully Deleted!')
                        )
                    );
                  },
                  child: Material(
                    color: Color.fromARGB(198, 255, 255, 255),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: const Icon(
                      Icons.delete,
                      size: 40,
                      color: Color(0xffB62B37),
                    ),
                  ),
                ),
              ),

            );
          },
          itemCount: listOfElevators.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,

        ),
      ),
    );
  }
}

// class displayFloorplan extends StatefulWidget {
//
//   displayFloorplan({
//     super.key,
//     required this.currentFloor,
//     required this.height1,
//     required this.width1,
//   });
//
//   floorObject currentFloor = new floorObject(
//       "",
//       "",
//       "",
//       0,
//       ""
//   );
//   final height1;
//   final width1;
//
//   @override
//   State<displayFloorplan> createState() => _displayFloorplanState(
//     this.currentFloor,
//     this.height1,
//     this.width1,
//   );
// }
//
// class _displayFloorplanState extends State<displayFloorplan> {
//   String? Url = " ";
//   floorObject currentFloor = new floorObject(
//       "",
//       "",
//       "",
//       0,
//       ""
//   );
//   final height1;
//   final width1;
//
//   _displayFloorplanState(
//       this.currentFloor,
//       this.height1,
//       this.width1
//       );
//
//   Future<String> getURL(image) async{
//     final ref = FirebaseStorage.instance.ref().child('files/' + image);
//     var url =  await ref.getDownloadURL();
//     return url.toString();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//         children: [
//           Container(
//             child: Column(
//               children: [
//                 Text(this.height1.toString()),
//                 FutureBuilder<String>(
//                   future: getURL(currentFloor.floorPlan),
//                   builder: (BuildContext context, AsyncSnapshot<String> url)
//                   {
//                     Url = url.data;
//                     var check = Url;
//                     if (check != null) {
//                       return Image.network(
//                       Url!,
//                       height: MediaQuery.of(context).size.height * 0.70,
//                       width: MediaQuery.of(context).size.width * 0.90,
//                       fit:BoxFit.contain,
//                       ); // Safe
//                     }
//                     else{
//                       return Center(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text("Loading...",
//                               style: TextStyle(
//                                 fontSize: 17,
//                                 color: Colors.white60,
//                               )
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   }
//                 ),
//               ],
//             ),
//           ),
//           Container(
//               alignment: Alignment.center,
//               height: 200,
//               width: 200,
//               child: CustomPaint(
//                 size: Size(MediaQuery.of(context).size.width * 0.05, (MediaQuery.of(context).size.width * 0.05*1.375).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//                 painter: RPSCustomPainter(),
//               )
//           ),
//           Container(
//               alignment: Alignment.center,
//               height: 200,
//               width: 200,
//               child: Text(
//                 width1.toString(),
//               ),
//           ),
//         ]
//     );
//   }
// }

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Color(0xffA21C44).withOpacity(1.0);
    canvas.drawOval(Rect.fromCenter(center:Offset(size.width*0.5000000,size.height*0.3181818),width:size.width*0.9166667,height:size.height*0.6363636),paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width*0.5000000,size.height);
    path_1.lineTo(size.width*0.9330125,size.height*0.3181818);
    path_1.lineTo(size.width*0.06698750,size.height*0.3181818);
    path_1.lineTo(size.width*0.5000000,size.height);
    path_1.close();

    Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
    paint_1_fill.color = Color(0xffA21C44).withOpacity(1.0);
    canvas.drawPath(path_1,paint_1_fill);

    Paint paint_2_fill = Paint()..style=PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawCircle(Offset(size.width*0.5000000,size.height*0.3030303),size.width*0.08333333,paint_2_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//
// class RPSCustomPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//
//     Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
//     paint_0_fill.color = Color(0xff204E7A).withOpacity(1.0);
//     canvas.drawOval(Rect.fromCenter(center:Offset(size.width*0.5000000,size.height*0.5000000),width:size.width,height:size.height),paint_0_fill);
//
//     Path path_1 = Path();
//     path_1.moveTo(size.width*0.08649353,size.height*0.6060606);
//     path_1.lineTo(size.width*0.08649353,size.height*0.3909091);
//     path_1.lineTo(size.width*0.1747288,size.height*0.3909091);
//     path_1.cubicTo(size.width*0.1837485,size.height*0.3909091,size.width*0.1919838,size.height*0.3928273,size.width*0.1994347,size.height*0.3966667);
//     path_1.cubicTo(size.width*0.2068856,size.height*0.4005061,size.width*0.2133562,size.height*0.4057576,size.width*0.2188465,size.height*0.4124242);
//     path_1.cubicTo(size.width*0.2245326,size.height*0.4188879,size.width*0.2288465,size.height*0.4261606,size.width*0.2317876,size.height*0.4342424);
//     path_1.cubicTo(size.width*0.2349250,size.height*0.4421212,size.width*0.2364935,size.height*0.4502030,size.width*0.2364935,size.height*0.4584848);
//     path_1.cubicTo(size.width*0.2364935,size.height*0.4687879,size.width*0.2345329,size.height*0.4784848,size.width*0.2306112,size.height*0.4875758);
//     path_1.cubicTo(size.width*0.2268856,size.height*0.4966667,size.width*0.2214935,size.height*0.5043424,size.width*0.2144347,size.height*0.5106061);
//     path_1.cubicTo(size.width*0.2075721,size.height*0.5168697,size.width*0.1994347,size.height*0.5210091,size.width*0.1900229,size.height*0.5230303);
//     path_1.lineTo(size.width*0.2411994,size.height*0.6060606);
//     path_1.lineTo(size.width*0.2179641,size.height*0.6060606);
//     path_1.lineTo(size.width*0.1688465,size.height*0.5266667);
//     path_1.lineTo(size.width*0.1070818,size.height*0.5266667);
//     path_1.lineTo(size.width*0.1070818,size.height*0.6060606);
//     path_1.lineTo(size.width*0.08649353,size.height*0.6060606);
//     path_1.close();
//     path_1.moveTo(size.width*0.1070818,size.height*0.5078788);
//     path_1.lineTo(size.width*0.1753171,size.height*0.5078788);
//     path_1.cubicTo(size.width*0.1835524,size.height*0.5078788,size.width*0.1907091,size.height*0.5055545,size.width*0.1967876,size.height*0.5009091);
//     path_1.cubicTo(size.width*0.2028662,size.height*0.4962636,size.width*0.2075721,size.height*0.4902030,size.width*0.2109053,size.height*0.4827273);
//     path_1.cubicTo(size.width*0.2142385,size.height*0.4750515,size.width*0.2159053,size.height*0.4669697,size.width*0.2159053,size.height*0.4584848);
//     path_1.cubicTo(size.width*0.2159053,size.height*0.4497970,size.width*0.2139444,size.height*0.4418182,size.width*0.2100229,size.height*0.4345455);
//     path_1.cubicTo(size.width*0.2062974,size.height*0.4270697,size.width*0.2011994,size.height*0.4211121,size.width*0.1947288,size.height*0.4166667);
//     path_1.cubicTo(size.width*0.1884544,size.height*0.4120212,size.width*0.1813956,size.height*0.4096970,size.width*0.1735524,size.height*0.4096970);
//     path_1.lineTo(size.width*0.1070818,size.height*0.4096970);
//     path_1.lineTo(size.width*0.1070818,size.height*0.5078788);
//     path_1.close();
//     path_1.moveTo(size.width*0.3352265,size.height*0.6090909);
//     path_1.cubicTo(size.width*0.3242471,size.height*0.6090909,size.width*0.3140500,size.height*0.6069697,size.width*0.3046382,size.height*0.6027273);
//     path_1.cubicTo(size.width*0.2954235,size.height*0.5982818,size.width*0.2873844,size.height*0.5923242,size.width*0.2805215,size.height*0.5848485);
//     path_1.cubicTo(size.width*0.2738550,size.height*0.5771727,size.width*0.2686588,size.height*0.5684848,size.width*0.2649332,size.height*0.5587879);
//     path_1.cubicTo(size.width*0.2612079,size.height*0.5488879,size.width*0.2593450,size.height*0.5384848,size.width*0.2593450,size.height*0.5275758);
//     path_1.cubicTo(size.width*0.2593450,size.height*0.5162636,size.width*0.2612079,size.height*0.5057576,size.width*0.2649332,size.height*0.4960606);
//     path_1.cubicTo(size.width*0.2686588,size.height*0.4861606,size.width*0.2739529,size.height*0.4774758,size.width*0.2808156,size.height*0.4700000);
//     path_1.cubicTo(size.width*0.2876785,size.height*0.4623242,size.width*0.2957176,size.height*0.4563636,size.width*0.3049324,size.height*0.4521212);
//     path_1.cubicTo(size.width*0.3143441,size.height*0.4476758,size.width*0.3245412,size.height*0.4454545,size.width*0.3355206,size.height*0.4454545);
//     path_1.cubicTo(size.width*0.3465029,size.height*0.4454545,size.width*0.3566000,size.height*0.4476758,size.width*0.3658147,size.height*0.4521212);
//     path_1.cubicTo(size.width*0.3750324,size.height*0.4563636,size.width*0.3830706,size.height*0.4623242,size.width*0.3899324,size.height*0.4700000);
//     path_1.cubicTo(size.width*0.3967971,size.height*0.4774758,size.width*0.4020912,size.height*0.4861606,size.width*0.4058147,size.height*0.4960606);
//     path_1.cubicTo(size.width*0.4095412,size.height*0.5057576,size.width*0.4114029,size.height*0.5162636,size.width*0.4114029,size.height*0.5275758);
//     path_1.cubicTo(size.width*0.4114029,size.height*0.5384848,size.width*0.4095412,size.height*0.5488879,size.width*0.4058147,size.height*0.5587879);
//     path_1.cubicTo(size.width*0.4020912,size.height*0.5684848,size.width*0.3967971,size.height*0.5771727,size.width*0.3899324,size.height*0.5848485);
//     path_1.cubicTo(size.width*0.3832676,size.height*0.5923242,size.width*0.3752265,size.height*0.5982818,size.width*0.3658147,size.height*0.6027273);
//     path_1.cubicTo(size.width*0.3566000,size.height*0.6069697,size.width*0.3464029,size.height*0.6090909,size.width*0.3352265,size.height*0.6090909);
//     path_1.close();
//     path_1.moveTo(size.width*0.2796391,size.height*0.5278788);
//     path_1.cubicTo(size.width*0.2796391,size.height*0.5395970,size.width*0.2820903,size.height*0.5503030,size.width*0.2869921,size.height*0.5600000);
//     path_1.cubicTo(size.width*0.2920903,size.height*0.5694939,size.width*0.2988559,size.height*0.5770697,size.width*0.3072853,size.height*0.5827273);
//     path_1.cubicTo(size.width*0.3157176,size.height*0.5881818,size.width*0.3250324,size.height*0.5909091,size.width*0.3352265,size.height*0.5909091);
//     path_1.cubicTo(size.width*0.3454235,size.height*0.5909091,size.width*0.3547382,size.height*0.5880818,size.width*0.3631676,size.height*0.5824242);
//     path_1.cubicTo(size.width*0.3716000,size.height*0.5767667,size.width*0.3783647,size.height*0.5690909,size.width*0.3834618,size.height*0.5593939);
//     path_1.cubicTo(size.width*0.3885618,size.height*0.5494939,size.width*0.3911088,size.height*0.5387879,size.width*0.3911088,size.height*0.5272727);
//     path_1.cubicTo(size.width*0.3911088,size.height*0.5155545,size.width*0.3885618,size.height*0.5048485,size.width*0.3834618,size.height*0.4951515);
//     path_1.cubicTo(size.width*0.3783647,size.height*0.4854545,size.width*0.3716000,size.height*0.4777788,size.width*0.3631676,size.height*0.4721212);
//     path_1.cubicTo(size.width*0.3547382,size.height*0.4664636,size.width*0.3454235,size.height*0.4636364,size.width*0.3352265,size.height*0.4636364);
//     path_1.cubicTo(size.width*0.3250324,size.height*0.4636364,size.width*0.3157176,size.height*0.4665667,size.width*0.3072853,size.height*0.4724242);
//     path_1.cubicTo(size.width*0.2990500,size.height*0.4782818,size.width*0.2923844,size.height*0.4860606,size.width*0.2872862,size.height*0.4957576);
//     path_1.cubicTo(size.width*0.2821882,size.height*0.5052515,size.width*0.2796391,size.height*0.5159606,size.width*0.2796391,size.height*0.5278788);
//     path_1.close();
//     path_1.moveTo(size.width*0.4433824,size.height*0.5409091);
//     path_1.lineTo(size.width*0.4433824,size.height*0.4481818);
//     path_1.lineTo(size.width*0.4633824,size.height*0.4481818);
//     path_1.lineTo(size.width*0.4633824,size.height*0.5372727);
//     path_1.cubicTo(size.width*0.4633824,size.height*0.5552515,size.width*0.4663235,size.height*0.5686879,size.width*0.4722059,size.height*0.5775758);
//     path_1.cubicTo(size.width*0.4782853,size.height*0.5864636,size.width*0.4872059,size.height*0.5909091,size.width*0.4989706,size.height*0.5909091);
//     path_1.cubicTo(size.width*0.5068147,size.height*0.5909091,size.width*0.5143618,size.height*0.5891909,size.width*0.5216176,size.height*0.5857576);
//     path_1.cubicTo(size.width*0.5290676,size.height*0.5821212,size.width*0.5356382,size.height*0.5770697,size.width*0.5413235,size.height*0.5706061);
//     path_1.cubicTo(size.width*0.5470088,size.height*0.5639394,size.width*0.5513235,size.height*0.5562636,size.width*0.5542647,size.height*0.5475758);
//     path_1.lineTo(size.width*0.5542647,size.height*0.4481818);
//     path_1.lineTo(size.width*0.5742647,size.height*0.4481818);
//     path_1.lineTo(size.width*0.5742647,size.height*0.5812121);
//     path_1.cubicTo(size.width*0.5742647,size.height*0.5840394,size.width*0.5748529,size.height*0.5861606,size.width*0.5760294,size.height*0.5875758);
//     path_1.cubicTo(size.width*0.5772059,size.height*0.5887879,size.width*0.5789706,size.height*0.5894939,size.width*0.5813235,size.height*0.5896970);
//     path_1.lineTo(size.width*0.5813235,size.height*0.6060606);
//     path_1.cubicTo(size.width*0.5789706,size.height*0.6062636,size.width*0.5771088,size.height*0.6063636,size.width*0.5757353,size.height*0.6063636);
//     path_1.cubicTo(size.width*0.5743618,size.height*0.6065667,size.width*0.5730882,size.height*0.6066667,size.width*0.5719118,size.height*0.6066667);
//     path_1.cubicTo(size.width*0.5679912,size.height*0.6062636,size.width*0.5645588,size.height*0.6046455,size.width*0.5616176,size.height*0.6018182);
//     path_1.cubicTo(size.width*0.5588735,size.height*0.5989909,size.width*0.5574029,size.height*0.5955545,size.width*0.5572059,size.height*0.5915152);
//     path_1.lineTo(size.width*0.5566176,size.height*0.5703030);
//     path_1.cubicTo(size.width*0.5499500,size.height*0.5824242,size.width*0.5408324,size.height*0.5919182,size.width*0.5292647,size.height*0.5987879);
//     path_1.cubicTo(size.width*0.5178912,size.height*0.6056576,size.width*0.5055382,size.height*0.6090909,size.width*0.4922059,size.height*0.6090909);
//     path_1.cubicTo(size.width*0.4761265,size.height*0.6090909,size.width*0.4639706,size.height*0.6033333,size.width*0.4557353,size.height*0.5918182);
//     path_1.cubicTo(size.width*0.4475000,size.height*0.5803030,size.width*0.4433824,size.height*0.5633333,size.width*0.4433824,size.height*0.5409091);
//     path_1.close();
//     path_1.moveTo(size.width*0.6930147,size.height*0.5984848);
//     path_1.cubicTo(size.width*0.6914471,size.height*0.5990909,size.width*0.6889941,size.height*0.6002030,size.width*0.6856618,size.height*0.6018182);
//     path_1.cubicTo(size.width*0.6823294,size.height*0.6034333,size.width*0.6783088,size.height*0.6048485,size.width*0.6736029,size.height*0.6060606);
//     path_1.cubicTo(size.width*0.6688971,size.height*0.6072727,size.width*0.6638000,size.height*0.6078788,size.width*0.6583088,size.height*0.6078788);
//     path_1.cubicTo(size.width*0.6526235,size.height*0.6078788,size.width*0.6472294,size.height*0.6067667,size.width*0.6421324,size.height*0.6045455);
//     path_1.cubicTo(size.width*0.6372294,size.height*0.6023242,size.width*0.6333088,size.height*0.5989909,size.width*0.6303676,size.height*0.5945455);
//     path_1.cubicTo(size.width*0.6274265,size.height*0.5899000,size.width*0.6259559,size.height*0.5842424,size.width*0.6259559,size.height*0.5775758);
//     path_1.lineTo(size.width*0.6259559,size.height*0.4645455);
//     path_1.lineTo(size.width*0.6047794,size.height*0.4645455);
//     path_1.lineTo(size.width*0.6047794,size.height*0.4481818);
//     path_1.lineTo(size.width*0.6259559,size.height*0.4481818);
//     path_1.lineTo(size.width*0.6259559,size.height*0.3948485);
//     path_1.lineTo(size.width*0.6459559,size.height*0.3948485);
//     path_1.lineTo(size.width*0.6459559,size.height*0.4481818);
//     path_1.lineTo(size.width*0.6812500,size.height*0.4481818);
//     path_1.lineTo(size.width*0.6812500,size.height*0.4645455);
//     path_1.lineTo(size.width*0.6459559,size.height*0.4645455);
//     path_1.lineTo(size.width*0.6459559,size.height*0.5718182);
//     path_1.cubicTo(size.width*0.6463471,size.height*0.5774758,size.width*0.6483088,size.height*0.5817182,size.width*0.6518382,size.height*0.5845455);
//     path_1.cubicTo(size.width*0.6555647,size.height*0.5873727,size.width*0.6597794,size.height*0.5887879,size.width*0.6644853,size.height*0.5887879);
//     path_1.cubicTo(size.width*0.6699765,size.height*0.5887879,size.width*0.6749765,size.height*0.5878788,size.width*0.6794853,size.height*0.5860606);
//     path_1.cubicTo(size.width*0.6839941,size.height*0.5840394,size.width*0.6867412,size.height*0.5826273,size.width*0.6877206,size.height*0.5818182);
//     path_1.lineTo(size.width*0.6930147,size.height*0.5984848);
//     path_1.close();
//     path_1.moveTo(size.width*0.7815941,size.height*0.6090909);
//     path_1.cubicTo(size.width*0.7706147,size.height*0.6090909,size.width*0.7604176,size.height*0.6069697,size.width*0.7510059,size.height*0.6027273);
//     path_1.cubicTo(size.width*0.7415941,size.height*0.5982818,size.width*0.7334588,size.height*0.5923242,size.width*0.7265941,size.height*0.5848485);
//     path_1.cubicTo(size.width*0.7197324,size.height*0.5771727,size.width*0.7143412,size.height*0.5683848,size.width*0.7104176,size.height*0.5584848);
//     path_1.cubicTo(size.width*0.7066941,size.height*0.5485848,size.width*0.7048294,size.height*0.5379788,size.width*0.7048294,size.height*0.5266667);
//     path_1.cubicTo(size.width*0.7048294,size.height*0.5119182,size.width*0.7080647,size.height*0.4983848,size.width*0.7145353,size.height*0.4860606);
//     path_1.cubicTo(size.width*0.7212029,size.height*0.4737364,size.width*0.7303206,size.height*0.4639394,size.width*0.7418882,size.height*0.4566667);
//     path_1.cubicTo(size.width*0.7534588,size.height*0.4491909,size.width*0.7665941,size.height*0.4454545,size.width*0.7813000,size.height*0.4454545);
//     path_1.cubicTo(size.width*0.7964000,size.height*0.4454545,size.width*0.8095353,size.height*0.4491909,size.width*0.8207118,size.height*0.4566667);
//     path_1.cubicTo(size.width*0.8320853,size.height*0.4641424,size.width*0.8410059,size.height*0.4740394,size.width*0.8474765,size.height*0.4863636);
//     path_1.cubicTo(size.width*0.8539471,size.height*0.4984848,size.width*0.8571824,size.height*0.5118182,size.width*0.8571824,size.height*0.5263636);
//     path_1.cubicTo(size.width*0.8571824,size.height*0.5279788,size.width*0.8571824,size.height*0.5295970,size.width*0.8571824,size.height*0.5312121);
//     path_1.cubicTo(size.width*0.8571824,size.height*0.5326273,size.width*0.8570853,size.height*0.5337364,size.width*0.8568882,size.height*0.5345455);
//     path_1.lineTo(size.width*0.7257118,size.height*0.5345455);
//     path_1.cubicTo(size.width*0.7266941,size.height*0.5458576,size.width*0.7297324,size.height*0.5559606,size.width*0.7348294,size.height*0.5648485);
//     path_1.cubicTo(size.width*0.7401235,size.height*0.5735364,size.width*0.7468882,size.height*0.5805061,size.width*0.7551235,size.height*0.5857576);
//     path_1.cubicTo(size.width*0.7635559,size.height*0.5908091,size.width*0.7726735,size.height*0.5933333,size.width*0.7824765,size.height*0.5933333);
//     path_1.cubicTo(size.width*0.7924765,size.height*0.5933333,size.width*0.8018882,size.height*0.5907061,size.width*0.8107118,size.height*0.5854545);
//     path_1.cubicTo(size.width*0.8197324,size.height*0.5802030,size.width*0.8260059,size.height*0.5733333,size.width*0.8295353,size.height*0.5648485);
//     path_1.lineTo(size.width*0.8468882,size.height*0.5696970);
//     path_1.cubicTo(size.width*0.8437529,size.height*0.5771727,size.width*0.8389471,size.height*0.5839394,size.width*0.8324765,size.height*0.5900000);
//     path_1.cubicTo(size.width*0.8260059,size.height*0.5960606,size.width*0.8183588,size.height*0.6008091,size.width*0.8095353,size.height*0.6042424);
//     path_1.cubicTo(size.width*0.8009088,size.height*0.6074758,size.width*0.7915941,size.height*0.6090909,size.width*0.7815941,size.height*0.6090909);
//     path_1.close();
//     path_1.moveTo(size.width*0.7251235,size.height*0.5196970);
//     path_1.lineTo(size.width*0.8383588,size.height*0.5196970);
//     path_1.cubicTo(size.width*0.8375765,size.height*0.5081818,size.width*0.8345353,size.height*0.4980818,size.width*0.8292412,size.height*0.4893939);
//     path_1.cubicTo(size.width*0.8241441,size.height*0.4807061,size.width*0.8173794,size.height*0.4739394,size.width*0.8089471,size.height*0.4690909);
//     path_1.cubicTo(size.width*0.8007118,size.height*0.4640394,size.width*0.7915941,size.height*0.4615152,size.width*0.7815941,size.height*0.4615152);
//     path_1.cubicTo(size.width*0.7715941,size.height*0.4615152,size.width*0.7624765,size.height*0.4640394,size.width*0.7542412,size.height*0.4690909);
//     path_1.cubicTo(size.width*0.7460059,size.height*0.4739394,size.width*0.7392412,size.height*0.4808091,size.width*0.7339471,size.height*0.4896970);
//     path_1.cubicTo(size.width*0.7288500,size.height*0.4983848,size.width*0.7259088,size.height*0.5083848,size.width*0.7251235,size.height*0.5196970);
//     path_1.close();
//     path_1.moveTo(size.width*0.9645118,size.height*0.4663636);
//     path_1.cubicTo(size.width*0.9511765,size.height*0.4667667,size.width*0.9394118,size.height*0.4706061,size.width*0.9292176,size.height*0.4778788);
//     path_1.cubicTo(size.width*0.9192176,size.height*0.4851515,size.width*0.9121588,size.height*0.4951515,size.width*0.9080412,size.height*0.5078788);
//     path_1.lineTo(size.width*0.9080412,size.height*0.6060606);
//     path_1.lineTo(size.width*0.8880412,size.height*0.6060606);
//     path_1.lineTo(size.width*0.8880412,size.height*0.4481818);
//     path_1.lineTo(size.width*0.9068647,size.height*0.4481818);
//     path_1.lineTo(size.width*0.9068647,size.height*0.4860606);
//     path_1.cubicTo(size.width*0.9121588,size.height*0.4749485,size.width*0.9191176,size.height*0.4659606,size.width*0.9277471,size.height*0.4590909);
//     path_1.cubicTo(size.width*0.9365706,size.height*0.4522212,size.width*0.9458824,size.height*0.4483848,size.width*0.9556882,size.height*0.4475758);
//     path_1.cubicTo(size.width*0.9576471,size.height*0.4473727,size.width*0.9593147,size.height*0.4472727,size.width*0.9606882,size.height*0.4472727);
//     path_1.cubicTo(size.width*0.9622559,size.height*0.4472727,size.width*0.9635294,size.height*0.4473727,size.width*0.9645118,size.height*0.4475758);
//     path_1.lineTo(size.width*0.9645118,size.height*0.4663636);
//     path_1.close();
//
//     Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
//     paint_1_fill.color = Colors.white.withOpacity(1.0);
//     canvas.drawPath(path_1,paint_1_fill);
//
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }