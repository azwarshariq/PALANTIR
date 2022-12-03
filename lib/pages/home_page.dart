import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/classes/building_class.dart';
import 'package:palantir_ips/pages/controller_screen.dart';
import 'package:palantir_ips/read_data/get_user_name.dart';
import '../classes/floor_class.dart';
import '../classes/router_class.dart';
import '../classes/user_class.dart';
import '../user/locate_me_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser!;

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

  String userDocReference = '';

  //Get IDs
  Future getDocID() async{
    print('User: ' + user.email!);
    try {
      await FirebaseFirestore.instance.collection('Users')
          .where('email', isEqualTo: user.email!)
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
                (element) {
              print(element.reference);
              userDocReference = element.reference.id;
            }
        ),
      );
    } catch(e) {
      return Text(
        'Loading...',
        style: GoogleFonts.raleway(
          color: const Color(0xffB62B37),
          fontWeight: FontWeight.w300,
          fontSize: 20,
        ),
      );
    };

    print(userDocReference);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/Home Page.png"),
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        appBar: AppBar(
          // Show credentials
          title: Text(
            'Welcome back',
            style: GoogleFonts.raleway(
              color: const Color(0xff100D49),
              fontWeight: FontWeight.w200,
              fontSize: 25,
            ),
          ),
          backgroundColor: const Color(0xffB62B37),
          elevation: 10,
          toolbarOpacity: 0.9,
          shadowColor: const Color(0xff100D49),
          actions: [
            GestureDetector(
              child: Icon(
                Icons.logout_rounded,
                color: const Color(0xff100D49),
                size: 36,
              ),
              onTap: (){
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
        backgroundColor: Colors.black54,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Expanded(
                child: FutureBuilder(
                  future: getDocID(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          try{
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: GetUserName(
                                  documentId: userDocReference,
                                  email: user.email!,
                                  userInstance: userInstance,
                                  buildingInstances: buildingInstances,
                                  floorInstances: floorInstances,
                                  routerInstances: routerInstances,
                                ),
                              ),
                            );
                          }catch(e){
                            return Text(
                              '${e}',
                              style: GoogleFonts.raleway(
                                color: const Color(0xffB62B37),
                                fontWeight: FontWeight.w200,
                                fontSize: 20,
                              ),
                            );
                          };
                        }
                    );


                  }
                ),
              ),
/*
              Text(
                'User: ' + userInstance.firstName + ' ' + userInstance.lastName
                + '\nBuildings: ${buildingInstances.length}'
                + '\nFloors: ${floorInstances.length}'
                + '\nRouters: ${routerInstances.length}',

                style: GoogleFonts.raleway(
                  color: const Color(0xffB62B37),
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),
              ),
*/
              SizedBox(height:30,),

              // Button to proceed as Mapper
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                  .push(
                  MaterialPageRoute(
                    builder: (context) => Controller(
                      userInstance: userInstance,
                      buildingInstances: buildingInstances,
                      floorInstances: floorInstances,
                      routerInstances: routerInstances,
                    )
                  )
                ),
                style: ElevatedButton.styleFrom(
                  animationDuration: const Duration(seconds: 1),
                  shape: RoundedRectangleBorder(
                    //to set border radius to button
                      borderRadius: BorderRadius.circular(20)
                  ),
                  backgroundColor: const Color(0xFFCD4F69),
                  shadowColor: Color(0xFFCD4F69),
                ),
                child: Text(
                  'Proceed As Mapper',
                  style: GoogleFonts.raleway(
                    color: Colors.white60,
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                ),
              ),

              SizedBox(height:30),

              // Button to proceed as User
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .push(
                    MaterialPageRoute(
                        builder: (context) => LocateMeScreen()
                        )
                    ),


                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    //to set border radius to button
                      borderRadius: BorderRadius.circular(20)
                  ),
                  backgroundColor: const Color(0xFFCD4F69),
                  shadowColor: Color(0xFFCD4F69),
                ),
                child: Text(
                  'Proceed As User',
                  style: GoogleFonts.raleway(
                    color: Colors.white60,
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                ),
              ),

              SizedBox(height:30,),
            ],
          )
        ),
      ),
    );
  }
}
