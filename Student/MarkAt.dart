import 'dart:io';

import 'package:attendence_sys/AppBar/CustomAppBar.dart';
import 'package:attendence_sys/Student/databaseHelper.dart';
import 'package:attendence_sys/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

String? loggedInUserEmail = userMail;

class MarkAttendence extends StatefulWidget {
  final AttendanceRecord? attendanceRecord; // Add this line

  const MarkAttendence({Key? key, this.attendanceRecord})
      : super(key: key); // Modify the constructor

  @override
  State<MarkAttendence> createState() => _MarkAttendenceState();
}

class _MarkAttendenceState extends State<MarkAttendence> {
  bool _isEditable = true;
  final _databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _regNumberController;
  late TextEditingController _classController;
  late TextEditingController _dateController;
  bool _isPresent = true;

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //_databaseHelper.initializeDatabase();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _regNumberController = TextEditingController();
    _classController = TextEditingController();
    _dateController = TextEditingController(text: DateTime.now().toString());
  }

  @override
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
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 30.0,
                                )
                              : null,
                        ),
                      ),
                      buildInputField(
                          controller: _firstNameController,
                          hintText: 'First Name',
                          enabled: _isEditable),
                      SizedBox(height: 2),
                      buildInputField(
                          controller: _lastNameController,
                          hintText: 'Last Name',
                          enabled: _isEditable),
                      SizedBox(height: 2),
                      buildInputField(
                          hintText: 'Registration Number',
                          enabled: _isEditable),
                      SizedBox(height: 2),
                      buildInputField(
                          hintText: 'Class with Section', enabled: _isEditable),
                      SizedBox(
                        height: 13,
                      ),
                      Container(
                        width: 300,
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text(
                                "Present",
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Radio(
                                  value: true,
                                  groupValue: _isPresent && _isEditable,
                                  onChanged: _isEditable
                                      ? (ValueKey) {
                                          setState(() {
                                            _isPresent = ValueKey as bool;
                                          });
                                        }
                                      : null),
                              SizedBox(
                                height: 15,
                                width: 20,
                              ),
                              Text(
                                "Absent",
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Radio(
                                  value: false,
                                  groupValue: _isPresent && _isEditable,
                                  onChanged: _isEditable
                                      ? (ValueKey) {
                                          setState(() {
                                            _isPresent = ValueKey as bool;
                                          });
                                        }
                                      : null),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 35),
                      SizedBox(
                        height: 40,
                        width: 140,
                        child: InkWell(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xffc780ff),
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isEditable = false;
                                  });
                                  _markAttendence();
                                }
                              }),
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

  void _markAttendence() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String name = '$firstName$lastName';
    print("Login mail is: ,$loggedInUserEmail");
    if (loggedInUserEmail!.contains('@student.com')) {
      final existingRecord = await _databaseHelper.getAttendanceRecordByName(
        _firstNameController.text,
        _lastNameController.text,
      );
      if (existingRecord != null &&
          DateTime.now().difference(existingRecord.date).inHours < 24) {
        // Attendance already marked for the same name within the last 24 hours
        Utils().toastMessage(
            'Attendance already marked for this person in the last 24 hours!');
      } else {
        final record = AttendanceRecord(
          id: null,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          regNum: _regNumberController.text,
          className: _classController.text,
          date: DateTime.parse(_dateController.text),
          isPresent: _isPresent,
        );

        try {
          await _databaseHelper.initializeDatabase();
          await _databaseHelper.insertAttendanceRecord(record);
          Utils().toastMessage('Saved Successfully!');
        } catch (e) {
          Utils().toastMessage('Error! data not saved');
        }
      }
    } else if (loggedInUserEmail!.contains('@admin.com')) {
      print("Login mail is: ,$loggedInUserEmail");
      final existingRecord = await _databaseHelper.getAttendanceRecordByName(
        _firstNameController.text,
        _lastNameController.text,
      );
      if (existingRecord != null &&
          DateTime.now().difference(existingRecord.date).inHours < 24) {
        // Attendance already marked for the same name within the last 24 hours
        Utils().toastMessage(
            'Attendance already marked for this person in the last 24 hours!');
      } else {
        final record = AttendanceRecord(
          id: null,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          regNum: _regNumberController.text,
          className: _classController.text,
          date: DateTime.parse(_dateController.text),
          isPresent: _isPresent,
        );

        try {
          await _databaseHelper.initializeDatabase();
          await _databaseHelper.insertAttendanceRecord(record);
          Utils().toastMessage('Saved Successfully!');
        } catch (e) {
          Utils().toastMessage('Error! data not saved');
        }
      }
    } else {
      Utils().toastMessage('You can only mark attendance for yourself.');
    }
  }

  Widget buildInputField({
    TextEditingController? controller,
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
        ));
  }
}

class AttendanceRecord {
  int? id;
  String firstName, lastName, regNum, className;
  DateTime date;
  bool isPresent;

  AttendanceRecord({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.regNum,
    required this.className,
    required this.date,
    required this.isPresent,
  });
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'firstName': firstName,
      'lastName': lastName,
      'registrationNumber': regNum,
      'className': className,
      'date': date.toIso8601String(),
      'isPresent': isPresent ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
