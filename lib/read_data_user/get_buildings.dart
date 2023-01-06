import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:palantir_ips/read_data_user/get_floors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../classes/router_class.dart';
import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/user_class.dart';

class GetBuildings extends StatelessWidget {
  final String buildingId;

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

  GetBuildings(
      {
        required this.buildingId,
        required this.userInstance,
        required this.buildingInstances,
        required this.floorInstances,
        required this.routerInstances
      }
    );

  List<String> floorDocReference = [];

  //Get IDs
  Future getFloorDocID() async{
    print('Building Reference: ' + buildingId);

    try{
      await FirebaseFirestore.instance.collection('Floors')
          .where('buildingRef', isEqualTo: buildingId)
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
                (element) {
              print(element.reference);
              floorDocReference.add(element.reference.id);
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

    print('Floor References:');
    for(int i=0; i<floorDocReference.length; i++){
      print(floorDocReference[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference Buildings = FirebaseFirestore.instance.collection('Buildings');

    return SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot>(
        future: Buildings.doc(buildingId).get(),
        builder: ((context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            final buildingInstance = new buildingObject(
              buildingId,
              data['Name'],
              data['userRef'],
              data['numFloors']
            );

            buildingInstances.add(buildingInstance);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${buildingInstance.buildingName}',
                  style: GoogleFonts.raleway(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w200,
                    fontSize: 30,
                  ),
                ),

                Flexible(
                  child: FutureBuilder(
                      future: getFloorDocID(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: floorDocReference.length,
                            itemBuilder: (context, index) {

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: GetFloors(
                                    floorId: floorDocReference[index],
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
              'Loading...',
              style: GoogleFonts.raleway(
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w200,
                fontSize: 20,
              ),
            );
          }
        }
        ),
      ),
    );
  }
}
