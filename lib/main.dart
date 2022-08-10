import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:project/locale/locale.dart';
import 'package:project/pages/fristpage.dart';
import 'package:project/pages/homepage.dart';

import 'bloc/blocc/bloc.dart';


bool? isLogin;
bool the = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  the =SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BlocPage()..getUserData()..getAllUsers()..getMyCurrentLocation()),
      ],
      child: OverlaySupport(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Get.deviceLocale,
          translations: mylocale(),
          themeMode: ThemeMode.system,
            home: isLogin == false ? const first_screen() : const HomePage(),
          //home: HospitalDetails(),
        ),
      ),
    );
  }
}
