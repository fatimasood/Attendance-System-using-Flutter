import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppBar/CustomAppBar.dart';
import '../utils.dart';

class LeaveAccept extends StatefulWidget {
  const LeaveAccept({super.key});

  @override
  State<LeaveAccept> createState() => _LeaveAcceptState();
}

class _LeaveAcceptState extends State<LeaveAccept> {
  List<Map<String, String>> leaveRequests = [];

  @override
  void initState() {
    super.initState();
    _loadLeaveRequests();
  }

  Future<void> _loadLeaveRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userEmails = prefs.getStringList('leaveRequestEmails');
    List<String>? reasons = prefs.getStringList('leaveRequestReasons');

    if (userEmails != null && reasons != null) {
      setState(() {
        leaveRequests = List.generate(
          userEmails.length,
          (index) => {
            'userEmail': userEmails[index],
            'reason': reasons[index],
          },
        );
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 170,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15.0, bottom: 0),
                child: Text(
                  "Approve and Reject Leave.",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 89, 48, 170),
                    ),
                  ),
                ),
              ),
              for (var record in leaveRequests)
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 12, 21, 9),
                  child: Container(
                    width: 340,
                    height: 200,
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
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        title: Text(
                          'Email: ${record['userEmail']}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason: ${record['reason']}',
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color: Colors.green.shade700,
                                size: 20,
                              ),
                              onPressed: () {
                                Utils().toastMessage('Accepted...!!');
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.thumb_down,
                                color: Colors.red.shade800,
                                size: 20,
                              ),
                              onPressed: () {
                                Utils().toastMessage('Rejected...!!');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
