import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palantir_ips/pages/view_screen.dart';
import 'package:palantir_ips/pages/storage_service.dart';
import 'package:flutter/material.dart';
import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/router_class.dart';
import '../classes/user_class.dart';

class UploadScreen extends StatefulWidget {

  UploadScreen({
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
  _MyUploadScreenState createState() => _MyUploadScreenState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding
  );
}

class _MyUploadScreenState extends State<UploadScreen> {

  _MyUploadScreenState(
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

   floorObject getCurrentFloor(String floorName) {
    // Getting Current Floor using it's name (floorName)
    // floorName is selected dropdown value
    for (int i=0; i<floorInstances.length; i++){
      if(floorInstances[i].floorName == floorName){
        this.currentFloor = floorInstances[i];
      }
    }
    print("Current Floor is: " + currentFloor.floorName);
    return this.currentFloor;
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [];
    for (int i=0; i<floorInstances.length; i++){
      if (floorInstances[i].buildingRef == currentBuilding.buildingName){
        menuItems.add(
          DropdownMenuItem(
            child: Text(
              floorInstances[i].floorName,
              style: const TextStyle(
                color: Colors.white,
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

  String dropdownValue = 'Ground Floor';

  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/elements/AppBar Upload.png'),
          fit: BoxFit.cover,
        ),
        iconTheme: IconThemeData(
          color: const Color(0xff325E89), //change your color here
        ),
        elevation: 0,
        title: Text(
          'Upload Floorplan',
          style: GoogleFonts.raleway(
            color: const Color(0xff325E89),
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFFF3F4F4),
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select Floor",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                    width: 220,
                  ),

                  DropdownButton(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    dropdownColor: Colors.white60,
                  ),

                  const SizedBox(height: 200),
                  Text(
                    "Upload Image",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                    ),
                  ),

                  const SizedBox(height: 30),

                  CircleAvatar(
                    //Add Button
                    radius: 35.0,
                    backgroundColor: const Color(0xFFFFFFFF),
                    child: IconButton(
                      icon: Icon(Icons.cloud_upload_outlined),
                      color: Color(0xff325E89),
                      iconSize: 30,
                      splashColor: const Color(0xAA325E89),
                      splashRadius: 45,
                      onPressed: () async {
                        XFile? file = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                      );
                      if (file != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewScreen(
                              userInstance: this.userInstance,
                              buildingInstances: this.buildingInstances,
                              floorInstances: this.floorInstances,
                              routerInstances: this.routerInstances,
                              currentBuilding: this.currentBuilding,
                              currentFloor: getCurrentFloor(dropdownValue),
                              file: file,
                            ),
                          ),
                        );
                      }

                      if (file == null) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No file selected!'
                            )
                          )
                        );
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
        )
      ),
    );
  }
}
