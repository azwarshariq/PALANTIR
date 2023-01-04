import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/auth/main_page.dart';
import 'package:palantir_ips/classes/building_class.dart';
import 'package:palantir_ips/pages/mapper/controller_screen.dart';
import 'package:palantir_ips/read_data/get_user_name.dart';
import '../classes/elevators_class.dart';
import '../classes/floor_class.dart';
import '../classes/room_class.dart';
import '../classes/router_class.dart';
import '../classes/stairs_class.dart';
import '../classes/user_class.dart';
import '../pages/mapper/edit screens/hero_dialog_route.dart';
import '../user/controller_screen_user.dart';
import '../user/locate_me_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser!;

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

  String userDocReference = '';

  //Get IDs
  Future getDocID() async{
    print('User: ' + user.email!);
    try {
      await FirebaseFirestore.instance.collection('Users')
          .where('email', isEqualTo: user.email!)
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
                (element) {
              print(element.reference);
              userDocReference = element.reference.id;
            }
        ),
      );
    } catch(e) {
      return Text(
        'Loading...',
        style: GoogleFonts.raleway(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          fontSize: 20,
        ),
      );
    };

    print(userDocReference);
  }


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
            SizedBox(height: 30,),
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/backgrounds/Controller Screen.png"),
                  fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, //New
                    blurRadius: 5.0,
                    offset: Offset(0, -1))
                ],
              ),
              padding: const EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 40),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: FutureBuilder(
                  future: getDocID(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        try{
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: ListTile(
                              title: GetUserName(
                                documentId: userDocReference,
                                email: user.email!,
                                userInstance: userInstance,
                                buildingInstances: buildingInstances,
                                floorInstances: floorInstances,
                                routerInstances: routerInstances,
                              ),
                            ),
                          );
                        }catch(e){
                          return Text(
                            'Loading...',
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 35,
                            ),
                          );
                        }
                      }
                    );
                  }
                ),
            ),

            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                      .push(
                      HeroDialogRoute(
                        builder: (context) {
                          return PopUpItemBodyBuilding(
                            userInstance: this.userInstance,
                            buildingInstances: this.buildingInstances,
                            floorInstances: this.floorInstances,
                            routerInstances: this.routerInstances,
                          );
                        }
                      )
                    );
                  },

                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 120,
                    margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/elements/HomePage Buildings Button.png'),
                        fit: BoxFit.fitWidth
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Buildings',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 22,
                      ),
                    ),
                  )

                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                      .push(
                      HeroDialogRoute(
                        builder: (context) {
                          return PopUpItemBodyFloor(
                            userInstance: this.userInstance,
                            buildingInstances: this.buildingInstances,
                            floorInstances: this.floorInstances,
                            routerInstances: this.routerInstances,
                          );
                        }
                      )
                    );
                  },

                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/elements/HomePage Floors Button.png'),
                          fit: BoxFit.fitWidth
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Floors',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 22,
                      ),
                    ),
                  )
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                      .push(
                      HeroDialogRoute(
                        builder: (context) {
                          return PopUpItemBodyRouter(
                            userInstance: this.userInstance,
                            buildingInstances: this.buildingInstances,
                            floorInstances: this.floorInstances,
                            routerInstances: this.routerInstances,
                          );
                        }
                      )
                    );
                  },

                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 120,
                    margin: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/elements/HomePage Routers Button.png'),
                          fit: BoxFit.fitWidth
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                    child: Text(
                      'Routers',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 22,
                      ),
                    ),
                  )
                ),
              ],
            ),

            SizedBox(height: 40,),

            // Button to proceed as Mapper
            ElevatedButton(
              onPressed: () => Navigator.of(context)
                .push(
                MaterialPageRoute(
                    builder: (context) => Controller(
                      userInstance: userInstance,
                      buildingInstances: buildingInstances,
                      floorInstances: floorInstances,
                      routerInstances: routerInstances,
                    )
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
                      builder: (context) => ControllerScreenUser(
                        userInstance: userInstance,
                        buildingInstances: buildingInstances,
                        floorInstances: floorInstances,
                        routerInstances: routerInstances,
                      )
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

class PopUpItemBodyBuilding extends StatefulWidget {

  PopUpItemBodyBuilding({
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
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
      "",
      0
  );
  List<buildingObject> buildingInstances = [];
  List<floorObject> floorInstances = [];
  List<routerObject> routerInstances = [];
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  @override
  State<PopUpItemBodyBuilding> createState() => _PopUpItemBodyBuildingState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
  );
}

class _PopUpItemBodyBuildingState extends State<PopUpItemBodyBuilding> {

  _PopUpItemBodyBuildingState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
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
      "",
      0
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
                title: Text(
                  "${'Building ID: ' + buildingInstances[index].buildingName}",
                  style: GoogleFonts.raleway(
                    color: Color(0xFF204E7A),
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          },
          itemCount: buildingInstances.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}

class PopUpItemBodyFloor extends StatefulWidget {

  PopUpItemBodyFloor({
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
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
      "",
      0
  );
  List<buildingObject> buildingInstances = [];
  List<floorObject> floorInstances = [];
  List<routerObject> routerInstances = [];
  List<roomObject> roomInstances = [];
  List<stairsObject> stairsInstances = [];
  List<elevatorObject> elevatorsInstances = [];

  @override
  State<PopUpItemBodyFloor> createState() => _PopUpItemBodyFloorState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
  );
}

class _PopUpItemBodyFloorState extends State<PopUpItemBodyFloor> {

  _PopUpItemBodyFloorState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
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
      "",
      0
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
                title: Text(
                  "${"Building ID: " + floorInstances[index].buildingRef}",
                  style: GoogleFonts.raleway(
                    color: Color(0xFF204E7A),
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  "${"Floor ID: " + floorInstances[index].floorName}",
                  style: GoogleFonts.raleway(
                    color: Color(0xFF44CDB1),
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          },
          itemCount: floorInstances.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,

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
      "",
      0
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
  );
}

class _PopUpItemBodyRouterState extends State<PopUpItemBodyRouter> {

  _PopUpItemBodyRouterState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
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
      "",
      0
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

  Text getBuildingName(FloorRef){
    for(int i = 0; i<floorInstances.length; i++)
    {
      if (FloorRef == floorInstances[i].referenceId){
        return Text(
          "Building ID: ${floorInstances[i].buildingRef}",
          style: GoogleFonts.raleway(
            color: Color(0xFF204E7A),
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        );
      }
    }
    return Text(
      "Building ID: Not found!",
      style: GoogleFonts.raleway(
        color: Color(0xFF204E7A),
        fontWeight: FontWeight.w300,
        fontSize: 20,
      ),
    );
  }

  Text getFloorName(FloorRef){
    for(int i = 0; i<floorInstances.length; i++)
    {
      if (FloorRef == floorInstances[i].referenceId){
        return Text(
          "Floor ID: ${floorInstances[i].floorName}",
          style: GoogleFonts.raleway(
            color: Color(0xFF44CDB1),
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        );
      }
    }
    return Text(
      "Floor ID: Not found!",
      style: GoogleFonts.raleway(
        color: Color(0xFF44CDB1),
        fontWeight: FontWeight.w300,
        fontSize: 20,
      ),
    );
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
                title: getBuildingName(routerInstances[index].floorRef),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getFloorName(routerInstances[index].floorRef),
                    Text(
                      "Router ID: ${routerInstances[index].routerName}",
                      style: GoogleFonts.raleway(
                        color: Color(0xffA11C44),
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "BSSID: ${routerInstances[index].BSSID}",
                      style: GoogleFonts.raleway(
                        color: Color(0xffA11C44),
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: routerInstances.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
