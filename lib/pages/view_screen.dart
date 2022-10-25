import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palantir_ips/pages/edit_screen.dart';
import 'upload_screen.dart';

class ViewScreen extends StatefulWidget {
  ViewScreen({Key? key, required this.selectedImage, this.file})
      : super(key: key);
  final XFile? file;
  final String selectedImage;

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xff100D49),
        elevation: 10,
        shadowColor: const Color(0xffB62B37),
      ),
      backgroundColor:const Color(0xff100D49),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
              [
                Image.file(
                  File(
                    widget.selectedImage,
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        //Edit Button
                        radius: 40.0,
                        backgroundColor: const Color(0xffB62B37),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.white60,
                          iconSize: 40,
                          splashColor: const Color(0xFFCD4F69),
                          splashRadius: 45,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => UploadScreen())),
                        ),
                      ),

                      const SizedBox(width: 50),

                      CircleAvatar(
                        //Edit Button
                        radius: 40.0,
                        backgroundColor: const Color(0xffB62B37),
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.white60,
                          iconSize: 30,
                          splashColor: const Color(0xFFCD4F69),
                          splashRadius: 45,
                          onPressed: ()  => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => EditScreen())),
                        ),
                      ),
                    ],
                  ),
                ),
                // ignore: avoid_print
              ]
            ),
          ),
        ),
      ),
    );
  }
}