import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyToken = 'access_token';
  static const String _keyUser = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static late SharedPreferences _prefs;
  static final ValueNotifier<int> profileUpdateNotifier = ValueNotifier(0);

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveSession(String token, Map<String, dynamic> user) async {
    await _prefs.setString(_keyToken, token);
    await _prefs.setString(_keyUser, jsonEncode(user));
    await _prefs.setBool(_keyIsLoggedIn, true);
  }

  static Future<void> clearSession() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUser);
    await _prefs.setBool(_keyIsLoggedIn, false);
  }

  static bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;
  
  static String? get token => _prefs.getString(_keyToken);

  static String? getString(String key) => _prefs.getString(key);
  static Future<void> setString(String key, String value) async => await _prefs.setString(key, value);
  static Future<void> remove(String key) async => await _prefs.remove(key);
  
  static Map<String, dynamic>? get user {
    final userStr = _prefs.getString(_keyUser);
    if (userStr != null) {
      try {
        return jsonDecode(userStr);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static String get userName {
    final u = user;
    if (u != null) {
      final String first = u['firstName'] ?? u['name'] ?? '';
      final String last = u['lastName'] ?? '';
      if (first.isNotEmpty) return '$first $last'.trim();
    }
    return _prefs.getString('user_name') ?? 'User';
  }
  static Future<void> setUserName(String value) async {
    await _prefs.setString('user_name', value);
    profileUpdateNotifier.value++;
  }

  static String get userWard => _prefs.getString('user_ward') ?? 'Ward N/A';
  static Future<void> setUserWard(String value) async {
    await _prefs.setString('user_ward', value);
    profileUpdateNotifier.value++;
  }

  static String get userTier => _prefs.getString('user_tier') ?? 'Basic Tier';
  static Future<void> setUserTier(String value) async {
    await _prefs.setString('user_tier', value);
    profileUpdateNotifier.value++;
  }

  static String get memberId {
    final u = user;
    if (u != null) {
      final id = u['userId'] ?? u['id'] ?? u['_id'];
      if (id != null) return id.toString().substring(0, 8).toUpperCase();
    }
    return _prefs.getString('member_id') ?? 'CP-UNKNOWN';
  }
  static Future<void> setMemberId(String value) async {
    await _prefs.setString('member_id', value);
    profileUpdateNotifier.value++;
  }

  static String? get userId {
    final u = user;
    if (u != null) {
      return u['userId'] ?? u['id'] ?? u['_id'];
    }
    return null;
  }

  static const String _keyBankAccounts = 'user_bank_accounts';
  static final ValueNotifier<int> bankAccountsNotifier = ValueNotifier(0);

  static List<Map<String, String>> get bankAccounts {
    final str = _prefs.getString(_keyBankAccounts);
    if (str != null) {
      try {
        final List list = jsonDecode(str);
        return list.map((e) => Map<String, String>.from(e as Map)).toList();
      } catch (_) {}
    }
    return [
      {
        'id': 'acc_default',
        'bankName': 'First Choice Multipurpose Co-operative',
        'accountNumber': '**** 4321',
        'ifscCode': 'KSCB0002001',
        'holderName': userName,
        'type': 'Bank Account',
      }
    ];
  }

  static Future<void> addBankAccount(Map<String, String> account) async {
    final list = bankAccounts;
    list.add(account);
    await _prefs.setString(_keyBankAccounts, jsonEncode(list));
    bankAccountsNotifier.value++;
  }

  static const String _keyIsOnlineTracking = 'is_online_tracking';
  
  static bool get isOnlineTracking => _prefs.getBool(_keyIsOnlineTracking) ?? true;
  static Future<void> setIsOnlineTracking(bool value) async {
    await _prefs.setBool(_keyIsOnlineTracking, value);
    profileUpdateNotifier.value++;
  }
}
