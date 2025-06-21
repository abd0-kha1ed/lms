#include "include/screen_protector/screen_protector_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "screen_protector_plugin.h"

void ScreenProtectorPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  screen_protector::ScreenProtectorPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
