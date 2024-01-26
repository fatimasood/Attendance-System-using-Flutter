import 'package:attendence_sys/AdminStudent.dart';
import 'package:attendence_sys/authentication/SignIn.dart';
import 'package:attendence_sys/main.dart';
import 'package:attendence_sys/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Admin/AdminHome.dart';
import '../Student/StudentHome.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final _auth = FirebaseAuth.instance; //initialize firebase
  bool _passwordVisible = false; //for password visibility toggle
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
  }

  void signup() {
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      String userEmail = value.user!.email.toString();
      userMail = userEmail.toLowerCase();
      print(userEmail);
      if (userEmail.contains('@admin.com')) {
        //Admin HOme page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHome(),
          ),
        );
      } else if (userEmail.contains('@student.com')) {
        // User is a student
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentHome(),
          ),
        );
      } else {
        Utils().toastMessage('Only admin or Students can access this System');
      }
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          backgroundColor: const Color(0xffDDE6ED),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xffc780ff),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminStudent(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ATTENDENCE",
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      "SYSTEM",
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: Color(0xffc780ff),
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 35.0, right: 0, bottom: 8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Create",
                              style: GoogleFonts.jomhuria(
                                textStyle: const TextStyle(
                                  fontSize: 67,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff6617ff),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 6),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 35.0,
                      top: 0.0 + 50,
                      child: Text(
                        "Account",
                        style: GoogleFonts.jomhuria(
                          textStyle: const TextStyle(
                            fontSize: 67,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff6617ff),
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 6),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 31),
                Center(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildInputField(
                            controller: fullNameController,
                            hintText: 'Full name',
                            prefixIcon: Icons.person_2_outlined,
                            isNameField: true,
                          ),
                          // const SizedBox(height: 7),
                          buildInputField(
                            hintText: 'Email',
                            prefixIcon: Icons.mail_outline_rounded,
                            controller: emailController,
                          ),
                          //const SizedBox(height: 7),
                          buildInputField(
                            controller: passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            onTogglePassword: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            height: 40,
                            width: 140,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffc780ff),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign up",
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffdde6ed),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  signup();
                                } else {}
                              },
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 185),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6617ff),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignIn(),
                          ),
                        );
                      },
                      child: Text(
                        'Log in',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff6617ff),
                          ),
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

//for images
  Widget buildSocialIcon({required String imagePath}) {
    return Align(
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(
          imagePath,
        ),
      ),
    );
  }

  Widget buildInputField({
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    Function? onTogglePassword,
    required TextEditingController controller,
    bool isNameField = false,
  }) {
    return Container(
      //    height: 76.23,
      padding: const EdgeInsets.fromLTRB(12, 12, 21, 9),
      child: Container(
        width: 326,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3f000000),
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: TextFormField(
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          controller: controller,
          obscureText: isPassword && !_passwordVisible,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 11.28),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xffc780ff),
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: 20,
              color: Colors.black45,
            ),
            border: InputBorder.none,
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: () {
                      if (onTogglePassword != null) {
                        onTogglePassword();
                      }
                    },
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                  )
                : null,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              Fluttertoast.showToast(
                msg: isPassword
                    ? 'Kindly set any password'
                    : isNameField
                        ? 'Enter your name'
                        : 'Enter your gmail',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.deepPurple,
                textColor: Colors.white54,
                fontSize: 16.0,
              );
              return null;
            }

            if (isPassword && value.length < 6) {
              Fluttertoast.showToast(
                msg: 'Password should be at least 6 characters long',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.deepPurple,
                textColor: Colors.white54,
                fontSize: 16.0,
              );
              return null;
            }
            /* if (!isPassword && !value.endsWith('@gmail.com')) {
              Fluttertoast.showToast(
                msg: 'Enter proper gmail address',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.deepPurple,
                textColor: Colors.white54,
                fontSize: 16.0,
              );

              // Play the beep sound
              // await _audioPlayer.play('assets/beep.mp3', isLocal: true);
            }*/
            return null;
          },
        ),
      ),
    );
  }
}
