import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../classes/floor_class.dart';

class GetFloors extends StatelessWidget {
  final String floorId;

  GetFloors({required this.floorId});

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
                data['numRouters']
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${floorInstance.floorName},' +
                      ' with ${floorInstance.numRouters} routers',
                  style: GoogleFonts.raleway(
                    color: const Color(0xffB62B37),
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                ),
/*
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
                                  title: GetFloors(routerId: routerDocReference[index]),
                                ),
                              );
                            }
                        );
                      }
                  ),
                ),
*/
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
