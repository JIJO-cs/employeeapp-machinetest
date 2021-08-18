import 'package:flutter/material.dart';
import 'package:machine_test/api/myserverutils.dart';
import 'package:machine_test/model/EmployeeDetails.dart';
import 'package:machine_test/model/RespObj.dart';
import 'package:machine_test/utils/sharedprefs_util.dart';

class EmployeeDetailsProvider extends ChangeNotifier {
  List<EmployeeDetails> allEmployees = [];
  bool loading = false;

  getEmployeeDetails(context) async {
    loading = true;

  if (await SharedPrefsUtil.getBool(SharedPrefsUtil.SP_IS_FETCH_DATA)) {
         allEmployees = await myServer.getTablesFromLocalDB();
    }
  else{
       allEmployees = await myServer.getData('5d565297300000680030a986');
  }
   
    loading = false;

    notifyListeners();
  }
}
