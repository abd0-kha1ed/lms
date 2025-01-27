import 'package:cloud_firestore/cloud_firestore.dart';

class CodeModel {
  final String code;
  final bool isUsed;
  final String videoId;
  final Timestamp createdAt;
  final Timestamp? usedAt;
  final String? usedBy;

  CodeModel({
    required this.code,
    required this.isUsed,
    required this.videoId,
    required this.createdAt,
    this.usedAt,
    this.usedBy,
  });

  factory CodeModel.fromFirestore(Map<String, dynamic> data) {
    return CodeModel(
      code: data['code'] ?? '',
      isUsed: data['isUsed'] ?? false,
      videoId: data['videoId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      usedAt: data['usedAt'],
      usedBy: data['usedBy'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'isUsed': isUsed,
      'videoId': videoId,
      'createdAt': createdAt,
      'usedAt': usedAt,
      'usedBy': usedBy,
    };
  }
}
