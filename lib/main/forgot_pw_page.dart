import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white60,
              content: Text(
                'The reset link has been sent!\nCheck your email to access it.',
                style: GoogleFonts.raleway(
                  color: const Color(0xffB62B37),
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white60,
            content: Text(
              //e.message.toString()
              'This user doesn\'t exit.\nTry checking if you\'ve entered the correct username!',
              style: GoogleFonts.raleway(
                color: const Color(0xffB62B37),
                fontWeight: FontWeight.w200,
              ),
            ),
          );
        }
      );
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff100D49),
      appBar: AppBar(
        backgroundColor: const Color(0xffB62B37),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            child: Text(
              'Enter E-mail to get a Password reset link',
              style: GoogleFonts.raleway(
                color: Colors.white60,
                fontWeight: FontWeight.w200,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 10,),

          //username textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60),
                    borderRadius: BorderRadius.circular(12)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xffB62B37)),
                    borderRadius: BorderRadius.circular(12)
                ),
                hintText: 'email@xyz.com',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),

          SizedBox(height: 10,),

          ElevatedButton(
            onPressed: passwordReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffB62B37),
            ),
            child: Text(
              'Reset Password',
              style: GoogleFonts.raleway(
                color: Colors.white60,
                fontWeight: FontWeight.w200,
                fontSize: 20,
              ),
            ),
          )
        ]
      ),
    );
  }
}
