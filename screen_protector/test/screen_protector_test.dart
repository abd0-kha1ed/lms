import 'package:flutter_test/flutter_test.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:screen_protector/screen_protector_platform_interface.dart';
import 'package:screen_protector/screen_protector_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenProtectorPlatform
    with MockPlatformInterfaceMixin
    implements ScreenProtectorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ScreenProtectorPlatform initialPlatform = ScreenProtectorPlatform.instance;

  test('$MethodChannelScreenProtector is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenProtector>());
  });

  test('getPlatformVersion', () async {
    MockScreenProtectorPlatform fakePlatform = MockScreenProtectorPlatform();
    ScreenProtectorPlatform.instance = fakePlatform;

    expect(await ScreenProtector.enableScreenProtection(), '42');
  });
}
