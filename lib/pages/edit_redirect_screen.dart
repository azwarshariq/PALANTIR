
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:palantir_ips/pages/view_screen.dart';
import 'package:palantir_ips/pages/storage_service.dart';
import 'package:flutter/material.dart';

class EditRedirectScreen extends StatefulWidget {
  const EditRedirectScreen({Key? key}) : super(key: key);

  @override
  _MyEditRedirectScreenState createState() => _MyEditRedirectScreenState();
}

class _MyEditRedirectScreenState extends State<EditRedirectScreen> {
  String initialFloorValue = 'Floor 1';
  String initialBuildingValue = 'Fast';
  final Storage storage = Storage();

  var buildings = ['Fast', 'Shifa', 'Giga Mall'];
  var floors = [
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
                      "Select Building",
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
                      value: initialBuildingValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: buildings.map((String items) {
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
                          initialBuildingValue = newValue!;
                        });
                      },
                      dropdownColor: Colors.white60,
                    ),
                    const SizedBox(height: 100),
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
                      value: initialFloorValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: floors.map((String items) {
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
                          initialFloorValue = newValue!;
                        });
                      },
                      dropdownColor: Colors.white60,
                    ),
                    const SizedBox(height: 200),
                    CircleAvatar(
                      //Add Button
                      radius: 35.0,
                      backgroundColor: const Color(0xFFCD4F69),
                      child: IconButton(
                        icon: Icon(Icons.arrow_circle_right_rounded),
                        color: Color.fromARGB(255, 255, 254, 254),
                        iconSize: 30,
                        splashColor: const Color(0xDACD4F69),
                        splashRadius: 45,
                        onPressed: () {
                          /*
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewScreen(
                                selectedImage: file.path,
                              ),
                            ),
                          );
                          */
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