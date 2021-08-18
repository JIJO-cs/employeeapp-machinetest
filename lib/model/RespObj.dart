import 'package:machine_test/model/EmployeeDetails.dart';

class RespObj {
  List<EmployeeDetails> employeeDetails;

  RespObj({this.employeeDetails});

  RespObj.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      employeeDetails =  [];
      json['posts'].forEach((v) {
        employeeDetails.add(new EmployeeDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employeeDetails != null) {
      data['posts'] = this.employeeDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
