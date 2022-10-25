import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetBuildings extends StatelessWidget {
  final String buildingId;

  GetBuildings({required this.buildingId});

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

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${data['Name']}',
                  style: GoogleFonts.raleway(
                    color: const Color(0xffB62B37),
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
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
