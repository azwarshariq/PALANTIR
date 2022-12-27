import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/classes/building_class.dart';
import 'package:palantir_ips/pages/mapper/controller_screen.dart';
import 'package:palantir_ips/read_data/get_user_name.dart';
import '../auth/auth_page.dart';
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
          color: Colors.white,
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
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            toolbarHeight: 70,
            title: Text(
              'Palantir',
              style: GoogleFonts.raleway(
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w300,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                  image: DecorationImage(
                      image: AssetImage("assets/elements/AppBar Edit.png"),
                      fit: BoxFit.cover
                  ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              )
            ],
          ),

            body: Center(
            child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Container(
                  height: 450,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/backgrounds/Controller Screen.png"),
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey, //New
                          blurRadius: 5.0,
                          offset: Offset(0, -1))
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 40),
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 50),
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
                                padding: const EdgeInsets.all(0.0),
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
                                'Loading...',
                                style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 35,
                                ),
                              );
                            }
                          }
                        );
                      }
                    ),

                ),

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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Color(0xFF4EBEA7),
                    shadowColor: Color(0xAA4EBEA7),
                    padding: EdgeInsets.all(20),
                  ),

                  child: Text(
                    'Proceed As Mapper',
                    style: GoogleFonts.raleway(
                      color: Colors.white,
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
                          builder: (context) => LocateMeScreen(
                            userInstance: userInstance,
                            buildingInstances: buildingInstances,
                            floorInstances: floorInstances,
                            routerInstances: routerInstances,
                          )
                      )
                  ),

                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      //to set border radius to button
                        borderRadius: BorderRadius.circular(20)
                    ),
                    backgroundColor: const Color(0xFF739DC7),
                    shadowColor: Color(0xAA739DC7),
                    padding: EdgeInsets.all(20),
                  ),
                  child: Text(
                    'Proceed As User',
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height:30,),
              ],
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
  */        ),
          ),

      ),
    );
  }
}