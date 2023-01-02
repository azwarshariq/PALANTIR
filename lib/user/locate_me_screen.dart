import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/classes/collected_data_class.dart';
import 'package:palantir_ips/user/positioning_screen.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:vector_math/vector_math.dart';
import '../classes/building_class.dart';
import '../classes/floor_class.dart';
import '../classes/router_class.dart';
import '../classes/user_class.dart';
import '../main/home_page.dart';



class LocateMeScreen extends StatefulWidget {
  LocateMeScreen({Key? key, required this.userInstance,
    required this.buildingInstances,
    required this.floorInstances,
    required this.routerInstances})
      : super(key: key);

  userObject userInstance = new userObject(
      '',
      '',
      '-',
      '',
      0
  );

  List<buildingObject> buildingInstances = [];

  List<floorObject> floorInstances = [];

  List<routerObject> routerInstances = [];


  @override
  State<LocateMeScreen> createState() => _LocateMeScreenState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
      this.routerInstances
  );
}



class _LocateMeScreenState extends State<LocateMeScreen> {

  _LocateMeScreenState(
      this.userInstance,
      this.buildingInstances,
      this.floorInstances,
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

  List<buildingObject> buildingInstances = [];

  List<floorObject> floorInstances = [];

  List<routerObject> routerInstances = [];

  List<collectedData> collectedDataPoints = [];

  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;
  bool get isStreaming => subscription != null;

  //----------------------------------------------------
  List distance = [];
  List floor_distance = [];
  List<routerObject> floorRouters = [];
  List<WiFiAccessPoint> floorAccessPoints = [];
  List<dynamic> sorted_distance = [];
  int floorPlanLength = 0;
  List<floorObject> currentLocation = [];
  List Router_X = [];
  List Router_Y = [];
  List temp_bssids = [];
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
  double exponent = 0.0;
  double x_coordinate = 0.0;
  double y_coordinate = 0.0;
  //----------------------------------------------------
  List<double> get_x_y = [];

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
        temp.add(distance[i] * (cos(radians(j.toDouble()))));
        temp.add(distance[i] * (sin(radians(j.toDouble()))));
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

  List hypotenuseToBase(List distances){
    // Assuming the Perpendicular value (in meters)
    double perp = 2.8; // 9 feet approx.

    for (int i=0; i<distances.length; i++){
      distances[i] = sqrt( pow(distances[i], 2) - pow(perp, 2) );
    }

    return distances;
  }

  List<dynamic> sortDistanceArray(array, n, List<routerObject> floorRouters)
  {
    List distance = [];
    double temp = 0.0;
    routerObject tempRouter = new routerObject(
      "",
      "",
      "",
      "",
      0.0,
      0.0,
    );

    for (int i=0; i<n; i++){
      for (int j=0; j<n-i-1; j++){
        if (array[j+1] < array[j]){
          temp = array[j];
          array[j] = array[j+1];
          array[j+1] = temp;

          tempRouter = floorRouters[j];
          floorRouters[j] = floorRouters[j+1];
          floorRouters[j+1] = tempRouter;
        }
      }
    }
    distance = array;
    distance = hypotenuseToBase(distance);
    return [distance, floorRouters];
  }

  int countOccurrencesUsingWhereMethod(List<floorObject> list, String element) {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].referenceId == element) {
        count++;
      }
    }
    return count;
  }

  int countCounterOccurrences(List<String> list, String element) {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == element) {
        count++;
      }
    }
    return count;
  }

  Future<List<collectedData>> getCollectedPointsData() async {

    CollectionReference firebaseData = await FirebaseFirestore.instance.collection('Data');
    List<collectedData> temp = [];
    for (int i=0; i<currentFloor.collectedDataPoints; i++){
      DocumentSnapshot data = await firebaseData.doc(currentFloor.referenceId + " " + i.toString()).get();

      final dataPoint = new collectedData(
        currentFloor.referenceId + " " + i.toString(),
        data['listOfBSSIDs'],
        data['listOfFrequencies'],
        data['listOfStrengths'],
        data['x'],
        data['y'],
      );
      temp.add(dataPoint);
    }
    return temp;
  }

  List<double> contextualiseValues(double x, double y, List<collectedData> collectedPoints){
    double inaccuracyX = 0.0;
    double inaccuracyY = 0.0;
    double meanCollectedX = 0.0;
    double meanCollectedY = 0.0;

    for (int i=0; i<collectedPoints.length; i++){
      meanCollectedX += collectedPoints[i].x;
      meanCollectedY += collectedPoints[i].y;
    }
    meanCollectedX /= collectedPoints.length;
    meanCollectedY /= collectedPoints.length;

    inaccuracyX = (x - meanCollectedX).abs();
    inaccuracyY = (y - meanCollectedY).abs();

    print('- Mean of Collected Data: (${meanCollectedX}, ${meanCollectedY})');
    print('- Positioned values: (${x}, ${y})');
    print('- Inaccuracy: (${inaccuracyX}, ${inaccuracyY}) ');

    if (inaccuracyX < 10 && inaccuracyY < 10){
      return [x, y];
    }
    else if (inaccuracyX < 40 && inaccuracyY < 40){
      return [x*(0.5) + meanCollectedX*(0.5), y*(0.5) + meanCollectedY*(0.5)];
    }
    else {
      return [meanCollectedX, meanCollectedY];
    }
  }

  List<int> listOfLevels = [];
  List<String> listOfBssids = [];
  List<String> counter = [];
  List<int> intCounter = [];

  @override
  Widget build(BuildContext context) {
    int maximum = -1;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/elements/AppBar Edit.png'),
          fit: BoxFit.cover,
        ),
        elevation: 0,
        title: Text(
          'Positioning',
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
        iconTheme: IconThemeData(
          color: const Color(0xffffffff), //change your color here
        ),
        centerTitle: true,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/backgrounds/Locate Me.png"),
                fit: BoxFit.cover
            )
        ),
        child: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 450,),
                Row(
                  children: [
                    SizedBox(width: 110,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        animationDuration: const Duration(seconds: 1),
                        shape: RoundedRectangleBorder(
                          //to set border radius to button
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Color(0xFFFFFFFF),
                        shadowColor: Color(0xFFA11C44),
                        padding: EdgeInsets.all(20),
                      ),
                      onPressed: () async => {
                        _startScan(context),
                        _getScannedResults(context),

                        if (accessPoints.isEmpty){
                          print("Empty"),
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Building Successfully Added')
                              )
                          ),
                        }
                        else {
                          distance = [],
                          for ( var i=0; i< accessPoints.length; i++ ){
                            exponent = ((27.55 - (20 * (log(accessPoints[i].frequency))/log(10)) + accessPoints[i].level.abs()) / 20),
                            distance.add(pow(10, exponent)),
                            // print(accessPoints[i].bssid),
                            // print(distance[i]),
                          },

                          for (int i = 0; i<accessPoints.length; i++){
                            for (int j = 0; j<routerInstances.length; j++){
                              if( accessPoints[i].bssid == routerInstances[j].BSSID ){
                                floorRouters.add(routerInstances[j]),
                                floorAccessPoints.add(accessPoints[i]),
                                floor_distance.add(distance[i]),
                              }
                            },
                          },

                          floorRouters.toSet().toList(),
                          for (int j = 0; j< floorRouters.length; j++){
                             print("-->"+floorRouters[j].BSSID),
                             print(floor_distance[j]),
                          },

                          sorted_distance = sortDistanceArray(floor_distance, floor_distance.length, floorRouters),
                          distance =  sorted_distance[0],
                          floorRouters =  sorted_distance[1],

                          //print("1"),
                          //print(distance),
                          //print(floorRouters[0].BSSID + " , "+ floorRouters[1].BSSID+ " , " + floorRouters[2].BSSID),
                          print("\n"),
                          currentLocation = [],
                          print("2"),
                          for(int outerLoop = 0;  outerLoop < distance.length; outerLoop++){
                            for(int innerLoop = 0;  innerLoop < floor_distance.length; innerLoop++){
                              if(floor_distance[innerLoop] == distance[outerLoop]){
                                print(floor_distance[innerLoop]),
                                for(int i=0; i<routerInstances.length; i++){
                                  if(routerInstances[i].BSSID == floorRouters[innerLoop].BSSID){
                                    print("Router bssid -> " + routerInstances[i].BSSID),
                                    for(int j=0; j<floorInstances.length; j++){
                                      if(floorInstances[j].referenceId == routerInstances[i].floorRef){
                                        currentLocation.add(floorInstances[j]),
                                        print(floorInstances[j].referenceId),
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },

                          print("\n"),

                          //print(currentLocation),
                          for(int i = 0; i<currentLocation.length;i++ ){
                            print(countOccurrencesUsingWhereMethod(currentLocation, currentLocation[i].referenceId)),
                            if(countOccurrencesUsingWhereMethod(currentLocation, currentLocation[i].referenceId) >= 2){
                              this.currentFloor = currentLocation[i],
                              for(int j=0; j<buildingInstances.length; j++){
                                if(buildingInstances[j].referenceId == currentLocation[i].buildingRef){
                                  this.currentBuilding = buildingInstances[j],
                                  //print(buildingInstances[j].referenceId),
                                }
                              }
                            }
                            else if(countOccurrencesUsingWhereMethod(currentLocation, currentLocation[i].referenceId) <= 1){
                              this.currentFloor = currentLocation[0],
                              for(int j=0; j<buildingInstances.length; j++){
                                if(buildingInstances[j].referenceId == currentLocation[0].buildingRef){
                                  this.currentBuilding = buildingInstances[j],
                                  //print(buildingInstances[j].referenceId),
                                }
                              }
                            }
                          },

                          for(int i = 0 ;i<floorRouters.length;i++){
                            print(floorRouters[i].BSSID),
                            print(distance[i]),
                            print(floorRouters[i].x.toString() + " , " + floorRouters[i].y.toString())
                          },
                          this.collectedDataPoints = await getCollectedPointsData(),

                          if(floorRouters.length < 3){
                            print("\nAccess point levels"),
                            for(int i = 0; i<floorAccessPoints.length; i++){
                              listOfBssids.add(floorAccessPoints[i].bssid),
                              listOfLevels.add(floorAccessPoints[i].level),
                            },
                            print(listOfBssids),
                            print(listOfLevels),

                            for( int i = 0; i<this.collectedDataPoints.length; i++){
                              for( int j = 0; j<collectedDataPoints[i].listOfStrengths.length; j++){
                                for( int k = 0; k< listOfLevels.length;k++){
                                  if(listOfBssids[k] == collectedDataPoints[i].listOfBSSIDs[j]){
                                    if((listOfLevels[k] - collectedDataPoints[i].listOfStrengths[j]).abs() <= 5){
                                      print("--> Collected Data Info"),
                                      print(collectedDataPoints[i].listOfBSSIDs[j]),
                                      print(collectedDataPoints[i].listOfStrengths[j]),
                                      print(collectedDataPoints[i].referenceId),
                                      counter.add(collectedDataPoints[i].referenceId),
                                    }
                                  }
                                },
                              }
                            },
                            print("counter"),
                            print(counter),
                            for(int i = 0; i<counter.length; i++)
                              intCounter.add(countCounterOccurrences(counter, counter[i])),

                            for(int i = 0; i<intCounter.length; i++){
                              if(intCounter[i] > maximum){
                                maximum = i
                              }
                            },
                            for( int i = 0; i<this.collectedDataPoints.length; i++){
                              if (this.collectedDataPoints[i].referenceId == counter[maximum]){
                                x_coordinate = collectedDataPoints[i].x,
                                y_coordinate = collectedDataPoints[i].y,
                              }
                            },
                            print(x_coordinate),
                            print(y_coordinate),
                          }
                          else{
                            this.collectedDataPoints = await getCollectedPointsData(),
                            Router_X = [(floorRouters[0].x/100)*700, (floorRouters[1].x/100)*700, (floorRouters[2].x/100)*700],
                            Router_Y = [(floorRouters[0].y/100)*1200, (floorRouters[1].y/100)*1200, (floorRouters[2].y/100)*1200],
                            print("Router: "),
                            print(Router_X),
                            print(Router_Y),
                            
                            for( int i = 0; i<this.collectedDataPoints.length; i++){
                              for( int j = 0; j<collectedDataPoints[i].listOfStrengths.length; j++){
                                for( int k = 0; k< listOfLevels.length;k++){
                                  if(listOfBssids[k] == collectedDataPoints[i].listOfBSSIDs[j]){
                                    if((listOfLevels[k] - collectedDataPoints[i].listOfStrengths[j]).abs() <= 5){
                                      print("--> Collected Data Info"),
                                      print(collectedDataPoints[i].listOfBSSIDs[j]),
                                      print(collectedDataPoints[i].listOfStrengths[j]),
                                      print(collectedDataPoints[i].referenceId),
                                      counter.add(collectedDataPoints[i].referenceId),
                                    }
                                    else {
                                      collectedDataPoints.remove(collectedDataPoints[i]),
                                    }
                                  }
                                },
                              }
                            },

                            routerDistance = [],
                            routerDistance = getDistance(distance.length, distance),
                            //print(routerDistance),
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
                            avg_y = 1200 - avg_y,
                            print(avg_x),
                            print(avg_y),

                            //--------------------------------------------------------

                            x_coordinate = (avg_x/700)*100,
                            y_coordinate = (avg_y/1200)*100,
                            print(x_coordinate),
                            print(y_coordinate),
                            
                            get_x_y = contextualiseValues(x_coordinate, y_coordinate, collectedDataPoints),
                            x_coordinate = get_x_y[0],
                            y_coordinate = get_x_y[1],
                          },

                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PositioningScreen(
                                  userInstance: userInstance,
                                  buildingInstances: buildingInstances,
                                  floorInstances: floorInstances,
                                  routerInstances: routerInstances,
                                  currentBuilding: currentBuilding,
                                  currentFloor: currentFloor,
                                  x_coordinate: x_coordinate,
                                  y_coordinate: y_coordinate,
                                )
                            )
                          ),
                        }
                      },
                      child: Text(
                        "Locate Me",
                        style: GoogleFonts.raleway(
                          color: Color(0xffA11C44),
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}