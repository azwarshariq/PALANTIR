import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:popup_card/popup_card.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

final formKey = GlobalKey<FormState>(); //key for form

int screen = 0;
String routerAddress = " ";
double xVar = 0;
double yVar = 0;
String routerName = " ";
String mac = " ";
int xyAxis = 100;

class _EditScreenState extends State<EditScreen> {
  Offset? _tapPosition;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (position) {
          setState(() {
            _tapPosition = position.globalPosition;
            xVar = (((_tapPosition?.dx ?? 0) -
                (MediaQuery.of(context).size.width * 0.05)) /
                (MediaQuery.of(context).size.width * 0.9)) *
                xyAxis;

            yVar = (((_tapPosition?.dy ?? 0) -
                (MediaQuery.of(context).padding.top + kToolbarHeight)) /
                (MediaQuery.of(context).size.height * 0.7)) *
                xyAxis;
          });
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff100D49),
              elevation: 10,
              //toolbarHeight: 56,
            ),
            body: Center(
                child: Column(children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Container(
                        //color: Color.fromARGB(255, 46, 37, 48),
                        //height: MediaQuery.of(context).size.height * 0.7,
                        //width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/images/floorplan.jpeg',
                            height: MediaQuery.of(context).size.height * 0.70,
                            width: MediaQuery.of(context).size.width * 0.9,
                            //fit: BoxFit.fitWidth,
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        child: Icon(Icons.add),
                        backgroundColor: Color.fromARGB(255, 46, 37, 48),
                        foregroundColor: Colors.white,
                        onPressed: () => {
                          screen = 1,
                        },
                      ),
                      PopupItemLauncher(
                          tag: 'test',
                          popUp: PopUpItem(
                            padding: const EdgeInsets.all(
                                8), // Padding inside of the card
                            color: Colors.white, // Color of the card
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(32)), // Shape of the card
                            elevation: 2, // Elevation of the card
                            tag:
                            'test', // MUST BE THE SAME AS IN `PopupItemLauncher`
                            child:
                            const PopUpItemBody(), // Your custom child widget.
                          ),
                          child: Material(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              size: 60,
                            ),
                          )),
                      FloatingActionButton(
                        child: Icon(Icons.delete),
                        backgroundColor: Color.fromARGB(255, 46, 37, 48),
                        foregroundColor: Colors.white,
                        onPressed: () => {},
                      ),
                    ],
                  ),

                  Container(
                    // height: MediaQuery.of(context).size.height * 0.1,
                    child: ((_tapPosition?.dx ?? 0) >
                        (MediaQuery.of(context).size.width * 0.05) &&
                        (_tapPosition?.dx ?? 0) <
                            (MediaQuery.of(context).size.width * 0.95) &&
                        (_tapPosition?.dy ?? 0) >
                            (MediaQuery.of(context).padding.top +
                                kToolbarHeight) &&
                        (_tapPosition?.dy ?? 0) <
                            (MediaQuery.of(context).size.height * 0.7) +
                                (MediaQuery.of(context).padding.top +
                                    kToolbarHeight))
                        ? Text(
                      //'X & Y: ${_tapPosition?.dx.toString() ?? _tapPosition?.dy.toString() ?? 'Tap SomeWhere'}',
                      //'X & Y : ${_tapPosition?.dx.toString() ?? ''}, ${_tapPosition?.dy.toString() ?? 'Tap SomeWhere'}',
                      'X & Y : ${xVar.toString() ?? ''}, ${yVar.toString() ?? 'Tap SomeWhere'}',
                      style: TextStyle(
                          color: Color.fromARGB(255, 156, 154, 154),
                          fontSize: 14),
                    )
                        : null,
                  ),
                  //style: TextStyle(color: Colors.white, fontSize: 23),
                ]))));
  }
}

class PopUpItemBody extends StatelessWidget {
  const PopUpItemBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: ' Enter Router MAC',
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50)),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Correct Address";
              } else {
                routerName = value;
                return null;
              }
            },
            cursorColor: Color.fromARGB(255, 0, 0, 0),
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.2,
          ),
          Text(
            'X & Y : ${xVar.toString()} & ${yVar.toString()}',
            style: TextStyle(
                color: Color.fromARGB(255, 156, 154, 154), fontSize: 14),
          ),
          /*TextFormField(
            decoration: InputDecoration(
              hintText: ' Enter MAC Address',
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50)),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter correct name";
              } else {
                mac = value;
                return null;
              }
            },
            cursorColor: Color.fromARGB(255, 0, 0, 0),
          ),*/
          const Divider(
            color: Colors.white,
            thickness: 0.2,
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final snackBar = SnackBar(content: Text('Router Added'));

                //FirebaseFirestore.instance
                //    .collection('buildingDetails')
                //    .add({buildingName: numFloors});
              }
            },
            child: const Text('Add Router'),
          ),
        ],
      ),
    );
  }
}