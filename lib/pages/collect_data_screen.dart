import 'package:flutter/material.dart';

class CollectDataScreen extends StatefulWidget {
  const CollectDataScreen({Key? key}) : super(key: key);

  @override
  State<CollectDataScreen> createState() => _CollectDataScreenState();
}

final formKey = GlobalKey<FormState>(); //key for form

int screen = 0;
String routerAddress = " ";
double xVar = 0;
double yVar = 0;
int xyAxis = 100;
int value = 0;

class _CollectDataScreenState extends State<CollectDataScreen> {
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
        //
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff100D49),
              elevation: 10,
            ),
            backgroundColor: Color(0xff100D49),
            body: Center(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Container(
                                  child: Image.asset(
                                    'assets/floorplan.jpeg',
                                    height: MediaQuery.of(context).size.height * 0.70,
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    //fit: BoxFit.fitWidth,
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Container(
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
                              'X : ${xVar.toString()}, Y : ${yVar.toString()}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 156, 154, 154),
                                  fontSize: 14),
                            )
                                : null,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                        ])))));
  }
}

