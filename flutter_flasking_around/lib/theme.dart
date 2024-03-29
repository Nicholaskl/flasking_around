// Gotten from fluent documentation

import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:system_theme/system_theme.dart';

import 'package:flutter/material.dart';

enum NavigationIndicators { sticky, end }

class AppTheme extends ChangeNotifier {
  Color color = Colors.deepPurpleAccent;
  TextDirection textDirection = TextDirection.ltr;
  WindowEffect windowEffect = WindowEffect.disabled;

  TextStyle menuFont = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600
  );

  Locale? _locale;
  Locale? get locale => _locale;
  set locale(Locale? locale) {
    _locale = locale;
    notifyListeners();
  }
}