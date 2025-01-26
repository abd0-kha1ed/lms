import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String id; // id is mutable to allow setting it later
  final String title;
  final String? description;
  final String videoUrl;
  final String grade;
  final String videoDuration;
  final String uploaderName;
  final bool? isApproved;
  final bool isVideoVisible;
  final bool isVideoExpirable;
  final DateTime? expiryDate;
  final Timestamp createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.grade,
    required this.uploaderName,
    required this.videoDuration,
    required this.isVideoVisible,
    required this.isVideoExpirable,
    this.isApproved,
    this.expiryDate,
    required this.createdAt,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description ?? '',
      'videoUrl': videoUrl,
      'isApproved': isApproved,
      'grade': grade,
      'uploaderName': uploaderName,
      'videoDuration': videoDuration,
      'isVideoVisible': isVideoVisible,
      'isVideoExpirable': isVideoExpirable,
      'expiryDate': expiryDate?.toIso8601String(),
      'createdAt': createdAt,
    };
  }

  /// Create from Map (Firestore data)
  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] ?? '', // Default to empty string if id is missing
      title: map['title'],
      description: map['description'],
      videoUrl: map['videoUrl'],
      isApproved: map['isApproved'],
      grade: map['grade'],
      uploaderName: map['uploaderName'],
      videoDuration: map['videoDuration'],
      isVideoVisible: map['isVideoVisible'],
      isVideoExpirable: map['isVideoExpirable'],
      expiryDate:
          map['expiryDate'] != null ? DateTime.parse(map['expiryDate']) : null,
      createdAt: map['createdAt'] as Timestamp,
    );
  }
}
