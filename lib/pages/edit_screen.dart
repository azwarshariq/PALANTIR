import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:popup_card/popup_card.dart';

import 'hero_dialog_route.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

TextEditingController userInput = TextEditingController();
final formKey = GlobalKey<FormState>(); //key for form

int screen = 0;
String routerAddress = " ";
double xVar = 0;
double yVar = 0;
int xyAxis = 100;
int value = 0;
String mac = "";
String routerName = "";
List<String> macAddress = [];
List<String> routers = [];

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(HeroDialogRoute(builder: (context) {
                                    return PopUpItemBody();
                                  }));
                                },
                                child: Hero(
                                  tag: 'btn2',
                                  child: Material(
                                    color: Color.fromARGB(207, 255, 255, 255),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32)),
                                    child: const Icon(
                                      Icons.add_circle_rounded,
                                      size: 56,
                                      color: Color(0xffB62B37),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(HeroDialogRoute(builder: (context) {
                                    return PopUpItemBodyRouter();
                                  }));
                                },
                                child: Hero(
                                  tag: 'btn3',
                                  child: Material(
                                    color: Color.fromARGB(198, 255, 255, 255),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32)),
                                    child: const Icon(
                                      Icons.delete_rounded,
                                      size: 56,
                                      color: Color(0xffB62B37),
                                    ),
                                  ),
                                ),
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

class PopUpItemBody extends StatefulWidget {
  const PopUpItemBody({
    Key? key,
  }) : super(key: key);

  @override
  State<PopUpItemBody> createState() => _PopUpItemBodyState();
}

const String _heroAddMacAddress = 'add-mac-hero';

class _PopUpItemBodyState extends State<PopUpItemBody> {
  void updateName(value) {
    setState(() {
      routerName = value;
    });
  }

  void updateMac(value) {
    setState(() {
      mac = value;
    });
  }

  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: 'btn2',
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateName(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Router ID e.g R1',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateMac(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Mac Address',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        if (xVar == 0)
                          {print("zero")}
                        else if (mac == "")
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter MAC address'))),
                          }
                        else if (routerName == "")
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please enter router ID'))),
                            }
                          else
                            {
                              check = false,
                              for (int i = 0; i < macAddress.length; i++)
                                {
                                  if (mac == macAddress[i])
                                    {
                                      check = true,
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'MAC Address already exists'))),
                                    }
                                  else if (routerName == routers[i])
                                    {
                                      check = true,
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Router ID already exists'))),
                                    }
                                },
                              if (check == false)
                                {
                                  Navigator.pop(context),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                          Text('Router Successfully Added'))),
                                  print(mac),
                                  print(xVar),
                                  print(yVar),
                                  macAddress.add(mac),
                                  routers.add(routerName),
                                  mac = "",
                                  routerName = "",
                                }
                            }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffB62B37) // Background color
                      ),
                      child: const Text("Add Router",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PopUpItemBodyRouter extends StatefulWidget {
  const PopUpItemBodyRouter({
    Key? key,
  }) : super(key: key);

  @override
  State<PopUpItemBodyRouter> createState() => _PopUpItemBodyRouterState();
}

const String _heroDeleteMacAddress = 'delete-mac-hero';

class _PopUpItemBodyRouterState extends State<PopUpItemBodyRouter> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView.builder(
          itemBuilder: (BuildContext, index) {
            return Card(
              child: ListTile(
                title: Text("ID: ${routers[index]}"),
                subtitle: Text("MAC: ${macAddress[index]}"),
                trailing: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    routers.remove(routers[index]);
                    macAddress.remove(macAddress[index]);
                    Navigator.pop(context, '/');

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Router Successfully Deleted!')));
                  },
                  child: Material(
                    color: Color.fromARGB(198, 255, 255, 255),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: const Icon(
                      Icons.delete,
                      size: 40,
                      color: Color(0xffB62B37),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: routers.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
