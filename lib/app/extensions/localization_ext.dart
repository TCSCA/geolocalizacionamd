import 'dart:ui';
import 'package:flutter/material.dart' show BuildContext, Localizations;
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;

extension Localization on BuildContext {
  AppLocalizations get appLocalization => AppLocalizations.of(this)!;
  Locale get localization => Localizations.localeOf(this);
}
