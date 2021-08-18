

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperEmployeeList {
  static final _databaseName = "employees.db";
  static final _databaseVersion = 1;
  
  static final String employeeList = "employee_List";

  static final String employeeID = "employee_ID";

  static final String employeeName = "employee_Name";

  static final String employeeUserName = "employee_UserName";

  static final String employeeEmail = "employee_Email";

  static final String employeeProfileImage = "employee_ProfileImage";

  static final String employeeAddress  = "employee_Address";

  static final String employeePhone  = "employee_Phone";

  static final String employeeWebSite  = "employee_WebSite";

  static final String employeeCompany  = "employee_Company";




  String queryCrateEmployeeList = '''
CREATE TABLE $employeeList(
$employeeID INTEGER,  
$employeeName  TEXT,
$employeeUserName  TEXT,
$employeeEmail  TEXT,
$employeeProfileImage  TEXT,
$employeeAddress  TEXT,
$employeePhone  INTEGER,
$employeeWebSite  TEXT,
$employeeCompany TEXT
);
''';


// make this a singleton class
  DatabaseHelperEmployeeList._privateConstructor();

  static final DatabaseHelperEmployeeList instance =
      DatabaseHelperEmployeeList._privateConstructor();

// only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
// lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

// this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate); //,onUpgrade: onUpgrade
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(queryCrateEmployeeList);
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }


  Future<List<Map<String, dynamic>>> getEmployeeLists(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> deleteAll(String table) async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}