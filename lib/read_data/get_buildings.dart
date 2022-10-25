import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../classes/building_class.dart';
import 'get_floors.dart';

class GetBuildings extends StatelessWidget {
  final String buildingId;

  GetBuildings({required this.buildingId});

  List<String> floorDocReference = [];

  //Get IDs
  Future getFloorDocID() async{
    print('Building Reference: ' + buildingId);
    await FirebaseFirestore.instance.collection('Floors')
        .where('buildingRef', isEqualTo: this.buildingId!)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
              (element) {
            print(element.reference);
            floorDocReference.add(element.reference.id);
          }
      ),
    );
    print('Floor References:');
    for(int i=0; i<2; i++){
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

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${buildingInstance.buildingName},' +
                  ' which has ${buildingInstance.numFloors} floors:',
                  style: GoogleFonts.raleway(
                    color: const Color(0xffB62B37),
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
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
                                  title: GetFloors(floorId: floorDocReference[index]),
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
                color: const Color(0xffB62B37),
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
