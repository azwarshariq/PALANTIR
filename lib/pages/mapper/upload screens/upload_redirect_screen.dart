import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/pages/mapper/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:palantir_ips/pages/mapper/upload%20screens/upload_screen.dart';
import '../../../classes/building_class.dart';
import '../../../classes/floor_class.dart';
import '../../../classes/router_class.dart';
import '../../../classes/user_class.dart';

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
  _UploadRedirectScreenState createState() => _UploadRedirectScreenState(
    this.userInstance,
    this.buildingInstances,
    this.floorInstances,
    this.routerInstances,
  );
}

class _UploadRedirectScreenState extends State<UploadRedirectScreen> {

  _UploadRedirectScreenState(
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


  final Storage storage = Storage();

  // buildingObject setCurrentBuilding(String buildingName){
  //   for(int i=0; i<buildingInstances.length; i++){
  //     if(buildingInstances[i].buildingName == buildingName){
  //       return buildingInstances[i];
  //     }
  //   }
  //   return new buildingObject(
  //       "",
  //       "-",
  //       "",
  //       0
  //   );
  // }

  List<String> buildingNames = [];
  List<String> getBuildingNames(){
    for(int i=0; i<buildingInstances.length; i++){
      buildingNames.add(buildingInstances[i].buildingName);
    }
    return buildingNames;
  }

  @override
  Widget build(BuildContext context) {
    getBuildingNames();
    return Scaffold(
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
          'Select Building',
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
          itemCount: buildingNames.length,
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
                    for(int i=0; i<buildingInstances.length; i++){
                      if (buildingInstances[i].buildingName == buildingNames[index]){
                        this.currentBuilding=buildingInstances[i];
                      }
                    }
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UploadScreen(
                            userInstance: this.userInstance,
                            buildingInstances: this.buildingInstances,
                            floorInstances: this.floorInstances,
                            routerInstances: this.routerInstances,
                            currentBuilding: this.currentBuilding,
                          ),
                        )
                    );
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 30,
                    color: Color(0xff325E89),
                  ),
                ),
                title: Text("${buildingNames[index]}",
                  style: GoogleFonts.raleway(
                    color: const Color(0xff325E89),
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                )
            );
          }
      ),
    );
  }
}