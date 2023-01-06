import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/read_data/get_buildings.dart';
import '../classes/router_class.dart';
import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/user_class.dart';

class GetUserName extends StatelessWidget {
  final String documentId;

  final String email;

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

  GetUserName(
    {
      required this.documentId,
      required this.email,
      required this.userInstance,
      required this.buildingInstances,
      required this.floorInstances,
      required this.routerInstances
    }
  );

  List<String> buildingDocReferences = [];
  List<String> floorDocReferences = [];
  List<String> routerDocReferences = [];

  //Get Building IDs
  Future getBuildingDocID() async{
    print('User Reference: ' + documentId);
    try{
      await FirebaseFirestore.instance.collection('Buildings')
          .where('userRef', isEqualTo: documentId)
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
                (element) {
              print(element.reference);
              buildingDocReferences.add(element.reference.id);
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
    print('Building References:');
    for(int i=0; i<buildingDocReferences.length; i++){
      print(buildingDocReferences[i]);
    }
  }


  @override
  Widget build(BuildContext context) {

    CollectionReference Users = FirebaseFirestore.instance.collection('Users');
    try{
      return SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
            future: Users.doc(this.documentId).get(),
            builder: ((context, snapshot)
            {
              if (snapshot.connectionState == ConnectionState.done || snapshot.data != null) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                userInstance.setValues(
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
                        'Hello, ${data['firstName']} \nYou\'ve mapped the following buildings: ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w200,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 150,),

                      Flexible(
                        child: FutureBuilder(
                            future: getBuildingDocID(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: buildingDocReferences.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        title: GetBuildings(
                                          buildingId: buildingDocReferences[index],
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
                  return Row (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.10,
                      ),
                      CircularProgressIndicator(
                          backgroundColor: Colors.black26,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                      ),
                      SizedBox(
                          width:MediaQuery.of(context).size.width * 0.10
                      ),
                    ],
                  );
                }
              }
              else {
                return Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.10,
                    ),
                    CircularProgressIndicator(
                        backgroundColor: Colors.black26,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                    ),
                    SizedBox(
                        width:MediaQuery.of(context).size.width * 0.10
                    ),
                  ],
                );
              }
            }
            )
        ),
      );
    }catch(e){
      return Text(
        '...',
        style: GoogleFonts.raleway(
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w200,
          fontSize: 20,
        ),
      );
    }
  }
}
