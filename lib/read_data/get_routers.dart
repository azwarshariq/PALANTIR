import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../classes/router_class.dart';
import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/user_class.dart';

class GetRouters extends StatelessWidget {
  final String routerId;

  userObject userInstance = new userObject(
      '',
      '',
      '',
      '',
      0
  );

  List<buildingObject> buildingInstances = [];

  List<floorObject> floorInstances = [];

  List<routerObject> routerInstances = [];

  GetRouters(
    {
      required this.routerId,
      required this.userInstance,
      required this.buildingInstances,
      required this.floorInstances,
      required this.routerInstances
    }
  );

  @override
  Widget build(BuildContext context) {
    CollectionReference Routers = FirebaseFirestore.instance.collection('Routers');
    return SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot>(
        future: Routers.doc(routerId).get(),
        builder: ((context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            final routerInstance = new routerObject(
                routerId,
                data['Name'],
                data['floorRef'],
                data['MAC Address']
            );

            routerInstances.add(routerInstance);

            print("User: " + userInstance.firstName);
            print("Buildings:");
            for (int i=0; i<buildingInstances.length; i++){
              print("-> " + buildingInstances[i].buildingName);
            }
            print("Floors:");
            for (int i=0; i<floorInstances.length; i++){
              print("-> " + floorInstances[i].floorName);
            }
            print("Routers:");
            for (int i=0; i<routerInstances.length; i++){
              print("-> " + routerInstances[i].routerName);
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              ],
            );
          }
          else {
            return Text(
              '',
              style: GoogleFonts.raleway(
                color: const Color(0xffB62B37),
                fontWeight: FontWeight.w200,
                fontSize: 5,
              ),
            );
          }
        }
        ),
      ),
    );
  }
}
