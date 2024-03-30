// Gotten from fluent documentation
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:system_theme/system_theme.dart';

import 'package:flutter/material.dart';

enum NavigationIndicators { sticky, end }

class AppTheme extends ChangeNotifier {
  ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.dark, 
    primary: Colors.deepPurpleAccent, 
    onPrimary: Colors.purple.shade50, 
    secondary: Colors.indigo.shade300, 
    onSecondary: Colors.indigo, 
    error: Colors.red, 
    onError: Colors.red.shade800, 
    background:  Colors.black, 
    onBackground: Colors.black54, 
    surface: Colors.grey.shade900, 
    onSurface: Colors.white
    );

  // Color color = Colors.deepPurpleAccent;
  // Color behindColor = Colors.deepPurple.shade50;
  TextDirection textDirection = TextDirection.ltr;
  WindowEffect windowEffect = WindowEffect.disabled;

  EdgeInsets screenPadding = const EdgeInsets.only(left: 24, right: 24, top: 32);

  TextStyle menuFont = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  TextStyle menuFontActive = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600
  );

  TextStyle pageHeading = const TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
  );

  TextStyle contentHeading = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );

  ButtonStyle buttonTheme = const ButtonStyle(
    padding: MaterialStatePropertyAll(EdgeInsets.all(16)),
    iconSize: MaterialStatePropertyAll(30),
    textStyle: MaterialStatePropertyAll(TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600
    ))
  );

  Locale? _locale;
  Locale? get locale => _locale;
  set locale(Locale? locale) {
    _locale = locale;
    notifyListeners();
  }
}