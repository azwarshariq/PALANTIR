import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetUserName extends StatelessWidget {
  final String documentId;
  final String email;

  GetUserName({required this.documentId, required this.email});

  @override
  Widget build(BuildContext context) {

    CollectionReference Users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: Users.doc(documentId).get(),
      builder: ((context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            if(data['email'] == this.email) {
              return Text(
                '${data['firstName']} ${data['lastName']}' +
                    '\n Mapped Buildings:\n' +
                    '${data['listOfBuildings']}',
                style: GoogleFonts.raleway(
                  color: const Color(0xffB62B37),
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),
              );
            }
            else {
              return Text(
                'Not this user',
                style: GoogleFonts.raleway(
                  color: const Color(0xffB62B37),
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),
              );
            }
          }
          else {
            return SizedBox.shrink();
          }
        }
      )
    );
  }
}
