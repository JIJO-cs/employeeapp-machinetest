import 'dart:convert';
import 'package:http/http.dart';
import 'package:machine_test/model/EmployeeDetails.dart';
import 'package:machine_test/utils/DatabaseUtil/DBHelper.dart';
import 'package:machine_test/utils/sharedprefs_util.dart';

class MyServerUtils {
  static MyServerUtils _instance = new MyServerUtils.internal();
  MyServerUtils.internal();
  factory MyServerUtils() => _instance;
  static final baseUrl = "http://www.mocky.io/v2/";

  Future<List<EmployeeDetails>> getData(String route, {String header}) async {
    Map<String, String> mHeaders = {
      "Content-type": "application/json",
      "x-auth-token": header
    };
    try {
      Response response =
          await get(Uri.parse(baseUrl + route), headers: mHeaders);
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        _storeEmployeeDetails(response.body); // store tada to Local DB
        return EmployeeDetails.fromJson(json.decode(response.body));
      } else {
        return EmployeeDetails.fromJson(json.decode(response.body));
      }
    } catch (ex) {
      print("Exception e :" + ex.toString());
      return EmployeeDetails();
    }
  }

  Future<List<EmployeeDetails>> getTablesFromLocalDB() async {
    try {
      DatabaseHelperEmployeeList dbHelper = DatabaseHelperEmployeeList.instance;

      final response = await dbHelper
          .getEmployeeLists(DatabaseHelperEmployeeList.employeeList);
      final employees = List<EmployeeDetails>.of(
        response.map<EmployeeDetails>(
          (json) => EmployeeDetails(
            id: json['id'],
            name: json['name'],
            username: json['username'],
            address: json['address'],
            email: json['email'],
            phone: json['phone'],
            company: json['company'],
            profileImage: json['profileImage'],
            website: json['website'],
          ),
        ),
      );
      return employees;
    } catch (e) {
      throw e;
    }
  }
}

final myServer = MyServerUtils();

_storeEmployeeDetails(employees) async {
  DatabaseHelperEmployeeList dbHelper = DatabaseHelperEmployeeList.instance;
  dbHelper.deleteAll(DatabaseHelperEmployeeList.employeeList);
  //await dbHelper.insert(DatabaseHelperEmployeeList.employeeList, employees);
  employees.forEach((v) async {
    await dbHelper.insert(DatabaseHelperEmployeeList.employeeList, v);
  });

  await SharedPrefsUtil.putBool(SharedPrefsUtil.SP_IS_FETCH_DATA, true);

  print('employee details stored in DB');
}
