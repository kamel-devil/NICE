import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../bloc/blocc/bloc.dart';
import '../main.dart';
import '../resources/color_manger.dart';

class GetPost extends StatefulWidget {
  const GetPost({Key? key}) : super(key: key);

  @override
  State<GetPost> createState() => _GetPostState();
}

class _GetPostState extends State<GetPost> {
  CollectionReference posts = FirebaseFirestore.instance.collection('Post');
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool pst = false;
  TextEditingController postController = TextEditingController();
  File? imageFile;
  var imageUrl;
  int commentLenght = 0;
  DocumentReference? addPost;
  String? name;
  String? imageProfole;

  bool comment = false;
  int currentIndex = 0;
  bool isLiked = false;
  int liked = 0;
  String? _controller;
  bool com = false;
  Widget float = Container();

  var data = FirebaseFirestore.instance.collection('Post');
  User? user = FirebaseAuth.instance.currentUser;
  String? mtoken;

  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('${user?.uid}')
        .get()
        .then((value) {
      setState(() {
        name = value['Username'];
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlocPage()
        ..getToken()
        ..getData(),
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: posts.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'.tr));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 4,
                ));
              }
              if (snapshot.connectionState != ConnectionState.active) {
                return Center(child: Text('Connection Error'.tr));
              }
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 3, right: 3),
                    width: double.maxFinite,
                    child: snapshot.hasData
                        ? ScrollablePositionedList.builder(
                            initialScrollIndex: currentIndex,
                            itemCount: snapshot.data!.size,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    bottom: 10, right: 3, left: 3),
                                padding: const EdgeInsets.only(
                                    left: 10, top: 5, right: 10, bottom: 15),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color:the?ColorManager.darkPrimary: ColorManager.primary, width: 2)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            snapshot.data?.docs[index]
                                                        ['imageProfile'] !=
                                                    'null'
                                                ? CircleAvatar(
                                                    radius: 28,
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                                .data
                                                                ?.docs[index]
                                                            ['imageProfile']),
                                                  )
                                                : const CircleAvatar(
                                                    radius: 28,
                                                    child: Icon(Icons.person),
                                                  ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    snapshot.data?.docs[index]
                                                        ['name'],
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                                Text(
                                                    snapshot.data?.docs[index]
                                                        ['date'],
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          snapshot.data?.docs[index]['time'],
                                          style: GoogleFonts.nunito(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800]),
                                        )
                                      ],
                                    ),
                                    Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 15, right: 5),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              snapshot.data?.docs[index]
                                                          ['imageurl'] !=
                                                      "null"
                                                  ? Image.network(
                                                      '${snapshot.data?.docs[index]['imageurl']}',
                                                      width: 270,
                                                      height: 250,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Container(),
                                              Center(
                                                child: Text(
                                                  snapshot.data?.docs[index]
                                                      ['Description'],
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[700],
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Container(
                                      height: 55,
                                      width: double.maxFinite,
                                      margin: const EdgeInsets.only(top: 25),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color:the?ColorManager.darkPrimary: ColorManager.primary)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  isLiked = !isLiked;
                                                  currentIndex = index;
                                                });
                                                await addLike(
                                                    snapshot.data?.docs[index]
                                                        ['docID'],
                                                    isLiked);
                                                sendPushMessage(
                                                    snapshot.data?.docs[index]
                                                        ['token'],
                                                    'ADD LIKE ON YOUR POST',
                                                    name!);
                                              },
                                              icon: snapshot.data?.docs[index]
                                                              ['likes']
                                                          [user!.uid] ??
                                                      false
                                                  ? const Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                      size: 32,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .favorite_border_outlined,
                                                      size: 32,
                                                    )),
                                          Text(
                                            '${snapshot.data?.docs[index]['likes'].entries.where((e) => e.value == true).toList().length}',
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 60,
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.comment,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                currentIndex = index;
                                                comment = !comment;
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            width: 60,
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.save_outlined,
                                              size: 30,
                                            ),
                                            onPressed: () async {
                                              await savePost(
                                                  snapshot.data?.docs[index]
                                                      ['docID'],
                                                  user!.uid);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    comment == true && currentIndex == index
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                left: 20,
                                                top: 9,
                                                bottom: 5,
                                                right: 5),
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            width: double.maxFinite,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: the?ColorManager.darkPrimary: ColorManager.primary),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Form(
                                                    key: _formKey,
                                                    child: TextFormField(
                                                      validator: (val) {
                                                        if (val!.isEmpty) {
                                                          return "Must not Empty"
                                                              .tr;
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (val) {
                                                        setState(() {
                                                          _controller = val;
                                                        });
                                                      },
                                                      showCursor: true,
                                                      autofocus: false,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Type something...'
                                                                .tr,
                                                        enabledBorder:
                                                            const UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                          color: Colors.white,
                                                          width: 0,
                                                        )),
                                                        focusedBorder:
                                                            const UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                          color: Colors.white,
                                                          width: 0,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.comment_bank,
                                                    size: 28,
                                                    color: the?ColorManager.darkPrimary: ColorManager.primary,
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      com = !com;
                                                      float = setupAlertDialoadContainer(
                                                          context,
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Post')
                                                              .doc(
                                                                  '${snapshot.data?.docs[index]['docID']}')
                                                              .collection(
                                                                  'comments'));
                                                    });
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.send,
                                                    size: 28,
                                                    color: Colors.blue,
                                                  ),
                                                  onPressed: () async {
                                                    _formKey.currentState!
                                                        .save();
                                                    await addComment(
                                                        snapshot.data
                                                                ?.docs[index]
                                                            ['docID'],
                                                        _controller!);
                                                    sendPushMessage(
                                                        snapshot.data
                                                                ?.docs[index]
                                                            ['token'],
                                                        'ADD NEW COMMENT ON YOUR POST',
                                                        name!);
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                            strokeWidth: 4,
                          )),
                  ),
                  com ? float : Container(),
                ],
              );
            }),
      ),
    );
  }

  Widget setupAlertDialoadContainer(context, CollectionReference ss) {
    return StreamBuilder<QuerySnapshot>(
        stream: ss.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 4,
            ));
          }
          if (snapshot.hasData) {
            return Center(
              child: Stack(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1.3)),
                      child: ListView.separated(
                        separatorBuilder: (context, i) => const Divider(
                          color: Colors.white,
                          thickness: 1.2,
                          indent: 18,
                          endIndent: 18,
                        ),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${snapshot.data?.docs[index]['name']}',
                                  style: GoogleFonts.roboto(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  '${snapshot.data?.docs[index]['time']}',
                                  style: GoogleFonts.b612(
                                    fontSize: 18,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ],
                            ),
                            leading: imageProfole != null
                                ? CircleAvatar(
                                    radius: 23,
                                    backgroundImage:
                                        NetworkImage(imageProfole!),
                                  )
                                : const CircleAvatar(
                                    radius: 35,
                                    child: Icon(Icons.person),
                                  ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data?.docs[index]['date']}',
                                  style: GoogleFonts.b612(
                                    fontSize: 18,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                Text(
                                  '${snapshot.data?.docs[index]['description']}',
                                  style: GoogleFonts.artifika(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 10,
                    bottom: 0,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            com = false;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          textStyle: MaterialStateProperty.all(
                              GoogleFonts.acme(fontSize: 22)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 3)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: const BorderSide(
                                    color: Colors.white, width: 1.5)),
                          ),
                          elevation: MaterialStateProperty.all(3),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: GoogleFonts.archivo(),
                        )),
                  )
                ],
              ),
            );
          } else {
            return Container(
              color: Colors.red,
              width: 200,
              height: 200,
            );
          }
        });
  }

  savePost(String id, String? userID) async {
    CollectionReference addUser =
        FirebaseFirestore.instance.collection('users');
    addUser.doc('$userID').set({
      "Posts": FieldValue.arrayUnion([id])
    }, SetOptions(merge: true));
  }

  addComment(String id, String comment) async {
    var currentUser = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection('Post')
        .doc(id)
        .get()
        .then((value) {
      addPost = FirebaseFirestore.instance.collection('Post').doc(id);
      addPost!.collection('comments').add(
        {
          'name': name,
          'ID': currentUser,
          'description': _controller,
          'time': DateFormat('hh:mm a').format(DateTime.now()).toString(),
          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        },
      );
    });
  }

  TextFormField buildTextFormField({
    required String hint,
    required TextEditingController? controller,
    required Function() onTab,
    required Function() validate,
    required Function() onSave,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.roboto(
        fontSize: 22,
        color: Colors.black,
      ),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 1,
      maxLines: 8,
      maxLength: 500,
      validator: validate(),
      onSaved: onSave(),
      decoration: InputDecoration(
        labelStyle: GoogleFonts.arimo(
          fontSize: 60,
          color: Colors.grey[700],
        ),
        hintText: hint,
        hintStyle: GoogleFonts.arimo(
          fontSize: 20,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAPAuTwLI:APA91bEnxHn4chTwIebhcd9t5BIJdchK_eTyzhshJgI3y5NML2muYFJWAAUVxnaTBrmR0Z2ZKtoyyQyW7En504LGZ7YJvzG_L4bU7L-3QfsvWW-Vd0YFZ8JJ7B7Arm0QGrYrjhqRYc3y',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  addLike(String id, bool val) async {
    String? currentUser = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('Post')
        .doc(id)
        .get()
        .then((value) {
      addPost = FirebaseFirestore.instance.collection('Post').doc(id);
      addPost!.set(
        {
          'likes': {'$currentUser': val}
        },
        SetOptions(merge: true),
      );
    });
  }
}
