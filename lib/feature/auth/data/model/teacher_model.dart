import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player_app/feature/auth/data/model/socialmedia_model.dart';

class Teacher {
  String id;
  String name;
  String code;
  String platform;
  bool isActive;
  Timestamp createdAt;
  SocialMedia socialMedia;

  Teacher({
    required this.id,
    required this.name,
    required this.code,
    required this.platform,
    required this.isActive,
    required this.createdAt,
    required this.socialMedia,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      platform: json['platform'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      socialMedia: SocialMedia.fromJson(json['socialMedia']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'platform': platform,
      'isActive': isActive,
      'createdAt': createdAt,
      'socialMedia': socialMedia.toJson(),
    };
  }
}
