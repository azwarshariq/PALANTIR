import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:palantir_ips/pages/mapper/collect%20data%20screens/collect_data_screen.dart';
import 'package:palantir_ips/pages/mapper/storage_service.dart';
import 'package:palantir_ips/pages/mapper/upload%20screens/upload_screen.dart';

import '../../../classes/building_class.dart';
import '../../../classes/floor_class.dart';
import '../../../classes/router_class.dart';
import '../../../classes/user_class.dart';

class CollectRedirectFloorScreen extends StatefulWidget {
  CollectRedirectFloorScreen({
    Key? key,
    required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances,
    required this.currentBuilding,
  }): super(key: key);

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
  _CollectRedirectFloorScreenState createState() => _CollectRedirectFloorScreenState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances,
      this.currentBuilding
  );
}

class _CollectRedirectFloorScreenState extends State<CollectRedirectFloorScreen> {

  _CollectRedirectFloorScreenState(
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
    "",
    0
  );

  List<buildingObject> buildingInstances = [];
  List<floorObject> floorInstances = [];
  List<routerObject> routerInstances = [];


  final Storage storage = Storage();

  List<String> floorNames = [];
  List<String> floorPlans = [];

  List<String> getFloorDetails(){
    for(int i=0; i<floorInstances.length; i++){
      if(floorInstances[i].buildingRef == currentBuilding.referenceId){
        floorNames.add(floorInstances[i].floorName);
        floorPlans.add(floorInstances[i].floorPlan);
      }
    }
    return floorNames;
  }

  void nextScreen(){
    print(currentFloor.referenceId);
    if(currentFloor.floorPlan != ""){
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CollectDataScreen(
              userInstance: this.userInstance,
              routerInstances: this.routerInstances,
              currentBuilding: this.currentBuilding,
              currentFloor: this.currentFloor,
            ),
          )
      );
    }
    else {
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => UploadScreen(
                  userInstance: this.userInstance,
                  buildingInstances: this.buildingInstances,
                  floorInstances: this.floorInstances,
                  routerInstances: this.routerInstances,
                  currentBuilding: this.currentBuilding)
          )
      );
    }
  }

  Icon nextIcon(String selectedFloor, String selectedFloorPlan){
    if (selectedFloorPlan == ""){
      floorHasPlan = true;
      return Icon(
        Icons.add_photo_alternate_outlined,
        size: 30,
        color: Color(0xff325E89),
      );
    }
    else {
      floorHasPlan = false;
      return Icon(
        Icons.arrow_forward,
        size: 30,
        color: Color(0xff325E89),
      );
    }
  }

  bool floorHasPlan = false;

  Text hasFloorPlan(String selectedFloor, String selectedFloorPlan){
    if (selectedFloorPlan == ""){
      floorHasPlan = true;
      return Text(
        "${selectedFloor} does not have a floor plan!",
        style: GoogleFonts.raleway(
          color: const Color(0xffA11C44),
          fontWeight: FontWeight.w300,
          fontSize: 15,
        ),
      );
    }
    else {
      return Text(
          "Floor Plan found for ${selectedFloor}",
          style: GoogleFonts.raleway(
            color: const Color(0xAA44CDB1),
            fontWeight: FontWeight.w300,
            fontSize: 15,
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getFloorDetails();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/elements/AppBar AddBuilding.png'),
          fit: BoxFit.cover,
        ),
        iconTheme: IconThemeData(
          color: const Color(0xff325E89),
        ),
        elevation: 0,
        title: Text(
          "${ currentBuilding.buildingName + ' - Select Floor'}",
          style: GoogleFonts.raleway(
            color: const Color(0xff325E89),
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,

      body: ListView.builder(
          itemCount: floorNames.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: const Icon(
                  Icons.business,
                  size: 30,
                  color: Color(0xAA44CDB1),
                ),
                trailing: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    for(int i=0; i<floorInstances.length; i++){
                      if (floorInstances[i].floorName == floorNames[index]){
                        this.currentFloor = floorInstances[i];
                      }
                    }
                    nextScreen();
                  },
                  child: nextIcon(floorNames[index], floorPlans[index])
                ),
                title: Text("${floorNames[index]}",
                  style: GoogleFonts.raleway(
                    color: const Color(0xff325E89),
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                subtitle: hasFloorPlan(floorNames[index], floorPlans[index])
            );
          }
      ),
    );
  }
}