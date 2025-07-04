import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_protector_platform_interface.dart';

/// An implementation of [ScreenProtectorPlatform] that uses method channels.
class MethodChannelScreenProtector extends ScreenProtectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_protector');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
