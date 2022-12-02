import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'hero_dialog_route.dart';

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
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(HeroDialogRoute(builder: (context) {
                                      return PopUpItemBodyAccessPoints();
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
                                  width: MediaQuery.of(context).size.width * 0.05,
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
                                    onPressed: () {},
                                  ),
                                ),
                                ]
                          )

                        ]
                    )
                )
            )
        )
    );
  }
}

class PopUpItemBodyAccessPoints extends StatefulWidget {
  PopUpItemBodyAccessPoints({Key? key}) : super(key: key);

  @override
  State<PopUpItemBodyAccessPoints> createState() => _PopUpItemBodyAccessPointsState();
}
class _PopUpItemBodyAccessPointsState extends State<PopUpItemBodyAccessPoints> {


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
    if (mounted) kShowSnackBar(context, "startScan: $result");
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
      kShowSnackBar(context, "getScannedResults: true");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        borderRadius: BorderRadius.circular(32)),
                    child: accessPoints.isEmpty
                        ? Text("NO SCANNED RESULTS",
                                style: GoogleFonts.raleway(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 24,
                            ),
                          )
                          : ListView.builder(
                          itemCount: accessPoints.length,
                          itemBuilder: (context, i) =>
                            _AccessPointTile(accessPoint: accessPoints[i])),
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
                onPressed: () {},
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
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
      : super(key: key);

  // build row that can display info, based on label: value pair.
  Widget _buildInfo(String label, dynamic value) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey)),
    ),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value.toString()))
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "*EMPTY*";
    final signalIcon = accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      subtitle: Text(accessPoint.capabilities),
      onTap: () {
        print(accessPoint.bssid);
        print(accessPoint.frequency);
      },

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


void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
