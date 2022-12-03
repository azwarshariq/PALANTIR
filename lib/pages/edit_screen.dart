import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../classes/building_class.dart';
import '../classes/elevators_class.dart';
import '../classes/floor_class.dart';
import '../classes/room_class.dart';
import '../classes/router_class.dart';
import '../classes/stairs_class.dart';
import '../classes/user_class.dart';
import 'collect_data_screen.dart';
import 'hero_dialog_route.dart';

class EditScreen extends StatefulWidget {

  EditScreen({
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
  State<EditScreen> createState() => _EditScreenState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
    this.currentBuilding,
    this.currentFloor
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

List<String> listOfBSSIDs = [];

List<String> listOfRouters = [];
List<String> listOfRooms = [];
List<String> listOfStairs = [];
List<String> listOfElevators = [];
List<String> types = [];

class _EditScreenState extends State<EditScreen> {

  _EditScreenState(
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
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  Offset? _tapPosition;
  String _value = "";

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
      //
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff100D49),
          elevation: 10,
        ),
        backgroundColor: Color(0xff100D49),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Container(
                      child: Image.asset(
                        'assets/floorplan.jpeg',
                        height: MediaQuery.of(context).size.height * 0.70,
                        width: MediaQuery.of(context).size.width * 0.9,
                        //fit: BoxFit.fitWidth,
                      )
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
                          color: Color.fromARGB(207, 255, 255, 255),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)
                          ),
                          child: const Icon(
                            Icons.add_circle_rounded,
                            size: 56,
                            color: Color(0xffB62B37),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                    ),

                    PopupMenuButton(
                      child: Material(
                        color: Color.fromARGB(198, 255, 255, 255),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                        child: const Icon(
                          Icons.delete_rounded,
                          size: 56,
                          color: Color(0xffB62B37),
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
                              builder: (context) => CollectDataScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
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
                        color: Color.fromARGB(255, 156, 154, 154),
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
      )
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

const String _heroAddMacAddress = 'add-mac-hero';

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
                                        listOfElevators.add(elevatorID),
                                        types.add("Elevator"),
                                        elevatorID = "",
                                      }
                                  }
                              }
                          }
                      },



                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffB62B37) // Background color
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

const String _heroDeleteMacAddress = 'delete-mac-hero';

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
                      color: Color(0xffB62B37),
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
