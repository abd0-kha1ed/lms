import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  String id;
  String name;
  String code;
  String phone;
  String grade;
  String teacherCode;
  String password;
  bool isPaid;
  Timestamp createdAt;

  StudentModel(
      {required this.id,
      required this.name,
      required this.code,
      required this.phone,
      required this.grade,
      required this.teacherCode,
      required this.password,
      required this.createdAt,
      required this.isPaid});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      phone: json['phone'],
      grade: json['grade'],
      teacherCode: json['teacherCode'],
      password: json['password'],
      createdAt: json['createdAt'],
      isPaid: json['ispaid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'phone': phone,
      'grade': grade,
      'teacherCode': teacherCode,
      'password': password,
      'createdAt': createdAt,
      'ispaid': isPaid,
    };
  }
}
