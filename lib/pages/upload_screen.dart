import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:palantir_ips/pages/view_screen.dart';
import 'package:palantir_ips/pages/storage_service.dart';
import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _MyUploadScreenState createState() => _MyUploadScreenState();
}

class _MyUploadScreenState extends State<UploadScreen> {
  String dropdownvalue = 'Floor 1';
  final Storage storage = Storage();

  var items = [
    'Floor 1',
    'Floor 2',
    'Floor 3',
    'Floor 4',
    'Floor 5',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff100D49),
        elevation: 10,
      ),
      backgroundColor: const Color(0xff100D49),
      body: Container(
          padding: const EdgeInsets.only(left: 60, right: 40, top: 0),
          child: Form(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 18),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                      dropdownColor: Colors.white60,
                    ),
                    const SizedBox(height: 200),
                    const Text(
                      "Upload Image",
                      style: TextStyle(
                        fontSize: 21,
                        color: const Color(0xffB62B37),
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
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
