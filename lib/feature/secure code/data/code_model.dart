class CodeModel {
  final String code; 
  final bool isUsed; 
  final String videoId; 

  CodeModel({
    required this.code,
    required this.isUsed,
    required this.videoId,
  });

  factory CodeModel.fromFirestore(Map<String, dynamic> data) {
    return CodeModel(
      code: data['code'] ?? '',
      isUsed: data['isUsed'] ?? false,
      videoId: data['videoId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'isUsed': isUsed,
      'videoId': videoId,
    };
  }
}
