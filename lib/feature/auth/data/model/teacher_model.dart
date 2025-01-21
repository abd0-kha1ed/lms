import 'package:video_player_app/feature/auth/data/model/socialmedia_model.dart';

class Teacher {
  String id;
  String name;
  String code;
  String platform;
  String grade;
  bool isActive;
  SocialMedia socialMedia;

  Teacher({
    required this.id,
    required this.name,
    required this.code,
    required this.platform,
    required this.grade,
    required this.isActive,
    required this.socialMedia,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      platform: json['platform'],
      grade: json['grade'],
      isActive: json['isActive'],
      socialMedia: SocialMedia.fromJson(json['socialMedia']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'platform': platform,
      'grade': grade,
      'isActive': isActive,
      'socialMedia': socialMedia.toJson(),
    };
  }
}
