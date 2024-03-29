import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/service/settings_logic.dart';
import 'package:material_3_demo/ui/buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleSwitcher extends StatelessWidget with GetItMixin {
  LocaleSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = watchX((SettingsLogic s) => s.currentLocale);
    Future<void> handleSwapLocale() async {
      final newLocale = Locale(locale == 'en' ? 'zh' : 'en');
      await settingsLogic.changeLocale(newLocale);
    }

    var xxx = AppLocalizations.of(context)?.add_new_patient ?? "";
    return Column(
      children: [
        Text("data" + xxx),
        AppBtn.from(
            text: "localeSwapButton",
            onPressed: handleSwapLocale,
            padding: EdgeInsets.all($styles.insets.sm)),
      ],
    );
  }
}
