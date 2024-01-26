import 'dart:async';

import 'package:attendence_sys/Student/MarkAt.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late Database _database;

class DatabaseHelper {
  Future<void> initializeDatabase() async {
    String path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'attendence_database.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE attendence_records(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT,
            lastName TEXT,
            registrationNumber TEXT,
            className TEXT,
        
            date TEXT,
            isPresent INTEGER
          )
        ''');
      },
      version: 2,
    );
  }

//insert record
  Future<void> insertAttendanceRecord(AttendanceRecord record) async {
    await _database.insert('attendence_records', record.toMap());
  }

//delete record

  Future<void> deleteAttendanceRecord(DateTime date) async {
    print('Deleting records for date: $date');
    await _database.delete(
      'attendence_records',
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );
  }

//all record

  Future<List<AttendanceRecord>> getAllAttendanceRecordsForUser(
      String userName) async {
    final List<Map<String, dynamic>> records = await _database.query(
      'attendence_records',
      where: 'firstName || lastName = ?',
      whereArgs: [userName],
      orderBy: 'date DESC',
    );

    return records.map((record) {
      return AttendanceRecord(
        firstName: record['firstName'],
        lastName: record['lastName'],
        regNum: record['registrationNumber'],
        className: record['className'],
        //req: record['req'],
        date: DateTime.parse(record['date']),
        isPresent: record['isPresent'] == 1,
      );
    }).toList();
  }

// all record
  Future<List<AttendanceRecord>> getAllAttendanceRecords() async {
    final List<Map<String, dynamic>> records = await _database.query(
      'attendence_records',
      orderBy: 'date DESC',
    );

    return records.map((record) {
      return AttendanceRecord(
        firstName: record['firstName'],
        lastName: record['lastName'],
        regNum: record['registrationNumber'],
        className: record['className'],
        //req: record['req'],
        date: DateTime.parse(record['date']),
        isPresent: record['isPresent'] == 1,
      );
    }).toList();
  }

//update record
  Future<void> updateAttendanceRecord(AttendanceRecord record) async {
    await _database.update(
      'attendence_records',
      {
        'firstName': record.firstName,
        'lastName': record.lastName,
        'registrationNumber': record.regNum,
        'className': record.className,
        'date': record.date.toIso8601String(),
        'isPresent': record.isPresent ? 1 : 0,
      },
      where: 'firstName = ? AND lastName = ? ',
      whereArgs: [
        record.firstName,
        record.lastName,
        // record.date.toIso8601String(),
      ],
    );
  }

  Future<AttendanceRecord?> getAttendanceRecordByNameAndDate(
      String firstName, String lastName, DateTime date) async {
    print('Searching for: $firstName $lastName on $date');

    final List<Map<String, dynamic>> records = await _database.query(
      'attendence_records',
      where: 'LOWER(firstName) = ? AND LOWER(lastName) = ? AND date = ?',
      whereArgs: [
        firstName.toLowerCase(),
        lastName.toLowerCase(),
        DateFormat('yyyy-MM-dd').format(date),
      ],
      limit: 1,
    );

    if (records.isNotEmpty) {
      print('Record found:');
      print(records[0]); // Print the found record for more details
      return AttendanceRecord(
        firstName: records[0]['firstName'],
        lastName: records[0]['lastName'],
        regNum: records[0]['registrationNumber'],
        className: records[0]['className'],
        //req: records[0]['req'],
        date: DateTime.parse(records[0]['date']),
        isPresent: records[0]['isPresent'] == 1,
      );
    } else {
      print('No record found for: $firstName $lastName on $date');
      return null;
    }
  }

  Future<AttendanceRecord?> getAttendanceRecordByName(
      String firstName, String lastName) async {
    final List<Map<String, dynamic>> records = await _database.query(
      'attendence_records',
      where: 'LOWER(firstName) = ? AND LOWER(lastName) = ?',
      whereArgs: [firstName.toLowerCase(), lastName.toLowerCase()],

      orderBy:
          'date DESC', // Order by date in descending order to get the latest record first
      limit: 1, // Limit set
    );

    if (records.isNotEmpty) {
      return AttendanceRecord(
        firstName: records[0]['firstName'],
        lastName: records[0]['lastName'],
        regNum: records[0]['registrationNumber'],
        className: records[0]['className'],
        //req: records[0]['req'],
        date: DateTime.parse(records[0]['date']),
        isPresent: records[0]['isPresent'] == 1,
      );
    } else {
      return null;
    }
  }

  Future<List<AttendanceRecord>> getAllLeaveRequests() async {
    try {
      final List<Map<String, dynamic>> records =
          await _database.query('attendence_records', orderBy: 'id DESC');

      print('Leave Requests: $records');

      return records.map((record) {
        return AttendanceRecord(
          id: record['id'],
          // req: record['req'],
          firstName: record['firstName'],
          lastName: record['lastName'],
          regNum: record['registrationNumber'],
          className: record['className'],
          date: DateTime.parse(record['date']),
          isPresent: record['isPresent'] == 1,
        );
      }).toList();
    } catch (e) {
      print('Error getting leave requests: $e');
      return [];
    }
  }

  Future<void> saveLeaveRequest(String userEmail, String reason) async {
    await _database.insert('leave_requests', {
      'email': userEmail,
      'reason': reason,
    });
  }
}
