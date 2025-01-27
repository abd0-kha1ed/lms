import 'dart:math';

class CodeGenerator {
  static String generateUniqueCode() {
    // حرف عشوائي كبير (A-Z)
    String letter = String.fromCharCode(65 + Random().nextInt(26)); // 65 هو الكود الخاص بـ 'A'
    
    // أرقام عشوائية (9-10 أرقام)
    String numbers = List.generate(9 + Random().nextInt(2), (_) => Random().nextInt(10).toString()).join();
    
    return '$letter$numbers'; // دمج الحرف مع الأرقام
  }

  static List<String> generateCodes(int count) {
    Set<String> codes = {}; // استخدم Set لضمان عدم تكرار الأكواد
    while (codes.length < count) {
      codes.add(generateUniqueCode());
    }
    return codes.toList(); // تحويل Set إلى List
  }
}
