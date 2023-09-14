//create a helper class for sharedpreferences to store a map of string and datetime
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

//to save a map of string and datetime to sharedpreferences
class SharedPrefMapHelper {
  static void saveMap(String key, Map<String, DateTime> map) async {
    //save map to sharedpreferences
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(map);
    prefs.setString(key, jsonString);
  }

  static Future<Map<String, DateTime>> getMap(String key) async {
    //get map from sharedpreferences
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return Map<String, DateTime>.from(json.decode(jsonString));
    } else {
      return {};
    }
  }
}
