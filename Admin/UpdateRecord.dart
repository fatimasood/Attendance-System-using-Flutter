import 'package:attendence_sys/AppBar/CustomAppBar.dart';
import 'package:attendence_sys/Student/MarkAt.dart';
import 'package:attendence_sys/Student/databaseHelper.dart';
import 'package:attendence_sys/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateRecord extends StatefulWidget {
  const UpdateRecord({Key? key}) : super(key: key);

  @override
  _UpdateRecordState createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _registrationNumberController = TextEditingController();
  TextEditingController _classNameController = TextEditingController();

  TextEditingController _dateController = TextEditingController();

  bool _isEditable = true;
  bool _isPresent = true;

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
                padding:
                    const EdgeInsets.only(left: 20, top: 15.0, bottom: 5.8),
                child: Text(
                  "For Confirmation Enter Full Name of the student and Confirm for which date you want to update ",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 89, 48, 170),
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    buildInputField(
                      controller: _firstNameController,
                      hintText: 'First Name',
                      enabled: _isEditable,
                    ),
                    SizedBox(height: 2),
                    buildInputField(
                      controller: _lastNameController,
                      hintText: 'Last Name',
                      enabled: _isEditable,
                    ),
                    SizedBox(height: 2),
                    buildInputField(
                      controller: _dateController,
                      hintText: 'Date (YY-MM-DD)',
                      enabled: _isEditable,
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      height: 40,
                      width: 140,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xffc780ff),
                        ),
                        child: Text(
                          "Check",
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffdde6ed),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String firstName = _firstNameController.text;
                            String lastName = _lastNameController.text;
                            String regNumber =
                                _registrationNumberController.text;
                            String className = _classNameController.text;
                            String date = _dateController.text;

                            await checkAndUpdateFields(
                                firstName, lastName, date);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 60),
                    Container(
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
                                  ? (value) {
                                      setState(() {
                                        _isPresent = value as bool;
                                      });
                                    }
                                  : null,
                            ),
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
                                  ? (value) {
                                      setState(() {
                                        _isPresent = value as bool;
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    SizedBox(
                      height: 40,
                      width: 140,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xffc780ff),
                        ),
                        child: Text(
                          "Update",
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffdde6ed),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isEditable = false;
                            });
                            // Call your update function here
                            await updateRecordInDatabase();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> checkAndUpdateFields(
      String firstName, String lastName, String date) async {
    print('Checking for: $firstName $lastName on $date');

    DateTime parsedDate = DateTime.parse(date);

    final existingRecord = await _databaseHelper.getAttendanceRecordByName(
      firstName,
      lastName,
      //parsedDate,
    );

    if (existingRecord != null) {
      setState(() {
        _isPresent = existingRecord.isPresent;
        //print('Data found');
        Utils().toastMessage('Data Found, Know you can Update your record');
      });
    } else {
      Utils().toastMessage('No data found.');

      setState(() {
        _isEditable = true;
        _isPresent = true; // Reset to default value
      });
    }
  }

  Future<void> updateRecordInDatabase() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String regNumber = _registrationNumberController.text;

    // String req = _reqController.text;
    String className = _classNameController.text;
    String date = _dateController.text;

    final updatedRecord = AttendanceRecord(
      firstName: firstName,
      lastName: lastName,
      regNum: regNumber,
      className: className,

      //req: req,
      date: DateTime.parse(date),
      isPresent: _isPresent,
      // You can update other fields as needed
    );
    print('Updating record with values:');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Registration Number: $regNumber');
    print('Class Name: $className');
    print('Date: $date');
    print('Is Present: $_isPresent');

    try {
      await _databaseHelper.updateAttendanceRecord(updatedRecord);
      Utils().toastMessage('Record updated successfully!');
      Navigator.pop(context);
    } catch (error) {
      print('Error updating record: $error');
      Utils().toastMessage('Error updating record. Please try again.');
    }
  }
}
