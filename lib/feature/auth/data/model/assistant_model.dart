// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class AssistantModel extends Equatable {
  final String id;
  final String code;
  final String name;
  final String phone;
  final String email;
  final String password;
  final String teacherCode;

  @JsonKey(fromJson: _lastCheckFromJson, toJson: _lastCheckToJson)
  final Timestamp? lastCheckedInAt;

  const AssistantModel({
    required this.id,
    required this.code,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.teacherCode,
    required this.lastCheckedInAt,
  });

  // From JSON
  factory AssistantModel.fromJson(Map<String, dynamic> json) {
    return AssistantModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      teacherCode: json['teacherCode'] as String,
      lastCheckedInAt: json['lastCheckedInAt'] as Timestamp,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'teacherCode': teacherCode,
      'lastCheckedInAt': lastCheckedInAt,
    };
  }

  @override
  List<Object?> get props =>
      [id, code, name, phone, email, teacherCode, lastCheckedInAt];

  // Helper functions for Firebase Timestamp serialization
  static Timestamp _lastCheckFromJson(Timestamp timestamp) => timestamp;
  static Timestamp _lastCheckToJson(Timestamp timestamp) => timestamp;
}
