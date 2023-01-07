// TODO: Missing Documentation

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/enums.dart';

/// [deletePreferences]
/// Deletes all the preferences
/// Used when logout or in case of authorization changed to unauthorized
///
Future<bool> deletePreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.clear();
}

/// [logoutPreferences]
/// Deletes the preferences that is related for logout process
///
Future<bool> logoutPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.remove(SharedPreferencesKeys.token.name);
}

/// [setBusinessName]
void setBusinessName(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(SharedPreferencesKeys.businessName.name, token);
}

/// [getBusinessName]
/// Retrieve the stored token if there is non return null
Future<String?> getBusinessName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(SharedPreferencesKeys.businessName.name);
}

/// [setToken]
void setToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(SharedPreferencesKeys.token.name, token);
}

/// [getToken]
/// Retrieve the stored token if there is non return null
Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(SharedPreferencesKeys.token.name);
}

///
/// [setDeviceId]
///
void setDeviceId(int deviceId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(SharedPreferencesKeys.deviceId.name, deviceId);
}

///
/// [getDeviceId]
/// Retrieve the stored device if there is non return null
///
Future<int> getDeviceId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(SharedPreferencesKeys.deviceId.name) ?? 0;
}

///
/// [setDeviceCode]
/// Set device Code
///
void setDeviceCode(String deviceCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(SharedPreferencesKeys.deviceCode.name, deviceCode);
}

///
/// [getDeviceCode]
/// Retrieve the stored device code if there is non, return null
///
Future<String?> getDeviceCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(SharedPreferencesKeys.deviceCode.name);
}

///
/// [setLastUpdate]
/// Set latest updated
///
Future<void> setLastUpdate(String lastUpdate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(SharedPreferencesKeys.lastUpdate.name, lastUpdate);
}

///
/// [getLastUpdate]
/// Retrieve the latest updated if there is non, return null
///
Future<String> getLastUpdate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(SharedPreferencesKeys.lastUpdate.name) ??
      '1997-01-01 01:01:01';
}

///
/// [deleteLastUpdate]
/// deletes the latest updated
/// return true is success
/// otherwise returns false
///
Future<bool?> deleteLastUpdate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.remove(SharedPreferencesKeys.lastUpdate.name);
}

///
/// [setSurveyId]
/// set SurveyId
///
void setSurveyId(int deviceId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(SharedPreferencesKeys.surveyId.name, deviceId);
}

///
/// [getSurveyId]
/// Retrieve the survey if there is non return 0
///
Future<int> getSurveyId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(SharedPreferencesKeys.surveyId.name) ??
      (throw Exception('No Survey Id set yet!'));
}

/// [setWiFiSsd]
/// Set device Code
void setWiFiSsd(String wiFiSsd) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(SharedPreferencesKeys.wiFiSsd.name, wiFiSsd);
}

/// [getWiFiSsd]
/// Retrieve the stored device code if there is non, return null
Future<String?> getWiFiSsd() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(SharedPreferencesKeys.wiFiSsd.name);
}

/// [setWiFiPassword]
/// Set device Code
void setWiFiPassword(String wiFiSsd) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(SharedPreferencesKeys.wiFiPassword.name, wiFiSsd);
}

/// [getWiFiPassword]
/// Retrieve the stored device code if there is non, return null
Future<String?> getWiFiPassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(SharedPreferencesKeys.wiFiPassword.name);
}

/// [setGlobalLocale]
/// Set device Code
void setGlobalLocale(String locale) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(SharedPreferencesKeys.locale.name, locale);
}

/// [getGlobalLocale]
/// Retrieve the stored device code if there is non, return null
Future<Local?> getGlobalLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? locale = prefs.getString(SharedPreferencesKeys.locale.name);
  return locale != null ? Local.ar.toLocal(locale) : null;
}

///
/// [setTermsAgreed]
/// TODO: description for the function
/// Set setService State
///
void setTermsAgreed(bool serviceStatus) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(SharedPreferencesKeys.termsAgreed.name, serviceStatus);
}

/// [getTermsAgreed]
/// TODO: description for the function
/// Retrieve the stored device Service State if there is non, return false
/// as device out of service
///
Future<bool> getTermsAgreed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(SharedPreferencesKeys.termsAgreed.name) ?? false;
}
