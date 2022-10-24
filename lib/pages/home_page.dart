import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/pages/add_building.dart';
import 'package:palantir_ips/read_data/get_user_name.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser!;

  String userDocReference = '';
  List<String> buildingDocReference = [];
  List<String> floorDocReference = [];

  //Get IDs
  Future getDocID() async{
    print('User: ' + user.email!);
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

    print(userDocReference);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Show credentials
        title: Text(
          user.email!,
          style: GoogleFonts.raleway(
            color: const Color(0xffB62B37),
            fontWeight: FontWeight.w200,
            fontSize: 20,
          ),
        ),
        backgroundColor:const Color(0xff100D49),
        elevation: 10,
        actions: [
          GestureDetector(
            child: Icon(
              Icons.logout_rounded,
              color: const Color(0xffB62B37),
              size: 40,
            ),
            onTap: (){
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      backgroundColor: const Color(0xff100D49),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:30,),

              // Button to proceed as Mapper
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                  .push(
                  MaterialPageRoute(
                    builder: (context) => AddBuilding()
                  )
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCD4F69),
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

              SizedBox(height:30,),

              // Button to proceed as User
              ElevatedButton(
                onPressed: null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCD4F69),
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

              Expanded(
                child: FutureBuilder(
                  future: getDocID(),
                  builder: (context, snapshot) {
                    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: GetUserName(documentId: userDocReference, email:user.email!),
                            ),
                          );
                        }
                    );
                  }
                ),
              ),

              SizedBox(height:30,),
            ],
          )
      ),
    );
  }
}
