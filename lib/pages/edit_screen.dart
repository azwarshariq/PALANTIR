import 'package:flutter/material.dart';
import 'collect_data_screen.dart';
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
String roomID = "";
String stairsID = "";
String elevatorID = "";
String typeID = "";
List<String> macAddress = [];
List<String> routers = [];
List<String> rooms = [];
List<String> stairs = [];
List<String> elevators = [];
List<String> types = [];

class _EditScreenState extends State<EditScreen> {
  Offset? _tapPosition;
  String _value = "";
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
                              PopupMenuButton(
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
                                  onSelected: (value) {
                                    setState(() {
                                      _value = value;
                                      if (_value == "router"){
                                        Navigator.of(context)
                                            .push(HeroDialogRoute(builder: (context) {
                                          return PopUpItemBodyRouter();
                                        }));
                                      }
                                      else if (_value == "room"){
                                        Navigator.of(context)
                                            .push(HeroDialogRoute(builder: (context) {
                                          return PopUpItemBodyRoom();
                                        }));
                                      }
                                      else if (_value == "stairs"){
                                        Navigator.of(context)
                                            .push(HeroDialogRoute(builder: (context) {
                                          return PopUpItemBodyStairs();
                                        }));
                                      }
                                      else if (_value == "elevator"){
                                        Navigator.of(context)
                                            .push(HeroDialogRoute(builder: (context) {
                                          return PopUpItemBodyElevator();
                                        }));
                                      }
                                    });
                                  },
                                  itemBuilder:(context) => [
                                    PopupMenuItem(
                                      child: Text("Router"),
                                      value: "router",
                                    ),
                                    PopupMenuItem(
                                      child: Text("Room"),
                                      value: "room",
                                    ),
                                    PopupMenuItem(
                                      child: Text("Stairs"),
                                      value: "stairs",
                                    ),
                                    PopupMenuItem(
                                      child: Text("Elevator"),
                                      value: "elevator",
                                    ),
                                  ]
                              ),

                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                              ),
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
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CollectDataScreen(),
                                      ),
                                    );
                                  },
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

  String initialTypeValue = 'Router';
  var type = ['Router', 'Room', 'Stairs', 'Elevator'];

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

  void updateRoom(value) {
    setState(() {
      roomID = value;
    });
  }

  void updateStairs(value) {
    setState(() {
      stairsID = value;
    });
  }

  void updateElevator(value) {
    setState(() {
      elevatorID = value;
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
                    DropdownButton(
                      value: initialTypeValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: type.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          initialTypeValue = newValue!;
                        });
                      },
                      dropdownColor: Colors.white60,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),

                    initialTypeValue == "Router" ?
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
                    ):
                    initialTypeValue == "Room" ?
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateRoom(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Room ID e.g Room1',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ):
                    initialTypeValue == "Stairs" ?
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateStairs(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Stairs ID e.g S1',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ):
                    initialTypeValue == "Elevator" ?
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (value) {
                        updateElevator(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Elevator ID e.g E1',
                        border: InputBorder.none,
                      ),
                      cursorColor: Color.fromARGB(0, 0, 0, 0),
                    ):
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    initialTypeValue == "Router" ?
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
                    ):
                    const Divider(
                      color: Colors.white,
                      thickness: 0.5,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.5,
                    ),


                    ElevatedButton(

                      onPressed: () => {
                        if (xVar == 0 || yVar == 0)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please tap on screen to select x and y coordinates!'))),
                          }
                        else
                          {
                            if(initialTypeValue == "Router")
                              {
                                if (routerName == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Please enter router ID'))),
                                  }
                                else if (mac == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Please enter MAC address'))),
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
                                        types.add("Router"),
                                        mac = "",
                                        routerName = "",
                                      }
                                  }
                              }
                            else if(initialTypeValue == "Room")
                              {
                                if (roomID == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Please enter room ID'))),
                                  }
                                else
                                  {
                                    check = false,
                                    for (int i = 0; i < rooms.length; i++)
                                      {
                                        if (roomID == rooms[i])
                                          {
                                            check = true,
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Room ID already exists'))),
                                          }
                                      },
                                    if (check == false)
                                      {
                                        Navigator.pop(context),
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content:
                                                Text('Room Successfully Added'))),
                                        print(xVar),
                                        print(yVar),
                                        print(roomID),
                                        rooms.add(roomID),
                                        types.add("Room"),
                                        roomID = "",
                                      }
                                  }
                              }

                            else if(initialTypeValue == "Stairs")
                              {
                                if (stairsID == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Please enter stairs ID'))),
                                  }
                                else
                                  {
                                    check = false,
                                    for (int i = 0; i < stairs.length; i++)
                                      {
                                        if (stairsID == stairs[i])
                                          {
                                            check = true,
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Stairs ID already exists'))),
                                          }
                                      },
                                    if (check == false)
                                      {
                                        Navigator.pop(context),
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content:
                                                Text('Stairs Successfully Added'))),
                                        print(xVar),
                                        print(yVar),
                                        stairs.add(stairsID),
                                        types.add("Stairs"),
                                        stairsID = "",
                                      }
                                  }
                              }
                            else if(initialTypeValue == "Elevator")
                              {
                                if (elevatorID == "")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Please enter elevator ID'))),
                                  }
                                else
                                  {
                                    check = false,
                                    for (int i = 0; i < elevators.length; i++)
                                      {
                                        if (elevatorID == elevators[i])
                                          {
                                            check = true,
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Elevator ID already exists'))),
                                          }
                                      },
                                    if (check == false)
                                      {
                                        Navigator.pop(context),
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content:
                                                Text('Elevator Successfully Added'))),
                                        print(xVar),
                                        print(yVar),
                                        elevators.add(elevatorID),
                                        types.add("Elevator"),
                                        elevatorID = "",
                                      }
                                  }
                              }
                          }
                      },



                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffB62B37) // Background color
                      ),
                      child: const Text("Add",
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
  PopUpItemBodyRouter({
    Key? key}) : super(key: key);

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
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              ListTile(
                title: Text("ID: ${routers[index]}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    Text("MAC: ${macAddress[index]}")
                  ],
                ),
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


class PopUpItemBodyRoom extends StatefulWidget {
  PopUpItemBodyRoom({
    Key? key}) : super(key: key);

  @override
  State<PopUpItemBodyRoom> createState() => _PopUpItemBodyRoomState();
}
class _PopUpItemBodyRoomState extends State<PopUpItemBodyRoom> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              ListTile(
                title: Text("ID: ${rooms[index]}"),
                trailing: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    rooms.remove(rooms[index]);
                    Navigator.pop(context, '/');

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Room Successfully Deleted!')));
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
          itemCount: rooms.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,

        ),
      ),
    );
  }
}


class PopUpItemBodyStairs extends StatefulWidget {
  PopUpItemBodyStairs({
    Key? key}) : super(key: key);

  @override
  State<PopUpItemBodyStairs> createState() => _PopUpItemBodyStairsState();
}
class _PopUpItemBodyStairsState extends State<PopUpItemBodyStairs> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              ListTile(
                title: Text("ID: ${stairs[index]}"),
                trailing: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    stairs.remove(stairs[index]);
                    Navigator.pop(context, '/');

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Stairs Successfully Deleted!')));
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
          itemCount: stairs.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,

        ),
      ),
    );
  }
}

class PopUpItemBodyElevator extends StatefulWidget {
  PopUpItemBodyElevator({
    Key? key}) : super(key: key);

  @override
  State<PopUpItemBodyElevator> createState() => _PopUpItemBodyElevatorState();
}
class _PopUpItemBodyElevatorState extends State<PopUpItemBodyElevator> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              ListTile(
                title: Text("ID: ${elevators[index]}"),
                trailing: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    elevators.remove(elevators[index]);
                    Navigator.pop(context, '/');

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Elevator Successfully Deleted!')));
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
          itemCount: elevators.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,

        ),
      ),
    );
  }
}
