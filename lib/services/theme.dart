import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage("qxlabai");
  final _key = 'isThemeMode';

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool themeBool() => _box.read(_key) ??  true ;

  bool _loadThemeFromBox() => _box.read(_key) ?? true;

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  void toDarkTheme() {
    Get.changeThemeMode(ThemeMode.dark);
    _saveThemeToBox(true);
  }
}
