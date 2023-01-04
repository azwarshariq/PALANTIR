import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/main/home_page.dart';
import 'package:wifi_scan/wifi_scan.dart';
import '../../../classes/building_class.dart';
import '../../../classes/floor_class.dart';
import '../../../classes/router_class.dart';
import '../../../classes/user_class.dart';
import '../edit screens/hero_dialog_route.dart';

class CollectDataScreen extends StatefulWidget {
  CollectDataScreen({
    super.key,
    required this.userInstance,
    required this.currentBuilding,
    required this.currentFloor,
    required this.routerInstances,
    required this.alignment_x,
    required this.alignment_y,
  });

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );
  buildingObject currentBuilding = new buildingObject(
      "",
      "",
      "",
      0
  );
  floorObject currentFloor = new floorObject(
      "",
      "",
      "",
      0,
      "",
      0
  );

  List<routerObject> routerInstances = [];
  double alignment_x;
  double alignment_y;

  @override
  State<CollectDataScreen> createState() => _CollectDataScreenState(
    this.userInstance,
    this.currentBuilding,
    this.currentFloor,
    this.routerInstances,
    this.alignment_x,
    this.alignment_y
  );
}

final formKey = GlobalKey<FormState>(); //key for form

int screen = 0;
String routerAddress = " ";
double xVar = 0;
double yVar = 0;
int xyAxis = 100;
int value = 0;

List<String> listOfBSSIDs = [];
List<int> listOfStrengths = [];
List<int> listOfFrequencies = [];

int collectedPoints = 0;

class _CollectDataScreenState extends State<CollectDataScreen> {
  _CollectDataScreenState(
    this.userInstance,
    this.currentBuilding,
    this.currentFloor,
    this.routerInstances,
    this.alignment_x,
    this.alignment_y
  );

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );
  buildingObject currentBuilding = new buildingObject(
      "",
      "",
      "",
      0
  );
  floorObject currentFloor = new floorObject(
      "",
      "",
      "",
      0,
      "",
      0
  );

  List<routerObject> routerInstances = [];
  double alignment_x;
  double alignment_y;

  String? Url = " ";

  Future<String> getURL(image) async{
    final ref = FirebaseStorage.instance.ref().child('files/' + image);
    // no need of the file extension, the name will do fine.
    var url =  await ref.getDownloadURL();

    return url.toString();
  }

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
          flexibleSpace: Image(
            image: AssetImage('assets/elements/AppBar Edit.png'),
            fit: BoxFit.cover,
          ),
          iconTheme: IconThemeData(
            color: const Color(0xffffffff), //change your color here
          ),
          elevation: 0,
          title: Text(
            'Collect Data',
            style: GoogleFonts.raleway(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home_filled,
                color: const Color(0xffffffff),
              ),
              onPressed: () => Navigator.of(context)
                  .push(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  )
              ),
            )
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: const Color(0x00ffffff),
        ),
        body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/Controller Screen.png"),
            fit: BoxFit.cover
          )
        ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Stack(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                FutureBuilder<String>(
                                  future: getURL(currentFloor.floorPlan),
                                  builder: (BuildContext context, AsyncSnapshot<String> url)
                                  {
                                    Url = url.data;
                                    var check = Url;
                                    if (check != null) {
                                      return Image.network(
                                        Url!,
                                        height: MediaQuery.of(context).size.height * 0.70,
                                        width: MediaQuery.of(context).size.width * 0.90,
                                        fit:BoxFit.contain,
                                      ); // Safe
                                    }
                                    else{
                                      return Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Loading...",
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white60,
                                              )
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment(alignment_x, alignment_y),
                            height: 600,
                            width: 350,
                            child: CustomPaint(
                              size: Size(
                                  MediaQuery.of(context).size.width * 0.05,
                                  (MediaQuery.of(context).size.width * 0.05*1.375).toDouble()
                              ), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                              painter: RPSCustomPainter(),
                            ),
                          ),
                        ],
                      ),
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
                          Navigator.of(context).push(
                            HeroDialogRoute(builder: (context) {
                              return PopUpItemBodyAccessPoints(
                                userInstance: this.userInstance,
                                currentBuilding: this.currentBuilding,
                                currentFloor: this.currentFloor,
                                routerInstances: this.routerInstances,
                              );
                            })
                          );
                        },
                        child: Hero(
                          tag: 'btn2',
                          child: Material(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 56,
                              color: Color(0xff44CDB1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ]
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
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
                          color: Colors.white,
                          fontSize: 14),
                    )
                        : null,
                  ),

                ]
              )
            )
          ),
        ),
      )
    );
  }
}

