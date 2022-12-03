import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palantir_ips/pages/edit_demo_screen.dart';
import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/router_class.dart';
import '../classes/user_class.dart';
import 'upload_screen.dart';

class ViewScreen extends StatefulWidget {
  ViewScreen({
    Key? key,
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding,
    required this.currentFloor,
    this.file,
  }):super(key: key);

  final XFile? file;

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
  _ViewScreenState createState() => _ViewScreenState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
    this.currentBuilding,
    this.currentFloor,
    this.file
  );
}

class _ViewScreenState extends State<ViewScreen> {

  _ViewScreenState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
    this.currentBuilding,
    this.currentFloor,
    this.file
  );

  final XFile? file;

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

  Future addFloorPlan(String floorName) async {
    // Getting Floor using it's document id (buildingName+floorName)
    // We need it to access the relevant floor
    // In which we can add the name of the floorPlan image, as stored in Storage
    await FirebaseFirestore.instance.collection('Floors')
        .doc(currentBuilding.buildingName + floorName)
        .update({'floorPlan' : this.file!.name}) // <-- Updated data
        .then((_) => print('Added image path to Floor document'))
        .catchError((error) => print('Update failed: $error'));

    // Making the relevant change in the class objects
    for (int i=0; i<floorInstances.length; i++){
      if (floorInstances[i].floorName == floorName){
        floorInstances[i].floorPlan == this.file!.name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xff100D49),
        elevation: 10,
        shadowColor: const Color(0xffB62B37),
      ),
      backgroundColor:const Color(0xff100D49),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
              [
                Image.file(
                  File(
                    widget.file!.path,
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        //Edit Button
                        radius: 40.0,
                        backgroundColor: const Color(0xffB62B37),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.white60,
                          iconSize: 40,
                          splashColor: const Color(0xFFCD4F69),
                          splashRadius: 45,
                          onPressed:() => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UploadScreen(
                                userInstance: this.userInstance,
                                buildingInstances: this.buildingInstances,
                                floorInstances: this.floorInstances,
                                routerInstances: this.routerInstances,
                                currentBuilding: this.currentBuilding
                              )
                            )
                          ),
                        ),
                      ),

                      const SizedBox(width: 50),

                      CircleAvatar(
                        //Edit Button
                        radius: 40.0,
                        backgroundColor: const Color(0xffB62B37),
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.white60,
                          iconSize: 30,
                          splashColor: const Color(0xFFCD4F69),
                          splashRadius: 45,
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditDemoScreen(
                                    userInstance: this.userInstance,
                                    buildingInstances: this.buildingInstances,
                                    floorInstances: this.floorInstances,
                                    routerInstances: this.routerInstances,
                                    currentBuilding: this.currentBuilding,
                                    currentFloor: this.currentFloor,
                                )
                              ),
                            ),
                            addFloorPlan(currentFloor.floorName),
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                // ignore: avoid_print
              ]
            ),
          ),
        ),
      ),
    );
  }
}