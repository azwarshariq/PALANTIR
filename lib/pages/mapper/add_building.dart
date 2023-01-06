import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:palantir_ips/pages/mapper/upload%20screens/upload_screen.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../classes/building_class.dart';
import '../../classes/floor_class.dart';
import '../../classes/router_class.dart';
import '../../classes/user_class.dart';
import '../../main/home_page.dart';



class AddBuilding extends StatefulWidget {

  AddBuilding({
    super.key,
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances
  });

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
  State<AddBuilding> createState() => _AddBuildingState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances
  );
}

class _AddBuildingState extends State<AddBuilding> {

  _AddBuildingState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances
      );

  String userRef = "";
  final _NameController = TextEditingController();
  final _numFloorsController = TextEditingController();
  buildingObject buildingInstance = new buildingObject("", "", "", 0);

  Future addBuildingInfo() async {
    // Getting user id through currently logged in email
    // We need it to access the relevant buildings
    await FirebaseFirestore.instance.collection('Users')
        .where('email', isEqualTo:FirebaseAuth.instance.currentUser!.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
              (element) {
            print(element.reference);
            this.userRef = element.reference.id;
            print(userRef);
          }
      ),
    );

    // To create a new Building, Floor, Room, or Router we'll follow three steps

    // 1. Creating a Building Instance in our Class
    this.buildingInstance.setValues(
      _NameController.text.trim(),
      _NameController.text.trim(),
      this.userRef,
      int.parse(_numFloorsController.text.trim()),
    );

    // 2. Adding the created Building class instance into list of buildingInstances
    buildingInstances.add(buildingInstance);

    // 3. Creating new Buildings Collection document (using name as id)
    addBuildingDocument(
      _NameController.text.trim(),
      int.parse(_numFloorsController.text.trim()),
      this.userRef,
    );

    // Creating (numFloors) number of floors in a loop
    // referenceId is going to be as BuildingFloor i
    // Name will be Floor i
    // numRouters for now will be 0
    for (int i=0; i<int.parse(_numFloorsController.text.trim()); i++){
      // 0th Floor is Ground, rest are numbered
      if(i == 0){
        // 1. Creating a floor instance for our class
        final floorInstance = new floorObject(
            _NameController.text.trim() + 'Ground Floor',
            'Ground Floor',
            _NameController.text.trim(),
            0,
            '',
            0
        );

        // 2. Adding the created Floor class instance into list of buildingInstances
        floorInstances.add(floorInstance);

        // 3. Creating a new Floors collection document
        addFloorDocument(
            _NameController.text.trim(),
            'Ground Floor',
            _NameController.text.trim(),
            0
        );
      }
      else {
        // 1. Creating a floor instance for our class
        final floorInstance = new floorObject(
            _NameController.text.trim() + 'Floor ' + i.toString(),
            'Floor ' + i.toString(),
            _NameController.text.trim(),
            0,
            '',
            0
        );

        // 2. Adding the created Floor class instance into list of buildingInstances
        floorInstances.add(floorInstance);

        // 3. Creating a new Floors collection document
        addFloorDocument(
            _NameController.text.trim(),
            'Floor '+ i.toString(),
            _NameController.text.trim(),
            0
        );
      }
    }

  }

  //Initialise the all Instances of classes being used in this page
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

  final formKey = GlobalKey<FormState>(); //key for form
  String name = "";

  Future addBuildingDocument(String Name, int numFloors, String userRef) async {
    await FirebaseFirestore.instance.collection('Buildings')
    .doc(Name) // <-- Document ID
    .set({
        'Name': Name,
        'numFloors': numFloors,
        'userRef': userRef
        }) // <-- Your data
    .then((_) => print('Added Building ' + Name + ' with userRef ' + userRef))
    .catchError((error) => print('Add failed: $error'));
  }

  Future addFloorDocument(String buildingName, String Name, String buildingRef, int numRouters) async {
    await FirebaseFirestore.instance.collection('Floors')
    .doc(buildingName + Name) // <-- Document ID
    .set({
        'floorName': Name,
        'buildingRef': buildingRef,
        'numRouters': numRouters,
        'floorPlan' : '',
        'collectedDataPoints': 0
      }) // <-- Your data
    .then((_) => print('Added ' + Name + ' with buildingRef ' + buildingRef))
    .catchError((error) => print('Add failed: $error')
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/elements/AppBar AddBuilding.png'),
          fit: BoxFit.cover,
        ),
        iconTheme: IconThemeData(
          color: const Color(0xff325E89), //change your color here
        ),
        elevation: 0,
        title: Text(
          'Add Building',
          style: GoogleFonts.raleway(
          color: const Color(0xff325E89),
          fontWeight: FontWeight.w400,
          fontSize: 20,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home_filled,
              color: const Color(0xff325E89),
            ),
            onPressed: () => Navigator.of(context)
                .push(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                )
            ),

          )
        ],

        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: const Color(0x00ffffff),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/elements/AddBuilding Hero.png"),
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
        padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
        margin: const EdgeInsets.fromLTRB(20, 40, 20, 80),

        child: Form(
          key: formKey, //key for form
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.04),
                Text(
                  "Enter some details of the building you want to map:",
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                  ),
                ),

                SizedBox(
                  height: height * 0.05,
                ),

                TextFormField(
                  controller: _NameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xffB62B37)),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Enter Name of Building",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                TextFormField(
                  controller: _numFloorsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xffB62B37)),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Enter the number of floors it has",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),

                SizedBox(
                  height: height * 0.05,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      "Submit Building Info",
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),

                    FloatingActionButton(
                      child: Icon(Icons.save),
                      splashColor:  Color(0x88A11C44),
                      heroTag: 'btn1',
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFFA11C44),
                      onPressed: () => {
                        addBuildingInfo(),
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Building Successfully Added',
                                style: GoogleFonts.raleway(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              )
                            )
                        ),
                      }
                    ),
                  ],
                ),

                SizedBox(height:20),

                FloatingActionButton(
                  child: Icon(Icons.arrow_forward),
                  splashColor:  Color(0x88A11C44),
                  heroTag: 'btn3',
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFFA11C44),
                  onPressed: () => Navigator.of(context)
                    .push(
                    MaterialPageRoute(
                      builder: (context) => UploadScreen(
                        userInstance: this.userInstance,
                        buildingInstances: this.buildingInstances,
                        floorInstances: this.floorInstances,
                        routerInstances: this.routerInstances,
                        currentBuilding: this.buildingInstance
                      ),
                    )
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