class PopUpItemBodyAccessPoints extends StatefulWidget {
  PopUpItemBodyAccessPoints({
    super.key,
    required this.userInstance,
    required this.currentBuilding,
    required this.currentFloor,
    required this.routerInstances
  });

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );
  buildingObject currentBuilding = new buildingObject(
      "",
      "",
      "",
      0
  );
  floorObject currentFloor = new floorObject(
      "",
      "",
      "",
      0,
      "",
      0
  );

  List<routerObject> routerInstances = [];


  @override
  State<PopUpItemBodyAccessPoints> createState() => _PopUpItemBodyAccessPointsState(
      this.userInstance,
      this.currentBuilding,
      this.currentFloor,
      this.routerInstances
  );
}
class _PopUpItemBodyAccessPointsState extends State<PopUpItemBodyAccessPoints> {

  _PopUpItemBodyAccessPointsState(
    this.userInstance,
    this.currentBuilding,
    this.currentFloor,
    this.routerInstances
  );

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );
  buildingObject currentBuilding = new buildingObject(
      "",
      "",
      "",
      0
  );
  floorObject currentFloor = new floorObject(
      "",
      "",
      "",
      0,
      "",
      0
  );

  List<routerObject> routerInstances = [];

  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;
  bool get isStreaming => subscription != null;

  Future<void> _startScan(BuildContext context) async {
    // check if "can" startScan
    if (shouldCheckCan) {
      // check if can-startScan
      final can = await WiFiScan.instance.canStartScan();
      // if can-not, then show error
      if (can != CanStartScan.yes) {
        if (mounted) kShowSnackBar(context, "Cannot start scan: $can");
        return;
      }
    }

    // call startScan API
    final result = await WiFiScan.instance.startScan();
    //if (mounted) kShowSnackBar(context, "startScan: $result");
    // reset access points.
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }


  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();
      setState(() => accessPoints = results);
      //kShowSnackBar(context, "getScannedResults: true");
    }
  }

  List<WiFiAccessPoint> filterAccessPoints(List<WiFiAccessPoint> accessPoints) {

    List<WiFiAccessPoint> filteredAccessPoints = [];

    for (int i=0; i<routerInstances.length; i++){
      for (int j=0; j<accessPoints.length; j++){
        if (accessPoints[j].bssid.trim() == routerInstances[i].BSSID.trim()){
          filteredAccessPoints.add(accessPoints[j]);
        }
      }
    }

    return filteredAccessPoints;
  }

  Future<void> uploadData() async {

    await FirebaseFirestore.instance.collection('Users')
      .where('email', isEqualTo:FirebaseAuth.instance.currentUser!.email)
      .get()
      .then(
        (snapshot) => snapshot.docs.forEach(
            (element) {
          print("User ${element.reference} is collecting data");
        }
      ),
    );

    await FirebaseFirestore.instance.collection('Data')
      .doc(currentFloor.referenceId + " " + currentFloor.collectedDataPoints.toString())
      .set({
        'x': xVar,
        'y': yVar,
        'listOfBSSIDs': listOfBSSIDs,
        'listOfFrequencies': listOfFrequencies,
        'listOfStrengths': listOfStrengths,
        'floorRef' : currentFloor.referenceId
      })
      .then((value) => print("Data Added"))
      .catchError((error) => print("Failed to add data: $error"));

    currentFloor.collectedDataPoints++;
    collectedPoints++;

    await FirebaseFirestore.instance.collection('Floors')
      .doc(currentFloor.referenceId)
      .update({
      'collectedDataPoints': currentFloor.collectedDataPoints
      })
        .then((value) => print("Data Added"))
        .catchError((error) => print("Failed to add data: $error"));

    listOfBSSIDs = [];
    listOfFrequencies = [];
    listOfStrengths = [];
  }

  @override
  Widget build(BuildContext context) {
    accessPoints = filterAccessPoints(accessPoints);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Container(
                width: 380,
                height: 400,
                child: Center(
                  child: Material(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    ),
                    child: accessPoints.isEmpty
                      ? Text(
                        "NO SCANNED RESULTS",
                        style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 24,
                        ),
                        )
                        : ListView.builder(
                        itemCount: accessPoints.length,
                        itemBuilder: (context, i) =>
                          _AccessPointTile(
                            accessPoint: accessPoints[i],
                            userInstance: this.userInstance,
                            currentBuilding: this.currentBuilding,
                            currentFloor: this.currentFloor,
                            routerInstances: this.routerInstances,
                          )
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 50
            ),

            accessPoints.isEmpty ?
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffB62B37), //background color of button
                elevation: 8, //elevation of button
                shape: RoundedRectangleBorder(
                  //to set border radius to button
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.all(20),
                shadowColor: Color(0xFFCD4F69),
              ),
              onPressed: () => {
                _startScan(context),
                _getScannedResults(context),
              },
              child: Text(
                "Scan",
                style: GoogleFonts.raleway(
                  color: Colors.white60,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              )
            )

            : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffB62B37), //background color of button
                elevation: 8, //elevation of button
                shape: RoundedRectangleBorder(
                  //to set border radius to button
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.all(20),
                shadowColor: Color(0xFFCD4F69),
              ),
              onPressed: () => {
                if (xVar == 0 || yVar == 0)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please tap on screen to select x and y coordinates!',
                          style: GoogleFonts.raleway(
                            color: Colors.white60,
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),
                        )
                      )
                    ),
                  }
                else{
                  Navigator.pop(context),
                  uploadData(),
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text(
                        'Data Successfully Uploaded!',
                        style: GoogleFonts.raleway(
                          color: Colors.white60,
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      )
                    )
                  ),
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CollectDataScreen(
                        userInstance: this.userInstance,
                        routerInstances: this.routerInstances,
                        currentBuilding: this.currentBuilding,
                        currentFloor: this.currentFloor,
                        alignment_x: ((xVar*2)/100)-1,
                        alignment_y: ((yVar*2)/100)-1,
                      ),
                    ),
                  ),
                }
              },
              child: Text(
                "Upload Data",
                style: GoogleFonts.raleway(
                  color: Colors.white60,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              )
            )
          ]
        )
      ),
    );
  }
}

