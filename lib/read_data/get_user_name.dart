import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/read_data/get_buildings.dart';
import 'package:palantir_ips/pages/home_page.dart';
import '../classes/user_class.dart';

class _building {
  List<String> referenceIds = [];
}

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
    print('Building References:');
    for(int i=0; i<2; i++){
      print(buildingDocReference[i]);
    }
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

              final userInstance = new userObject(
                documentId,
                data['email'],
                data['firstName'],
                data['lastName'],
                data['age']
              );

              if(data['email'] == this.email) {

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome, ${userInstance.firstName} ${userInstance.lastName}\n'
                      + 'You\'ve mapped the following buildings:',
                      style: GoogleFonts.raleway(
                        color: const Color(0xffB62B37),
                        fontWeight: FontWeight.w200,
                        fontSize: 25,
                      ),
                    ),

                    Flexible(
                      child: FutureBuilder(
                        future: getBuildingDocID(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: buildingDocReference.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: GetBuildings(buildingId: buildingDocReference[index]),
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
