import 'dart:async';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/resources/color_manger.dart';

import '../main.dart';
import 'homepage.dart';

class Verifying_Email extends StatefulWidget {
  const Verifying_Email({Key? key}) : super(key: key);

  @override
  State<Verifying_Email> createState() => _Verifying_EmailState();
}

class _Verifying_EmailState extends State<Verifying_Email> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser;
    user?.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkVerifyingEmail();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration:  BoxDecoration(
          image: DecorationImage(
            image:the?const AssetImage("assets/images/dark.jpg"):const AssetImage('assets/images/pg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.red,
              radius: 70,
              child: Icon(Icons.verified_outlined, size: 79),),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('We Send Verification Link To ${user?.email}',
                style: GoogleFonts.vesperLibre(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600
                ),),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
                onPressed: () async {
                LaunchApp.openApp(
                  androidPackageName:'com.google.android.gm',
                  openStore: true
                );
                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.white),
                  textStyle: MaterialStateProperty.all(
                      GoogleFonts.acme(fontSize: 17)),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal:
                        MediaQuery
                            .of(context)
                            .size
                            .width / 4),),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                            color: ColorManager.primary, width: 1.5)),
                  ),
                  elevation: MaterialStateProperty.all(3),
                ),
                child: Text(
                  'Check Your Email'.tr,
                  style: GoogleFonts.archivo(
                      color: the?ColorManager.darkPrimary: ColorManager.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900
                  ),
                )),
          ],
        )),
      ),
    );
  }

  Future<void> checkVerifyingEmail() async {
    user = auth.currentUser;
    await user?.reload();
    if (user!.emailVerified) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  const HomePage()));
    }

  }

}
