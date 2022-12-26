import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

class PositioningScreen extends StatefulWidget {
  PositioningScreen({
    Key? key,
    required this.x_coordinate,
    required this.y_coordinate,
  }):super(key: key);

  final x_coordinate;
  final y_coordinate;

  @override
  State<PositioningScreen> createState() => _PositioningScreenState(
    this.x_coordinate,
    this.y_coordinate,
  );
}

class _PositioningScreenState extends State<PositioningScreen> {
  _PositioningScreenState(
    this.x_coordinate,
    this.y_coordinate,
  );

  final x_coordinate;
  final y_coordinate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xffffffff),
        iconTheme: IconThemeData(
          color: const Color(0xffA11C44), //change your color here
        ),
        elevation: 0,
        title: Text(
          'You are here!',
          style: GoogleFonts.raleway(
            color: const Color(0xffA11C44),
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 40),
        margin: const EdgeInsets.fromLTRB(10, 30, 10, 30),
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/backgrounds/Splash Screen.png"),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, //New
                blurRadius: 5.0,
                offset: Offset(0, -1))
          ],
        ),
        child: Stack(
          children: [
            Container(
              height: 600,
              width: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/floorplan.jpeg"),
                    fit: BoxFit.cover
                ),
              ),
            ),

            Container(
              alignment: Alignment(((x_coordinate*2)/100)-1, ((y_coordinate*2)/100)-1),
              height: 600,
              width: 350,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width * 0.05, (MediaQuery.of(context).size.width * 0.05*1.375).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: RPSCustomPainter(),
              ),
            ),
          ],
        ),
      ),
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
