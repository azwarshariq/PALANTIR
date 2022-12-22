import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../classes/router_class.dart';
import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/user_class.dart';
import 'get_routers.dart';

class GetFloors extends StatelessWidget {
  final String floorId;

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

  GetFloors(
      {
        required this.floorId,
        required this.userInstance,
        required this.buildingInstances,
        required this.floorInstances,
        required this.routerInstances
      }
    );

  List<String> routerDocReference = [];

  //Get IDs
  Future getRouterDocID() async{
    print('Floor Reference: ' + floorId);

    try{
      await FirebaseFirestore.instance.collection('Routers')
          .where('floorRef', isEqualTo: this.floorId!)
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
                (element) {
              print(element.reference);
              routerDocReference.add(element.reference.id);
            }
        ),
      );
    } catch(e) {
      return Text(
        'Loading...',
        style: GoogleFonts.raleway(
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w200,
          fontSize: 20,
        ),
      );
    };

    print('Router References:');
    for(int i=0; i<2; i++){
      print(routerDocReference[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference Floors = FirebaseFirestore.instance.collection('Floors');
    return SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot>(
        future: Floors.doc(floorId).get(),
        builder: ((context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            final floorInstance = new floorObject(
                floorId,
                data['floorName'],
                data['buildingRef'],
                data['numRouters'],
                '-'
            );

            floorInstances.add(floorInstance);

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
                Flexible(
                  child: FutureBuilder(
                    future: getRouterDocID(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: routerDocReference.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: GetRouters(
                                routerId: routerDocReference[index],
                                userInstance: userInstance,
                                buildingInstances: buildingInstances,
                                floorInstances: floorInstances,
                                routerInstances: routerInstances,
                              ),
                            ),
                          );
                        }
                      );
                    }
                  ),
                ),

              ],
            );
          }
          else {
            return Text(
              '',
              style: GoogleFonts.raleway(
                color: const Color(0xffffffff),
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
