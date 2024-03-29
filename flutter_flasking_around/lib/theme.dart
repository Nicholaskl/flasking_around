// Gotten from fluent documentation

import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:system_theme/system_theme.dart';

import 'package:flutter/material.dart';

enum NavigationIndicators { sticky, end }

class AppTheme extends ChangeNotifier {
  Color color = Colors.deepPurpleAccent;
  Color behindColor = Colors.deepPurple.shade50;
  TextDirection textDirection = TextDirection.ltr;
  WindowEffect windowEffect = WindowEffect.disabled;

  EdgeInsets screenPadding = const EdgeInsets.only(left: 8, right: 8, top: 20);

  TextStyle menuFont = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500
  );

  TextStyle menuFontActive = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600
  );

  TextStyle pageHeading = const TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,

  );

  Locale? _locale;
  Locale? get locale => _locale;
  set locale(Locale? locale) {
    _locale = locale;
    notifyListeners();
  }
}