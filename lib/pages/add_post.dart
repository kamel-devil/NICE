import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path/path.dart';
import 'package:project/pages/homepage.dart';

import '../widgets/icons_broken.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? imageFile;
  TextEditingController textControl = TextEditingController();
  String user = FirebaseAuth.instance.currentUser!.uid;
  String name = '';
  String? image;
  DocumentReference? addPost;
  var data = FirebaseFirestore.instance.collection('Post');
  String? mtoken;
  var imageUrl;

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .get()
        .then((value) {
      setState(() {
        name = value['Username'];
        image = value['Image'];
      });
    });
  }

  addData() async {
    String docId = FirebaseFirestore.instance
        .collection('Post')
        .doc()
        .id;
    addPost = FirebaseFirestore.instance.collection('Post').doc('$docId');
    var currentUser = FirebaseAuth.instance.currentUser?.uid;

    if (imageFile != null) {
      var imageName = basename(imageFile!.path);
      var ref = FirebaseStorage.instance.ref('images/$imageName');
      await ref.putFile(imageFile!);
      imageUrl = await ref.getDownloadURL();
      addPost?.set({
        'name': name,
        'Description': textControl.text,
        'imageurl': imageUrl,
        'imageProfile': image,
        'user': currentUser,
        'time': DateFormat('hh:mm a').format(DateTime.now()).toString(),
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'docID': docId,
        'likes': {},
        'token': mtoken
      });
    } else {
      addPost?.set({
        'name': name,
        'Description': textControl.text,
        'imageurl': 'null',
        'imageProfile': image,
        'user': currentUser,
        'time': DateFormat('hh:mm a').format(DateTime.now()).toString(),
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'docID': docId,
        'likes': {},
        'token': mtoken
      });
    }
  }

  @override
  void initState() {
    getData();
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.teal.shade300,
          title:  Text('Create Post'.tr),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(IconBroken.Arrow___Left_2)),
          actions: [
            ElevatedButton.icon(onPressed: ()async{
               addData();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomePage()));
              showSimpleNotification(
                 Text(
                    "Post Added Successfully".tr),
                leading: const Icon(Icons.done),
              );
            },
              icon: const Icon(Icons.post_add_outlined),
              label:  Text('Post'.tr, style:const TextStyle(fontSize: 19,fontWeight: FontWeight.w700),),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.teal.shade500),
                elevation: MaterialStateProperty.all(10),
                shape:MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                )),
              ),
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                image != null ?
                CircleAvatar(
                  backgroundImage: NetworkImage(image!),
                  radius: 35,
                ) :
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.person,
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontSize: 16),
                      ),

                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: TextFormField(
                controller: textControl,
                style: const TextStyle(color: Colors.black),
                decoration:  InputDecoration(
                  border: InputBorder.none,
                  hintText: 'What is on your mind.....'.tr,
                ),
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                imageFile != null ?
                Container(
                  height: 170,
                  width: double.infinity,
                  child: Center(
                    child: Image.file(
                      imageFile!,
                      width: 270,
                      height: 250,
                      fit: BoxFit.fill,
                    ),
                  ),
                ) :
                Container(),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          imageFile = null;
                        });
                      },
                      icon: const Icon(
                        IconBroken.Delete,
                        color: Colors.red,
                      )),
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () =>
                        showDialog(
                            context: context,
                            builder:
                                (BuildContext context) {
                              return AlertDialog(
                                content:
                                SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      const Divider(
                                        height: 1,
                                        color:
                                        Colors.blue,
                                      ),
                                      ListTile(
                                        onTap: () {
                                          _openGallery(
                                              context);
                                        },
                                        title:  Text(
                                            "Gallery".tr),
                                        leading:
                                        const Icon(
                                          Icons.camera,
                                          color:
                                          Colors.blue,
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                        color:
                                        Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Colors.green,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () =>
                        showDialog(
                            context: context,
                            builder:
                                (BuildContext context) {
                              return AlertDialog(
                                content:
                                SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      const Divider(
                                        height: 1,
                                        color:
                                        Colors.blue,
                                      ),
                                      ListTile(
                                        onTap: () {
                                          // BlocPage.get(
                                          //         context)
                                          //     .getImageSend();
                                          _openCamera(
                                              context);
                                        },
                                        title:  Text(
                                            "Camera".tr),
                                        leading:
                                        const Icon(
                                          Icons.camera,
                                          color:
                                          Colors.blue,
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                        color:
                                        Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.green,
                      size: 30,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      final imageTemp = File(pickedFile.path);
      setState(() {
        imageFile = imageTemp;
      });
    } else {
    }

    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final imageTemp = File(pickedFile.path);
      setState(() {
        imageFile = imageTemp;
      });
    } else {

    }

    Navigator.pop(context);
  }
}
