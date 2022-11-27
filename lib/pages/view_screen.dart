import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palantir_ips/pages/edit_demo_screen.dart';
import 'package:palantir_ips/pages/edit_screen.dart';
import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/router_class.dart';
import '../classes/user_class.dart';
import 'upload_screen.dart';

class ViewScreen extends StatefulWidget {
  ViewScreen({
    Key? key,
    required this.selectedImage,
    this.file,
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding
  }):super(key: key);
  final XFile? file;
  final String selectedImage;

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
  _ViewScreenState createState() => _ViewScreenState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding
  );
}

class _ViewScreenState extends State<ViewScreen> {

  _ViewScreenState(
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
                    widget.selectedImage,
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
                                  ))),
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
                          onPressed: ()  => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditDemoScreen(
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