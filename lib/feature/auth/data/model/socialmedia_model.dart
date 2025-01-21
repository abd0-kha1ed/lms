class SocialMedia {
  String? facebook;
  String? instagram;
  String? youtube;
  String? whatsapp;

  SocialMedia({
    this.facebook,
    this.instagram,
    this.youtube,
    this.whatsapp,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      facebook: json['facebook'],
      instagram: json['instagram'],
      youtube: json['youtube'],
      whatsapp: json['whatsapp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebook': facebook,
      'instagram': instagram,
      'youtube': youtube,
      'whatsapp': whatsapp,
    };
  }
}
