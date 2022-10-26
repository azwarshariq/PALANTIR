import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:palantir_ips/pages/upload_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/router_class.dart';
import '../classes/user_class.dart';



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

  final _NameController = TextEditingController();
  final _numFloorsController = TextEditingController();
  final _userRefController = TextEditingController();

  Future addBuildingInfo() async {
    final buildingInstance = new buildingObject(
      _NameController.text.trim(),
      _NameController.text.trim(),
      _userRefController.text.trim(),
      int.parse(_numFloorsController.text.trim()),
    );

    buildingInstances.add(buildingInstance);

    //Add User details
      addBuildingDetails(
        _NameController.text.trim(),
        int.parse(_numFloorsController.text.trim()),
        _userRefController.text.trim(),
      );

    }


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

  CollectionReference Buildings = FirebaseFirestore.instance.collection('Buildings');


  Future addBuildingDetails(String Name, int numFloors, String userRef) async {
    await FirebaseFirestore.instance.collection('Buildings')
        .doc(Name) // <-- Document ID
        .set({
          'Name': Name,
          'numFloors': numFloors,
          'userRef': userRef
        }) // <-- Your data
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor:const Color(0xff100D49),
        elevation: 10,
        shadowColor: const Color(0xffB62B37),
      ),
      backgroundColor:const Color(0xff100D49),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Form(
          key: formKey, //key for form
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.04),
                const Text(
                  "Enter some details of ",
                  style: TextStyle(
                    fontSize: 30,
                    color: const Color(0xffB62B37),
                  ),
                ),
                const Text(
                  "the building you want to map:",
                  style: TextStyle(
                      fontSize: 30,
                      color: const Color(0xffB62B37),
                  ),
                ),

                SizedBox(
                  height: height * 0.05,
                ),

                TextFormField(
                  controller: _NameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white60),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xffB62B37)),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Enter Name of Building",
                    fillColor: Colors.white60,
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
                        borderSide: BorderSide(color: Colors.white60),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xffB62B37)),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    hintText:  "Enter the number of floors it has",
                    fillColor: Colors.white60,
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
                    const Text(
                      "Submit Building Info",
                      style: TextStyle(
                        fontSize: 21,
                        color:const Color(0xffB62B37),
                      ),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.save),
                      backgroundColor:const Color(0xFFCD4F69),
                      foregroundColor: Colors.white,
                      onPressed: addBuildingInfo,
                    ),
                  ],
                ),

                SizedBox(height:20),

                FloatingActionButton(
                  child: Icon(Icons.arrow_forward),
                  backgroundColor:const Color(0xFFCD4F69),
                  foregroundColor: Colors.white,
                  onPressed: () => Navigator.of(context)
                    .push(
                    MaterialPageRoute(
                      builder: (context) => UploadScreen(),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}