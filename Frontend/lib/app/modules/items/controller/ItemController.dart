import 'package:get/get.dart';
import 'package:qodra/app/data/storage/local_storage.dart';
import 'package:restart_app/restart_app.dart';
class ItemController extends GetxController{
  bool? _isDark;

  setIsDark(bool value){
    _isDark=value;
    LocalStorage.setTheme(value);
     Restart.restartApp();
    print('dark value  =>'+_isDark.toString());
    update();
  }

  bool get isDark=>_isDark??false;

  }

