import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_protector_method_channel.dart';

abstract class ScreenProtectorPlatform extends PlatformInterface {
  /// Constructs a ScreenProtectorPlatform.
  ScreenProtectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenProtectorPlatform _instance = MethodChannelScreenProtector();

  /// The default instance of [ScreenProtectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenProtector].
  static ScreenProtectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenProtectorPlatform] when
  /// they register themselves.
  static set instance(ScreenProtectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
