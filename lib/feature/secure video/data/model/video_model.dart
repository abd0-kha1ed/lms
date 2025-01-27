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
  final DateTime? approvedAt;
  final bool isVideoVisible;
  final bool isVideoExpirable;
  final DateTime? expiryDate;
  final Timestamp createdAt;
  final bool hasCodes;
  final List<String>? codes;
  final bool isViewableOnPlatformIfEncrypted;

  /// Constructor
  VideoModel({
    required this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    required this.grade,
    required this.uploaderName,
    required this.videoDuration,
    required this.isVideoVisible,
    required this.isVideoExpirable,
    this.isApproved,
    this.approvedAt,
    this.expiryDate,
    required this.createdAt,
    required this.hasCodes,
    this.codes,
    required this.isViewableOnPlatformIfEncrypted,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description ?? '',
      'videoUrl': videoUrl,
      'grade': grade,
      'uploaderName': uploaderName,
      'videoDuration': videoDuration,
      'isApproved': isApproved,
      'approvedAt': approvedAt?.toIso8601String(),
      'isVideoVisible': isVideoVisible,
      'isVideoExpirable': isVideoExpirable,
      'expiryDate': expiryDate?.toIso8601String(),
      'createdAt': createdAt,
      'hasCodes': hasCodes,
      'codes': codes ?? [],
      'isViewableOnPlatformIfEncrypted': isViewableOnPlatformIfEncrypted,
    };
  }

  /// Create from Map (Firestore data)
  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] ?? '', // Default to empty string if id is missing
      title: map['title'] ?? '',
      description: map['description'],
      videoUrl: map['videoUrl'] ?? '',
      grade: map['grade'] ?? '',
      uploaderName: map['uploaderName'] ?? '',
      videoDuration: map['videoDuration'] ?? '',
      isVideoVisible: map['isVideoVisible'] ?? false,
      isVideoExpirable: map['isVideoExpirable'] ?? false,
      isApproved: map['isApproved'],
      approvedAt: map['approvedAt'] != null
          ? DateTime.parse(map['approvedAt'])
          : null,
      expiryDate: map['expiryDate'] != null
          ? DateTime.parse(map['expiryDate'])
          : null,
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
      hasCodes: map['hasCodes'] ?? false,
      codes: map['codes'] != null ? List<String>.from(map['codes']) : [],
      isViewableOnPlatformIfEncrypted:
          map['isViewableOnPlatformIfEncrypted'] ?? false,
    );
  }
}
