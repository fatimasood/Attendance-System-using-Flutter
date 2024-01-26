import 'package:attendence_sys/AdminStudent.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_services/firebase_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required String title});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen =
      SplashServices(); //firebase splashscreen services
  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);
    // Simulate a delay for demonstration purpose
    Future.delayed(const Duration(seconds: 6), () {
      // After the delay, navigate to the next screen
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => AdminStudent())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
                74 * 1.0, 264 * 1.0, 63 * 1.0, 384 * 1.0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1 * 1.0),
              gradient: const LinearGradient(
                begin: Alignment(-0.951, -1),
                end: Alignment(1.508, 1.437),
                colors: <Color>[
                  Color(0xff6617ff),
                  Color(0xff9d6bff),
                  Color(0xffffffff),
                  Color(0xff8048ec)
                ],
                stops: <double>[0, 0.792, 1, 1],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 130,
                width: 130,
                //child: Image.asset("lib/assets/helmet.png"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ATTENDENCE",
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "SYSTEM",
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Color(0xffd8a7ff),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
