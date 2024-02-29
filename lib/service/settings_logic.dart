import 'package:flutter/material.dart';
import 'package:material_3_demo/service/platform_info.dart';
import 'package:material_3_demo/service/save_load_mixin.dart';

import '../main.dart';

class SettingsLogic with ThrottledSaveLoadMixin {
  @override
  String get fileName => 'settings.dat';

  late final hasCompletedOnboarding = ValueNotifier<bool>(false)
    ..addListener(scheduleSave);
  late final hasDismissedSearchMessage = ValueNotifier<bool>(false)
    ..addListener(scheduleSave);
  late final isSearchPanelOpen = ValueNotifier<bool>(true)
    ..addListener(scheduleSave);
  late final currentLocale = ValueNotifier<String?>(null)
    ..addListener(scheduleSave);

  final bool useBlurs = !PlatformInfo.isAndroid;

  @override
  void copyFromJson(Map<String, dynamic> value) {
    hasCompletedOnboarding.value =
        value['hasCompletedOnboarding'] as bool ?? false;
    hasDismissedSearchMessage.value =
        value['hasDismissedSearchMessage'] as bool ?? false;
    currentLocale.value = value['currentLocale'] as String;
    isSearchPanelOpen.value = value['isSearchPanelOpen'] as bool ?? false;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'hasCompletedOnboarding': hasCompletedOnboarding.value,
      'hasDismissedSearchMessage': hasDismissedSearchMessage.value,
      'currentLocale': currentLocale.value,
      'isSearchPanelOpen': isSearchPanelOpen.value,
    };
  }

  Future<void> changeLocale(Locale value) async {
    currentLocale.value = value.languageCode;
    await localeLogic.loadIfChanged(value);
    // Re-init controllers that have some cached data that is localized
    // wondersLogic.init();
    // timelineLogic.init();
  }
}
