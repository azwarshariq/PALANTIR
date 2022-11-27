import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:palantir_ips/pages/view_screen.dart';
import 'package:palantir_ips/pages/storage_service.dart';
import 'package:flutter/material.dart';

import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/router_class.dart';
import '../classes/user_class.dart';

class UploadRedirectScreen extends StatefulWidget {
  UploadRedirectScreen({
    Key? key,
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
  }): super(key: key);

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
  _MyUploadRedirectScreenState createState() => _MyUploadRedirectScreenState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
  );
}

class _MyUploadRedirectScreenState extends State<UploadRedirectScreen> {

  _MyUploadRedirectScreenState(
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

  List<buildingObject> buildingInstances = [];
  List<floorObject> floorInstances = [];
  List<routerObject> routerInstances = [];

  List<DropdownMenuItem<String>> get dropdownBuildingItems{
    List<DropdownMenuItem<String>> menuItems = [];
    for (int i=0; i<buildingInstances.length; i++){
      if (buildingInstances[i].userRef == userInstance.referenceId){
        menuItems.add(
          DropdownMenuItem(
            child: Text(
              buildingInstances[i].buildingName,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 18
              ),
            ),
            value: buildingInstances[i].buildingName
          )
        );
      }
    }
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownFloorItems{
    List<DropdownMenuItem<String>> menuItems = [];
    for (int i=0; i<floorInstances.length; i++){
      if (floorInstances[i].buildingRef == currentBuilding.buildingName){
        menuItems.add(
            DropdownMenuItem(
                child: Text(
                  floorInstances[i].floorName,
                  style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 18
                  ),
                ),
                value: floorInstances[i].floorName
            )
        );
      }
    }
    return menuItems;
  }

  String dropdownBuildingValue = 'Choose Building';

  String dropdownFloorValue = 'Choose Floor';

  final Storage storage = Storage();

  buildingObject setCurrentBuilding(String buildingName){
    for(int i=0; i<buildingInstances.length; i++){
      if(buildingInstances[i].buildingName == buildingName){
        return buildingInstances[i];
      }
    }

    return new buildingObject(
        "",
        "-",
        "",
        0
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff100D49),
        elevation: 10,
      ),
      backgroundColor: const Color(0xff100D49),
      body: Container(
          padding: const EdgeInsets.only(left: 60, right: 40, top: 0),
          child: Form(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Select Building",
                      style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xffB62B37),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                      width: 220,
                    ),

                    DropdownButton(
                      value: dropdownBuildingValue,
                      icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                      items: dropdownBuildingItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownBuildingValue = newValue!;
                          currentBuilding = setCurrentBuilding(dropdownBuildingValue);
                        });
                      },
                      dropdownColor: Colors.white60,
                    ),

                    const SizedBox(height: 100),

                    const Text(
                      "Select Floor",
                      style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xffB62B37),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                      width: 220,
                    ),

                    DropdownButton(
                      value: dropdownFloorValue,
                      icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                      items: dropdownFloorItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownFloorValue = newValue!;
                        });
                      },
                      dropdownColor: Colors.white60,
                    ),

                    const SizedBox(height: 200),

                    const Text(
                      "Upload Image",
                      style: TextStyle(
                        fontSize: 21,
                        color: const Color(0xffB62B37),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      //Add Button
                      radius: 35.0,
                      backgroundColor: const Color(0xFFCD4F69),
                      child: IconButton(
                        icon: Icon(Icons.cloud_upload_outlined),
                        color: Color.fromARGB(255, 255, 254, 254),
                        iconSize: 30,
                        splashColor: const Color(0xDACD4F69),
                        splashRadius: 45,
                        onPressed: () async {
                          XFile? file = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (file != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewScreen(
                                selectedImage: file.path,
                                userInstance: this.userInstance,
                                buildingInstances: this.buildingInstances,
                                floorInstances: this.floorInstances,
                                routerInstances: this.routerInstances,
                                currentBuilding: this.currentBuilding
                              ),
                            ),
                          );
                        }

                        if (file == null) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('No file selected!')));
                        }
                        final path = file!.path;
                        final name = file.name;

                        print("Path: " + path);
                        print("Name: " + name);

                        storage
                            .uploadFile(path, name)
                            .then((value) => print('Done'));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}