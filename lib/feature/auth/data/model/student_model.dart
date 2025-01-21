class Student {
  String id;
  String name;
  String code;
  String phone;
  String grade;
  String teacherCode;
  String password;

  Student({
    required this.id,
    required this.name,
    required this.code,
    required this.phone,
    required this.grade,
    required this.teacherCode,
    required this.password,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      phone: json['phone'],
      grade: json['grade'],
      teacherCode: json['teacherCode'],
      password: json['password'],
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
    };
  }
}
