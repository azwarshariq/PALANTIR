import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/read_data/get_buildings.dart';

class GetUserName extends StatelessWidget {
  final String documentId;
  final String email;

  GetUserName({required this.documentId, required this.email});

  List<String> buildingDocReference = [];

  //Get IDs
  Future getBuildingDocID() async{
    print('User Reference: ' + documentId);
    await FirebaseFirestore.instance.collection('Buildings')
        .where('userRef', isEqualTo: this.documentId!)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
              (element) {
            print(element.reference);
            buildingDocReference.add(element.reference.id);
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference Users = FirebaseFirestore.instance.collection('Users');

    return SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot>(
        future: Users.doc(documentId).get(),
        builder: ((context, snapshot)
          {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

              List buildings = data['listOfBuildings'];

              if(data['email'] == this.email) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome, ${data['firstName']} ${data['lastName']}',
                      style: GoogleFonts.raleway(
                        color: const Color(0xffB62B37),
                        fontWeight: FontWeight.w200,
                        fontSize: 20,
                      ),
                    ),

                    Flexible(
                      child: FutureBuilder(
                        future: getBuildingDocID(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: buildings.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: GetBuildings(buildingId: buildingDocReference[index]!),
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
                  'Not This User',
                  style: GoogleFonts.raleway(
                    color: const Color(0xffB62B37),
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                );
              }
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
        )
      ),
    );
  }
}
