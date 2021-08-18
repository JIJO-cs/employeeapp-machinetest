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
    List<EmployeeDetails> employeeDetails = [];
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
        _storeDatatoDataBase(response.body);
        //_storeEmployeeDetails(response.body); // store tada to Local DB
        var res = json.decode(response.body);
        List<dynamic> data = res;
        data.forEach((element) {
          employeeDetails.add(EmployeeDetails.fromJson(element));
        });
        return employeeDetails;
      } else {
        return null;
      }
    } catch (ex) {
      print("Exception e :" + ex.toString());
      return null;
    }
  }

  Future<List<EmployeeDetails>> getTablesFromLocalDB() async {
    List<EmployeeDetails> employeeDetails = [];
    try {
      DatabaseHelperEmployeeList dbHelper = DatabaseHelperEmployeeList.instance;
      // final response = await dbHelper
      //     .getEmployeeLists(DatabaseHelperEmployeeList.employeeList);
      //       print('response >>>'+ response.toString());
      final response =
          await SharedPrefsUtil.getString(SharedPrefsUtil.SP_EMPLOYEE_DATA);
      var res = json.decode(response);
      List<dynamic> data = res;
      data.forEach((element) {
        employeeDetails.add(EmployeeDetails.fromJson(element));
      });
      return employeeDetails;
    } catch (e) {
      throw e;
    }
  }
}

final myServer = MyServerUtils();

_storeDatatoDataBase(employees) async {
  await SharedPrefsUtil.putString(SharedPrefsUtil.SP_EMPLOYEE_DATA, employees);
  print('employee details stored in DB');
}

_storeEmployeeDetails(employees) async {
  DatabaseHelperEmployeeList dbHelper = DatabaseHelperEmployeeList.instance;
  dbHelper.deleteAll(DatabaseHelperEmployeeList.employeeList);
  List<dynamic> data = employees;
  data.forEach((v) async {
    await dbHelper.insert(DatabaseHelperEmployeeList.employeeList, v);
  });
  await SharedPrefsUtil.putBool(SharedPrefsUtil.SP_IS_FETCH_DATA, true);
  print('employee details stored in DB');
}
