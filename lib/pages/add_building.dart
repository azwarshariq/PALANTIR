import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:palantir_ips/pages/upload_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class Building {
  String buildingName = " ";
  int numFloors = 0;
}

class AddBuilding extends StatefulWidget {
  @override
  _AddBuildingState createState() => _AddBuildingState();
}

class _AddBuildingState extends State<AddBuilding> {
  final formKey = GlobalKey<FormState>(); //key for form
  String name = "";
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor:const Color(0xff100D49),
          elevation: 10,
        ),
        backgroundColor:const Color(0xff100D49),
        body: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: formKey, //key for form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.04),
                const Text(
                  "Enter some details of ",
                  style: TextStyle(
                    fontSize: 30,
                    color: const Color(0xffB62B37),
                  ),
                ),
                const Text(
                  "the building you want to map:",
                  style: TextStyle(
                      fontSize: 30,
                      color: const Color(0xffB62B37),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white60),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xffB62B37)),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Enter Name of Building",
                    fillColor: Colors.white60,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter correct name";
                    } else {
                      Building().buildingName = value;
                      return null;
                    }
                  },
                ),

                SizedBox(
                  height: height * 0.05,
                ),

                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white60),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xffB62B37)),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    hintText:  "Enter the number of floors it has",
                    fillColor: Colors.white60,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a valid number";
                    } else {
                      Building().numFloors = int.parse(value);
                      return null;
                    }
                  },
                ),

                SizedBox(
                  height: height * 0.05,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Submit Building Info",
                      style: TextStyle(
                        fontSize: 21,
                        color:const Color(0xffB62B37),
                      ),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.save),
                      backgroundColor:const Color(0xFFCD4F69),
                      foregroundColor: Colors.white,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final snackBar =
                          SnackBar(content: Text('Submitting Data'));

                          FirebaseFirestore.instance
                              .collection('buildingDetails')
                              .add({Building().buildingName: Building().numFloors});
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height:20),

                FloatingActionButton(
                  child: Icon(Icons.arrow_forward),
                  backgroundColor:const Color(0xFFCD4F69),
                  foregroundColor: Colors.white,
                  onPressed: () => Navigator.of(context)
                      .push(
                      MaterialPageRoute(
                        builder: (context) => UploadScreen(),
                      )
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}