class _AccessPointTile extends StatelessWidget {

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );
  buildingObject currentBuilding = new buildingObject(
      "",
      "",
      "",
      0
  );
  floorObject currentFloor = new floorObject(
      "",
      "",
      "",
      0,
      "",
      0
  );

  List<routerObject> routerInstances = [];

  final WiFiAccessPoint accessPoint;

  _AccessPointTile({
    super.key,
    required this.accessPoint,
    required this.userInstance,
    required this.currentBuilding,
    required this.currentFloor,
    required this.routerInstances
  });

  // build row that can display info, based on label: value pair.
  Widget _buildInfo(String label, dynamic value) => Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey)
      ),
    ),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: GoogleFonts.raleway(
            color: Colors.white60,
            fontWeight: FontWeight.w300,
          ),
        ),
        Expanded(
          child: Text(
            value.toString(),
            style: GoogleFonts.raleway(
              color: Colors.white60,
              fontWeight: FontWeight.w300,
            ),
          )
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "*EMPTY*";
    final signalIcon = accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;

    print(accessPoint.bssid);
    listOfBSSIDs.add(accessPoint.bssid);

    print(accessPoint.frequency);
    listOfFrequencies.add(accessPoint.frequency);

    print(accessPoint.level);
    listOfStrengths.add(accessPoint.level);

    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      subtitle: Text(
        accessPoint.capabilities,
        style: GoogleFonts.raleway(
          color: Colors.blueGrey,
          fontWeight: FontWeight.w200,
        ),
      ),

      /* print("Index number is:");
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              print("BSSID", accessPoint.bssid),
              _buildInfo("BSSDI", accessPoint.bssid),
              _buildInfo("Capability", accessPoint.capabilities),
              _buildInfo("frequency", "${accessPoint.frequency}MHz"),
              _buildInfo("level", accessPoint.level),
              _buildInfo("standard", accessPoint.standard),
              _buildInfo(
                  "centerFrequency0", "${accessPoint.centerFrequency0}MHz"),
              _buildInfo(
                  "centerFrequency1", "${accessPoint.centerFrequency1}MHz"),
              _buildInfo("channelWidth", accessPoint.channelWidth),
              _buildInfo("isPasspoint", accessPoint.isPasspoint),
              _buildInfo(
                  "operatorFriendlyName", accessPoint.operatorFriendlyName),
              _buildInfo("venueName", accessPoint.venueName),
              _buildInfo("is80211mcResponder", accessPoint.is80211mcResponder),
            ],
          ),
        ),
      ),*/
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.5034688,size.height);
    path_0.cubicTo(size.width*0.4878625,size.height*0.5641583,size.width*-0.6214906,0,size.width*0.5034688,0);
    path_0.cubicTo(size.width*1.628428,0,size.width*0.4878625,size.height*0.5641583,size.width*0.5034688,size.height);
    path_0.close();

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Color(0xffA21C44).withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_fill);

    Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
    paint_1_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawCircle(Offset(size.width*0.5000000,size.height*0.2500000),size.width*0.1562500,paint_1_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

