import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:palantir_ips/pages/view_screen.dart';
import 'package:palantir_ips/pages/storage_service.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({Key? key}) : super(key: key);

  @override
  _MyUploadScreenState createState() => _MyUploadScreenState();
}

class _MyUploadScreenState extends State<UploadScreen> {
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    List<String> items = ["Floor 1", "Floor 2", "Floor 3", "Floor 4"];
    String? value;
    String? newValue;
    final Storage storage = Storage();

    return Scaffold(
        appBar: AppBar(
          backgroundColor:const Color(0xff100D49),
          elevation: 10,
        ),
        backgroundColor:const Color(0xff100D49),
        body: Container(
            padding: const EdgeInsets.only(left: 60, right: 40, top: 0),
            child: Form(
              child: Center(
                // Select Floor

                child: Column(children: [
                  const SizedBox(height: 120),

                  const Text(
                    "Select Floor",
                    style: TextStyle(
                      fontSize: 30,
                      color: const Color(0xffB62B37),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    width: 220,
                  ),

                  DropdownButton(
                    hint: const Text(
                      "Choose Floor",
                      style: TextStyle(
                          fontSize: 25,
                          color: const Color(0xFFCD4F69),
                      ),
                    ),
                    value: value,

                    items: items.map((items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) => setState(() => value = newValue),

                    icon: const Padding(
                      //Icon at tail, arrow bottom is default icon
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(Icons.arrow_circle_down_sharp)),

                    iconEnabledColor: const Color(0xFFCD4F69), //Icon color
                    style: TextStyle(
                      fontSize: 21,
                      color:const Color(0xffB62B37),
                    ),

                    dropdownColor: Colors.white60, //dropdown background color
                  ),
                  // Upload Image

                  const SizedBox(height: 200),

                  const Text(
                    "Upload Image",
                    style: TextStyle(
                      fontSize: 21,
                      color:const Color(0xffB62B37),
                    ),
                  ),

                  const SizedBox(height: 30),

                  CircleAvatar(
                    //Add Button
                    radius: 35.0,
                    backgroundColor: const Color(0xFFCD4F69),
                    child: IconButton(
                      icon: Icon(Icons.cloud_upload_outlined),
                      color: Color.fromARGB(255, 255, 254, 254),
                      iconSize: 30,
                      splashColor: const Color(0xDACD4F69),
                      splashRadius: 45,
                      onPressed: () async {
                        XFile? file = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (file != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewScreen(
                                selectedImage: file.path,
                              ),
                            ),
                          );
                        }

                        if (file == null) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('No file selected!')));
                        }
                        final path = file!.path;
                        final name = file.name;

                        print("Path: " + path);
                        print("Name: " + name);

                        storage
                            .uploadFile(path, name)
                            .then((value) => print('Done'));
                      },
                    ),
                  ),
                ]),
              ),
            )
        )
    );
  }
}