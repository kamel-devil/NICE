
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/pages/signup.dart';
import 'package:project/widgets/button.dart';

import '../main.dart';
import '../resources/color_manger.dart';
import 'login.dart';

class first_screen extends StatelessWidget {
  const first_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 420,
              decoration: BoxDecoration(
                image:  const DecorationImage(
                    image: AssetImage(
                      'assets/images/frist.png',
                    ),
                    fit: BoxFit.fitWidth),
                color: the?ColorManager.darkPrimary: ColorManager.primary,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(100),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),

            Card(
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide( color: the?ColorManager.darkPrimary: ColorManager.primary,
                    width: 3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'WE HOPE TO BE HEALTHY'.tr,
                  style: GoogleFonts.permanentMarker(
                      fontSize: 20, color: Colors.black),
                ),
              ),
            ),

            const SizedBox(
              height: 80.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButton(
                  title: 'Login'.tr,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  },
                  color: the?ColorManager.darkPrimary: ColorManager.primary,
                  color1: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                MyButton(
                    title: 'Sign Up'.tr,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Sign_Up()));
                    },
                    color: Colors.white,
                  color1: the?ColorManager.darkPrimary: ColorManager.primary,
                )
              ],
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       width: 150,
            //       child: MaterialButton(
            //         shape:new RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(50)
            //         ) ,
            //         color: Colors.blue[900],
            //         onPressed:(){},
            //         child: Text('Login',
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w900
            //           ),
            //         ),
            //
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10.0,
            //       ),
            //     Container(
            //       width: 150,
            //       child: MaterialButton(
            //         shape: new RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(50),
            //             side: BorderSide(color: Colors.black,width:.2)
            //         ),
            //
            //
            //
            //         color: Colors.white,
            //         onPressed:(){},
            //         child: Text('Sign up',
            //           style: TextStyle(
            //               color: Colors.blue[900],
            //               fontWeight: FontWeight.w900
            //           ),
            //         ),
            //
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
