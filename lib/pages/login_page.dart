import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palantir_ips/pages/forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: CircularProgressIndicator(
              color: const Color(0xffB62B37),
            )
        );
      }
    );
    
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
    );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xff100D49),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 100,
                    color: const Color(0xFFCD4F69),
                  ),
                  // Greeting Message
                  Text(
                    'PALANTIR',
                    style: GoogleFonts.raleway(
                      color: const Color(0xffB62B37),
                      fontWeight: FontWeight.w200,
                      fontSize: 50,
                    ),
                  ),
                  SizedBox(height:10),
                  Text(
                    'Login to proceed to mapping',
                    style: GoogleFonts.raleway(
                      color: const Color(0xffB62B37),
                      fontSize: 20,
                    ),
                  ),

                  //Space in between
                  SizedBox(height:50),

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

                  //Space in between
                  SizedBox(height:10),

                //password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white60),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: const Color(0xffB62B37)),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        hintText: 'password',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),

                  //Space in between
                  SizedBox(height:25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                          Navigator.push(
                            context,
                              MaterialPageRoute(
                                builder: (context){
                                  return ForgotPasswordPage();
                                }
                              ),
                            );
                          },
                          child: Text(
                            'Forgot your password?',
                            style: GoogleFonts.raleway(
                              color: const Color(0xFFCD4F69),
                              fontWeight: FontWeight.w200,
                              fontSize: 14,
                            )
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Space in between
                  SizedBox(height:25),

                //sign-in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCD4F69),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                                fontSize: 18,
                              ),
                            )
                        ),
                      ),
                    ),
                  ),

                  //Space in between
                  SizedBox(height:20),

                //register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: GoogleFonts.raleway(
                          color: Colors.grey,
                          fontWeight: FontWeight.w200,
                          fontSize: 14,
                        )
                      ),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: Text(
                          ' Register now',
                          style: GoogleFonts.raleway(
                            color: const Color(0xFFCD4F69),
                            fontWeight: FontWeight.w200,
                            fontSize: 14,
                          )
                        ),
                      ),
                    ],
                  ),
            ],),
          )
        ),
      )
    );
  }
}