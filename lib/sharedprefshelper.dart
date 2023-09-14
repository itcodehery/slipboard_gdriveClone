import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

class SharedPreferencesHelper {
  static Future<void> saveMap(Map<String, String> map, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(map);
    prefs.setString(key, jsonString);
  }

  static Future<void> saveUploadTimeData(
      Map<String, DateTime> map, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(map);
    prefs.setString(key, jsonString);
  }

  static Future<Map<String, DateTime>> getUploadTimeMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return Map<String, DateTime>.from(json.decode(jsonString));
    } else {
      return {};
    }
  }

  static Future<Map<String, String>> getMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return Map<String, String>.from(json.decode(jsonString));
    } else {
      return {};
    }
  }

  static Future<bool> isMapEmpty(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) {
      return true;
    } else {
      return false;
    }
  }
}
