import 'package:cloud_firestore/cloud_firestore.dart';

class CodeModel {
  final String code;
  final bool isUsed;
  final String videoId;
  final String videoUrl;
  final Timestamp createdAt;
  final String videoDuration;

  CodeModel( {
    required this.videoDuration,
    required this.code,
    required this.isUsed,
    required this.videoId,
    required this.videoUrl,
    required this.createdAt,
  });

  factory CodeModel.empty() {
    return CodeModel(
      code: '',
      isUsed: false,
      videoId: '',
      videoUrl: '',
      videoDuration: '',
      createdAt: Timestamp.now(),
    );
  }

  factory CodeModel.fromFirestore(Map<String, dynamic> data) {
    return CodeModel(
      code: data['code'] ?? '',
      isUsed: data['isUsed'] ?? false,
      videoId: data['videoId'] ?? '',
      videoUrl: data['videoUrl'],
      videoDuration: data['videoDuration'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'isUsed': isUsed,
      'videoId': videoId,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
      'videoDuration':videoDuration
    };
  }
}
