import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  bool _passwordVisible = false;


  @override
  void initState() {
    _passwordVisible = false;
  }

  Future signUp() async {
    if (passwordConfirmed()) {

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

      // Create User
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      );

      //Add User details
      addUserDetails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        int.parse(_ageController.text.trim()),
      );

      Navigator.of(context).pop();
    }
  }

  Future addUserDetails(String firstName, String lastName, String email, int age) async {
    await FirebaseFirestore.instance.collection('Users')
      .add({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'age': age,
      }
    );
  }

  bool passwordConfirmed(){
    if (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
      return true;
    }
    else {
      return false;
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/backgrounds/Register Screen.png"),
              fit: BoxFit.fill
          )
      ),
      child: Scaffold(
          backgroundColor: const Color(0x00ffffff),
          body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Greeting Message
                      Text(
                        'PALANTIR',
                        style: GoogleFonts.raleway(
                          color: const Color(0xff204E7A),
                          fontWeight: FontWeight.w200,
                          fontSize: 50,
                        ),
                      ),
                      SizedBox(height:10),
                      Text(
                        'Fill in the following fields',
                        style: GoogleFonts.raleway(
                          color: const Color(0xff204E7A),
                          fontWeight: FontWeight.w200,
                          fontSize: 20,
                        ),
                      ),

                      //Space in between
                      SizedBox(height:50),

                      //firstname textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            hintText: 'Your First Name',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),

                      //Space in between
                      SizedBox(height:10),

                      //lastname textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            hintText: 'Your Last Name',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),

                      //Space in between
                      SizedBox(height:10),

                      //age textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            hintText: 'Your Age',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),

                      //Space in between
                      SizedBox(height:10),

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
                          obscureText: !_passwordVisible,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            hintText: 'password',
                            fillColor: Colors.grey[200],
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color:const Color(0xff51AFBA),
                              ),
                              onPressed: () {
                                // Update the state i.e. toggle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      //Space in between
                      SizedBox(height:10),

                      //confirm password textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          obscureText: true,
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            hintText: 'confirm password',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),

                      //Space in between
                      SizedBox(height:25),

                      //sign-up button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: GestureDetector(
                          onTap: signUp,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF51AFBA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                                child: Text(
                                  'Sign Up',
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
                              'Already have an account?',
                              style: GoogleFonts.raleway(
                                color: const Color(0xAA51AFBA),
                                fontWeight: FontWeight.w300,
                                fontSize: 16
                              )
                          ),
                          GestureDetector(
                            onTap: widget.showLoginPage,
                            child: Text(
                                ' Login',
                                style: GoogleFonts.raleway(
                                  color: const Color(0xFF51AFBA),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16
                                )
                            ),
                          ),
                        ],
                      ),
                    ],),
                )
            ),
          )
      ),
    );
  }
}
