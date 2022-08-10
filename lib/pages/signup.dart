import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/pages/homepage.dart';
import 'package:project/pages/login.dart';
import 'package:project/pages/verifying_email.dart';
import 'package:project/widgets/button.dart';

import '../main.dart';
import '../resources/color_manger.dart';

class Sign_Up extends StatefulWidget {
  Sign_Up({Key? key}) : super(key: key);

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  late String _emailController;
  late String _passwordController;
  String? _phoneController;
  String? _nameController;
  CollectionReference? addUser;
  User? user = FirebaseAuth.instance.currentUser;

  GoogleSignInAccount? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: the
                ? const AssetImage("assets/images/dark.jpg")
                : const AssetImage('assets/images/pg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Image(image: AssetImage('assets/images/frist.png')),
                    Text('WE HOPE TO BE HEALTHY'.tr,
                        style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white)),
                    const SizedBox(
                      height: 15.0,
                    ),
                    buildTextFormField(
                        type: TextInputType.name,
                        onSave: () => (val) {
                              setState(() {
                                _nameController = val;
                              });
                            },
                        validate: () => (val) {
                              if (val!.isEmpty) {
                                return "Invalid Name!".tr;
                              }
                              return null;
                            },
                        hint: 'Name'.tr,
                        label: 'Name'.tr,
                        pIcon: Icon(
                          Icons.person,
                          color: the
                              ? ColorManager.darkPrimary
                              : ColorManager.primary,
                        ),
                        sIcon: Icon(
                          Icons.verified,
                          color: the
                              ? ColorManager.darkPrimary
                              : ColorManager.primary,
                        ),
                        vall: false),
                    const SizedBox(
                      height: 20.0,
                    ),
                    buildTextFormField(
                        type: TextInputType.phone,
                        onSave: () => (val) {
                              _phoneController = val;
                            },
                        validate: () => (val) {
                              if (val!.isEmpty) {
                                return "Invalid Phone!".tr;
                              }
                              return null;
                            },
                        hint: 'Phone'.tr,
                        label: 'Phone'.tr,
                        pIcon: Icon(
                          Icons.phone_android_rounded,
                          color: the
                              ? ColorManager.darkPrimary
                              : ColorManager.primary,
                        ),
                        sIcon: Icon(
                          Icons.verified,
                          color: the
                              ? ColorManager.darkPrimary
                              : ColorManager.primary,
                        ),
                        vall: false),
                    const SizedBox(
                      height: 20.0,
                    ),
                    buildTextFormField(
                        type: TextInputType.emailAddress,
                        onSave: () => (val) {
                              setState(() {
                                _emailController = val;
                              });
                            },
                        validate: () => (val) {
                              if (val!.isEmpty || !val.contains('@')) {
                                return "Invalid email!".tr;
                              }
                              return null;
                            },
                        hint: 'Enter Email'.tr,
                        label: 'Enter Email'.tr,
                        pIcon: Icon(
                          Icons.email_outlined,
                          color: the
                              ? ColorManager.darkPrimary
                              : ColorManager.primary,
                        ),
                        sIcon: Icon(
                          Icons.verified,
                          color: the
                              ? ColorManager.darkPrimary
                              : ColorManager.primary,
                        ),
                        vall: false),
                    const SizedBox(
                      height: 20.0,
                    ),
                    buildTextFormField(
                        type: TextInputType.visiblePassword,
                        validate: () => (val) {
                              if (val!.isEmpty || val.length <= 8) {
                                return "Password is too short!".tr;
                              }
                              return null;
                            },
                        onSave: () => (val) {
                              setState(() {
                                _passwordController = val;
                              });
                            },
                        hint: 'Password'.tr,
                        label: 'Password'.tr,
                        pIcon: Icon(
                          Icons.lock_outline,
                          color: the
                              ? ColorManager.darkPrimary
                              : ColorManager.primary,
                        ),
                        sIcon: Icon(
                          Icons.remove_red_eye,
                          color: the
                              ? ColorManager.darkPrimary
                              : ColorManager.primary,
                        ),
                        vall: true),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    MyButton(
                      title: 'Sign Up'.tr,
                      color: Colors.white,
                      onTap: () async {
                        _submit();
                      },
                      color1:
                          the ? ColorManager.darkPrimary : ColorManager.primary,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You Have An Account'.tr,
                          style: GoogleFonts.arimo(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: the
                                ? ColorManager.white
                                : ColorManager.darkGrey,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                            },
                            child: Text(
                              'Login Now'.tr,
                              style: GoogleFonts.abel(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 28,
                            backgroundImage:
                                AssetImage('assets/images/facebook.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 28,
                              backgroundImage:
                                  AssetImage('assets/images/twitter.png'),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var _credential = await signUpUsingGoogle().then(
                                (value) => addDataGoogle(
                                    _user!.email,
                                    _user!.displayName,
                                    _user!.photoUrl,
                                    _user!.id,
                                    value.user!.uid));
                            if (_user?.id != null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            }
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 28,
                            backgroundImage: AssetImage('assets/images/g+.png'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField({
    required String hint,
    required String label,
    required Widget pIcon,
    required Widget sIcon,
    required TextInputType type,
    // required Function() onTab,
    required Function() validate,
    required Function() onSave,
    required bool vall,
  }) {
    return TextFormField(
      keyboardType: type,
      validator: validate(),
      onSaved: onSave(),
      // keyboardType: TextInputType.visiblePassword,
      obscureText: vall,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.arimo(
          fontSize: 20,
          color: Colors.grey[700],
        ),
        hintText: hint,
        hintStyle: GoogleFonts.arimo(
          fontSize: 19,
          color: Colors.grey[700],
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.black, width: 1.2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.black, width: 1.2)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: pIcon,
        suffixIcon: IconButton(
          onPressed: () {},
          icon: sIcon,
        ),
      ),
    );
  }

  Future<UserCredential> signUpUsingGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    setState(() {
      _user = googleSignInAccount;
    });
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signUp() async {
    try {
      if (_emailController.isNotEmpty &&
          _passwordController.isNotEmpty &&
          _nameController!.isNotEmpty &&
          _phoneController!.isNotEmpty) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController, password: _passwordController);
        return userCredential;
      } else {}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Attend  !'.tr,
          desc: 'The password is weak'.tr,
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      } else if (e.code == 'email-already-in-use') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Attend  !'.tr,
          desc: 'This Account is Already Exist'.tr,
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UserCredential response = await signUp();
      User? userID = FirebaseAuth.instance.currentUser;
      setState(() {
        user = userID;
      });
      await addDataEmail();
      if (response != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Verifying_Email()));
      }
      return;
    }
  }

  addDataEmail() async {
    addUser = FirebaseFirestore.instance.collection('users');
    addUser?.doc('${user?.uid}').set({
      'Email': _emailController,
      'Username': _nameController,
      'Phone': _phoneController,
      'ID': user?.uid,
      'Image': 'null'
    });
  }

  addDataGoogle(String email, String? displayName, String? photoUrl, String id,
      String? userID) async {
    addUser = FirebaseFirestore.instance.collection('users');
    addUser?.doc('$userID').set({
      'Email': email,
      'Username': displayName,
      'Phone': 'null',
      'uid': id,
      "ID": userID,
      'Image': photoUrl
    });
  }
}
