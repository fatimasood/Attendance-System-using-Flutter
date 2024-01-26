import 'package:attendence_sys/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppBar/CustomAppBar.dart';
import '../utils.dart';

String? loggedInUserEmail = userMail;

class LeaveReq extends StatefulWidget {
  const LeaveReq({Key? key}) : super(key: key);

  @override
  State<LeaveReq> createState() => _LeaveReqState();
}

class _LeaveReqState extends State<LeaveReq> {
  final TextEditingController _paragraphController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(height: 170),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 6.0, bottom: 0),
                child: Text(
                  "Write a reason briefly in 2 to 3 lines for Leave.",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 89, 48, 170),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      buildInputField(
                        controller: _emailController,
                        hintText: 'Write your mail here',
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          width: 340,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(248, 238, 238, 238),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3f000000),
                                offset: Offset(0, 4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _paragraphController,
                                  onChanged: (text) {
                                    int lines =
                                        '\n'.allMatches(text).length + 1;
                                    if (lines >= 4) {
                                      setState(() {
                                        Utils().toastMessage(
                                            'Write your reason shortly!');
                                      });
                                    }
                                  },
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    labelText: 'Reason...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        height: 40,
                        width: 140,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc780ff),
                          ),
                          child: Text(
                            "Submit",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffdde6ed),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              if (_paragraphController.text.isNotEmpty) {
                                if (_emailController.text ==
                                    loggedInUserEmail) {
                                  saveLeaveRequestToSharedPreferences(
                                    loggedInUserEmail!,
                                    _paragraphController.text,
                                  );
                                  Utils().toastMessage(
                                      'Leave request submitted successfully!');
                                } else {
                                  Utils().toastMessage(
                                      'You submit Leave for Yourself!');
                                }
                              } else {
                                Utils()
                                    .toastMessage('Please provide a reason!');
                              }
                            } catch (e) {
                              print('Error in onPressed: $e');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveLeaveRequestToSharedPreferences(
      String userEmail, String reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userEmails = prefs.getStringList('leaveRequestEmails') ?? [];
    List<String>? reasons = prefs.getStringList('leaveRequestReasons') ?? [];

    userEmails.add(userEmail);
    reasons.add(reason);

    prefs.setStringList('leaveRequestEmails', userEmails);
    prefs.setStringList('leaveRequestReasons', reasons);
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 21, 9),
      child: Container(
        width: 326,
        height: 50,
        decoration: BoxDecoration(
          color: Color.fromARGB(248, 238, 238, 238),
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
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 8.0, left: 15),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
