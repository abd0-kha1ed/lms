import 'package:flutter/services.dart';

class ScreenProtector {
  static const MethodChannel _channel = MethodChannel('screen_protector');

  /// تفعيل حماية الشاشة لمنع التصوير على Windows
  static Future<bool> enableScreenProtection() async {
    try {
      final bool result = await _channel.invokeMethod('enableScreenProtection');
      return result;
    } catch (e) {
      print("Error enabling screen protection: $e");
      return false;
    }
  }

  /// تعطيل حماية الشاشة (اختياري)
  static Future<bool> disableScreenProtection() async {
    try {
      final bool result = await _channel.invokeMethod('disableScreenProtection');
      return result;
    } catch (e) {
      print("Error disabling screen protection: $e");
      return false;
    }
  }
}
