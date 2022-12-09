import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart';



class LocateMeScreen extends StatefulWidget {
  const LocateMeScreen({Key? key}) : super(key: key);

  @override
  State<LocateMeScreen> createState() => _LocateMeScreenState();
}

class _LocateMeScreenState extends State<LocateMeScreen> {

  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;
  bool get isStreaming => subscription != null;

  //----------------------------------------------------
  List distance = [];
  List Router_X = [];
  List Router_Y = [];
  //----------------------------------------------------
  List routerDistance = [];
  List routerPixel = [];
  List index = [];
  List intersectingLine = [];
  List index1 = [];
  List intersectingRegion = [];
  //----------------------------------------------------
  double sum_x = 0;
  double sum_y = 0;
  double avg_x = 0;
  double avg_y = 0;
  double count = 0;
  //----------------------------------------------------

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
    }
  }

  //-------------------------------------------------------------------------
  List getDistance(noOfRouters, distance){
    var temp = [];
    var temp1 = [];
    var array = [];
    for( var i = 0; i<noOfRouters; i++){
      for( var j = 0; j<360;j++){
        temp.add(distance[i] * (math.cos(radians(j.toDouble()))));
        temp.add(distance[i] * (math.sin(radians(j.toDouble()))));
        temp1.add(temp);
        temp = [];
      }
      array.add(temp1);
      temp1 =[];
    }
    return array;
  }
  //-------------------------------------------------------------------------
  List getPixel(noOfRouters, routerDistance){
    var temp = [];
    var temp1 = [];
    var array = [];

    for( var i = 0; i<noOfRouters; i++) {
      for (var j = 0; j < 360; j++) {
        temp.add(((routerDistance[i][j][0] * 700) / 24.5) + Router_X[i]);
        temp.add(((routerDistance[i][j][1] * 1200) / 41) + Router_Y[i]);
        temp1.add(temp);
        temp = [];
      }
      array.add(temp1);
      temp1 = [];
    }
    return array;
  }
  //-------------------------------------------------------------------------

  List<List> getIntersectingPoints(router1, router2, routerPixel, length1, length2){
    var index1 = [];
    var index2 = [];

    for( var i = 0; i<length1; i++) {
      for( var j = 0; j<length2; j++) {
        if(((((routerPixel[router1][i][0]).truncate())/10).round())*10 == ((((routerPixel[router2][j][0]).truncate())/10).round())*10){
          if(((((routerPixel[router1][i][1]).truncate())/10).round())*10 == ((((routerPixel[router2][j][1]).truncate())/10).round())*10){
            index1.add(i);
            index2.add(j);
          }
        }
      }
    }
    return [index1, index2];
  }
  //-------------------------------------------------------------------------
  List<List> getIntersectingPointsRange(router1, router2, index1, index2, routerPixel){
    List<List> intersectingLine = [];
    List temp = [];

    if ((index1.length) != 0){
      temp = index1;
      temp.sort();
      if (temp.last - temp.first < 180){
        for( var i = temp.first; i<temp.last +1; i++) {
          intersectingLine.add(routerPixel[router1][i]);
        }
      }
      else{
        for( var i = temp.last ; i<360; i++) {
          intersectingLine.add(routerPixel[router1][i]);
        }
        for( var i = 0; i<temp.first ; i++) {
          intersectingLine.add(routerPixel[router1][i]);
        }
      }
    }
    temp = index2;
    temp.sort();
    if ((index2.length) != 0){
      if (temp.last  - temp.first < 180){
        for( var i = temp.first ; i<temp.last +1; i++) {
          intersectingLine.add(routerPixel[router2][i]);
        }
      }
      else{
        for( var i = temp.last ; i<360; i++) {
          intersectingLine.add(routerPixel[router2][i]);
        }
        for( var i = 0; i<temp.first; i++) {
          intersectingLine.add(routerPixel[router2][i]);
        }
      }
    }
    return intersectingLine;
  }
  //-------------------------------------------------------------------------
  List getIntersectingRegion(router1, router2, index1, index2, intersectingLine){
    List intersectingRegion = [];
    if (index1.length != 0){
      for(var i=0;i<index1.length;i++){
        intersectingRegion.add(intersectingLine[router1][index1[i]]);
      }
    }
    if (index2.length != 0){
      for(var i=0;i<index2.length;i++){
        intersectingRegion.add(intersectingLine[router2][index2[i]]);
      }
    }
    return intersectingRegion;
  }
  //-------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff100D49),
          elevation: 10,
        ),
        backgroundColor: Color(0xff100D49),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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

                          //--------------------------------------------------------
                          distance = [15,7,9],
                          Router_X = [469, 469, 224],
                          Router_Y = [192, 540, 372],
                          routerDistance = [],
                          routerDistance = getDistance(distance.length, distance),
                          print(routerDistance[0][359]),
                          print(routerDistance[1][359]),
                          print(routerDistance[2][359]),
                          //--------------------------------------------------------
                          routerPixel = [],
                          routerPixel = getPixel(distance.length, routerDistance),
                          //print(routerPixel),
                          //--------------------------------------------------------
                          index = [],
                          index.add(getIntersectingPoints(0 , 1, routerPixel, 360, 360)),
                          index.add(getIntersectingPoints(0 , 2, routerPixel, 360, 360)),
                          index.add(getIntersectingPoints(1 , 2, routerPixel, 360, 360)),
                          //print(index),
                          //--------------------------------------------------------
                          intersectingLine = [],
                          intersectingLine.add(getIntersectingPointsRange( 0 , 1, index[0][0], index[0][1], routerPixel )),
                          intersectingLine.add(getIntersectingPointsRange( 0 , 2, index[1][0], index[1][1], routerPixel )),
                          intersectingLine.add(getIntersectingPointsRange( 1 , 2, index[2][0], index[2][1], routerPixel )),
                          //print(intersectingLine),
                          //--------------------------------------------------------
                          index1 = [],
                          index1.add(getIntersectingPoints(0 , 1, intersectingLine, intersectingLine[0].length, intersectingLine[1].length)),
                          index1.add(getIntersectingPoints(0 , 2, intersectingLine, intersectingLine[0].length, intersectingLine[2].length)),
                          index1.add(getIntersectingPoints(1 , 2, intersectingLine, intersectingLine[1].length, intersectingLine[2].length)),
                          //print(index1),
                          //--------------------------------------------------------
                          intersectingRegion = [],
                          intersectingRegion.add(getIntersectingRegion( 0 , 1, index1[0][0], index1[0][1], intersectingLine )),
                          intersectingRegion.add(getIntersectingRegion( 0 , 2, index1[1][0], index1[1][1], intersectingLine )),
                          intersectingRegion.add(getIntersectingRegion( 1 , 2, index1[2][0], index1[2][1], intersectingLine )),
                          //print(intersectingRegion),
                          //--------------------------------------------------------
                          sum_x = 0,
                          sum_y = 0,
                          count = 0,
                          for(var i=0;i<intersectingRegion.length;i++){
                            for(var j=0;j<intersectingRegion[i].length;j++){
                              count++,
                              sum_x = sum_x + intersectingRegion[i][j][0],
                              sum_y = sum_y + intersectingRegion[i][j][1],
                            },
                          },
                          avg_x = sum_x/count,
                          avg_y = sum_y/count,
                          print(avg_x),
                          print(avg_y),
                          //--------------------------------------------------------
                        },

                        child: Text(
                          "Locate Me",
                          style: GoogleFonts.raleway(
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),
                        )
                    )
                  ],
                ),
                SizedBox(height: 50,),
                Text(
                  "X: ${avg_x} , Y: ${avg_y}",
                  style: GoogleFonts.raleway(
                    color: Color(0xffFFFFFF),
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
                const Divider(),
                Flexible(
                  child: Center(
                    child: accessPoints.isEmpty
                        ? const Text("NO SCANNED RESULTS")
                        : ListView.builder(
                        itemCount: accessPoints.length,
                        itemBuilder: (context, i) =>
                            _AccessPointTile(accessPoint: accessPoints[i])),
                  ),
                ),
              ],
            ),
          ),
        ),
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
      border: Border(bottom: BorderSide(color: Color(0xffFFFFFF))),
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
    // return ListTile(
    //   visualDensity: VisualDensity.compact,
    //   leading: Icon(signalIcon),
    //   title: Text(title),
    //   subtitle: Text(accessPoint.bssid),
    //
    // );
    return Center(
      child: Text('${accessPoint.ssid}, ${accessPoint.bssid}, ${accessPoint.frequency}, ${accessPoint.level}',
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xffFFFFFF)),
      ),
    );
    print(accessPoint.bssid);
  }
}
/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}