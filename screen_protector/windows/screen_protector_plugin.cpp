#include "screen_protector_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace screen_protector {

// static
void ScreenProtectorPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "screen_protector",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<ScreenProtectorPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

ScreenProtectorPlugin::ScreenProtectorPlugin() {}

ScreenProtectorPlugin::~ScreenProtectorPlugin() {}

void ScreenProtectorPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("enableScreenProtection") == 0) {
    HWND hwnd = GetForegroundWindow(); // الحصول على النافذة النشطة
    if (SetWindowDisplayAffinity(hwnd, WDA_MONITOR)) { // تفعيل الحماية
      result->Success(flutter::EncodableValue(true));
    } else {
      result->Error("ERROR", "Failed to set window display affinity");
    }
  } else {
    result->NotImplemented();
  }
}

}  // namespace screen_protector
