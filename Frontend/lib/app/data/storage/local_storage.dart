import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:qodra/app/data/models/login_model.dart';

class LocalStorage {
  static final GetStorage _box = GetStorage();
  static const String languageKey = 'language';

  // static const String apiToken = 'token';
  static const String loginKey = 'loginKey';
  static const String userModel = 'userModel';
  static const String themeKey = 'themeKey';
  static Future init() async {
    await GetStorage.init();
    if (GetStorage().read(languageKey) == null) {
      await setString(languageKey, 'ar');
    }
  }

  static setTheme(bool value)async{
    // isDArk=value;
    await setBool(themeKey, value);
  }

  static bool getTheme= getBool(themeKey);

  // static String getUserToken = getString(apiToken) ?? 'No Token';

  static bool isAr = GetStorage().read(languageKey) == 'ar';

  static bool isDArk = GetStorage().read(themeKey) ==true;

  static Future<void> saveLocale(String langCode) async {
    Get.log('lang  =>'+langCode);
     await setString(languageKey, langCode);
  }


  static bool isLoggedIn = getBool(loginKey);

  // static LoginModel? getUser = getString(userModel) != null
  //     ? LoginModel.fromJson(jsonDecode(
  //         getString(userModel) ?? '{}',
  //       ))
  //     : null;

  static Future<void> saveUser(LoginModel model) async {
    await setBool(loginKey, true);
    await setString(userModel, jsonEncode(model.toJson()));
    await setString('model', jsonEncode(model.toJson()));
    await setString('name', model.name??'');
    await setString('name', model.name??'');
    Get.log('user ${ isLoggedIn}  is saved to local storage');
    Get.log('user ${ getString(userModel).toString()} saved to local storage');
  }

  /// ===========================================================
  static Future setString(String key, String value) async {
    await GetStorage().write(key, value);
  }

  static String? getString(String key) {
    String? value = GetStorage().read(key);
    return value;
  }

  static Future setBool(String key, bool value) async {
    await GetStorage().write(key, value);
  }

  static bool getBool(String key) {
    bool? value = GetStorage().read(key);
    return value ?? false;
  }

  static setInt(String key, int value) async {
    await GetStorage().write(key, value);
  }

  static int getInt(String key) {
    return GetStorage().read(key) ?? 0;
  }

  static Future<void> signOut() async {
    await _box.erase();
  }




}
