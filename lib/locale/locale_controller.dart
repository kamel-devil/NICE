import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLocaleController extends GetxController{
   Locale? intialLang = Get.deviceLocale;
  void changeLang(String codeLang){
    Locale locale = Locale(codeLang);
    Get.updateLocale(locale);
  }
  String? val;
  Future get_data()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    val = prefs.getString('status') ?? 'device';
    return prefs.getString('status');
  }
}