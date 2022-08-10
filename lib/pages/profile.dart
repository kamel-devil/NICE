import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project/pages/setting.dart';
import 'package:project/resources/color_manger.dart';

import 'chats_screens.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List _post = [];
  String user = FirebaseAuth.instance.currentUser!.uid;
  var posts = FirebaseFirestore.instance.collection('Post');
  bool comment = false;
  int currentIndex = 0;
  bool isLiked = false;
  int liked = 0;
  bool com = false;
  DocumentReference? addPost;
  String name='';
  String email='';
  String? _controller;
  String? imageProfole;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Widget float = Container();

  getPosts() async {
    CollectionReference pp = FirebaseFirestore.instance.collection('Post');
    await pp
        .where('user', isEqualTo: user)
        .get()
        .then((value) => value.docs.forEach((element) {
              setState(() {
                _post.add(element.data());
              });
            }));
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .get()
        .then((value) {
      setState(() {
        name = value['Username'];
        imageProfole = value['Image'];
        email = value['Email'];
      });
    });
  }

  @override
  void initState() {
    getPosts();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 300,
            decoration: BoxDecoration(
              color: ColorManager.primary,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              size: 35,
                              color: Colors.grey[100],
                            ))),
                    imageProfole != null
                        ? CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(imageProfole!),
                          )
                        : const CircleAvatar(
                            radius: 45,
                            child: Icon(Icons.person),
                          ),
                    CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const SettingPage()));
                            },
                            icon: Icon(
                              Icons.settings,
                              size: 35,
                              color: Colors.grey[100],
                            ))),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  name,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 25,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    Text(
                      'Egypt, Menofia '.tr,
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400])),
                    ),
                  ],
                ),
                Text(
                  email,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400])),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: MaterialButton(
                          onPressed: () async {
                            await getPosts();
                          },
                          child:  Text(
                            'FOLLOW'.tr,
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const ChatsScreen()));
                        },
                        child:  Text(
                          'MESSAGE'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 3, right: 3),
            width: double.maxFinite,
            child: _post.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: _post.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: const Duration(seconds: 5),
                        margin: const EdgeInsets.only(
                            bottom: 10, right: 3, left: 3),
                        padding: const EdgeInsets.only(
                            left: 10, top: 5, right: 10, bottom: 15),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: ColorManager.primary, width: 2)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _post[index]['imageProfile'] != 'null'
                                        ? CircleAvatar(
                                            radius: 28,
                                            backgroundImage: NetworkImage(
                                                _post[index]['imageProfile']),
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
                                        Text(_post[index]['name'],
                                            style: GoogleFonts.nunito(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700,
                                            )),
                                        Text(_post[index]['date'],
                                            style: GoogleFonts.nunito(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  _post[index]['time'],
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
                                      _post[index]['imageurl'] != "null"
                                          ? Image.network(
                                              '${_post[index]['imageurl']}',
                                              width: 270,
                                              height: 250,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                      Center(
                                        child: Text(
                                          _post[index]['Description'],
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
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: ColorManager.primary)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLiked = !isLiked;
                                          currentIndex = index;
                                        });
                                        await addLike(
                                            _post[index]['docID'], isLiked);
                                      },
                                      icon: _post[index]['likes'][user] ??
                                              false
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 32,
                                            )
                                          : const Icon(
                                              Icons.favorite_border_outlined,
                                              size: 32,
                                            )),
                                  Text(
                                    '${_post[index]['likes'].entries.where((e) => e.value == true).toList().length}',
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 100,
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
                                ],
                              ),
                            ),
                            comment == true && currentIndex == index
                                ? AnimatedContainer(
                              duration: const Duration(seconds: 3),
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 9, bottom: 5, right: 5),
                                    padding: const EdgeInsets.only(left: 20),
                                    width: double.maxFinite,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: ColorManager.primary),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Form(
                                            key: _formKey,
                                            child: TextFormField(
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "Must not Empty".tr;
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
                                              decoration:  InputDecoration(
                                                hintText: 'Type something...'.tr,
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0,
                                                )),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
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
                                            color: ColorManager.primary,
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              com = !com;
                                              float = setupAlertDialoadContainer(
                                                  context,
                                                  FirebaseFirestore.instance
                                                      .collection('Post')
                                                      .doc(
                                                          '${_post[index]['docID']}')
                                                      .collection('comments'));
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
                                            _formKey.currentState!.save();
                                            await addComment(
                                                _post[index]['docID'],
                                                _controller!);
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
        ],
      ),
    );
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

  addLike(String id, bool val) async {
    var currentUser = FirebaseAuth.instance.currentUser?.uid;

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

  Widget setupAlertDialoadContainer(context, CollectionReference ss) {
    return StreamBuilder<QuerySnapshot>(
        stream: ss.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return  Center(child: Text('Something went wrong'.tr));
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
                            leading: imageProfole !=null? CircleAvatar(
                              radius: 23,
                              backgroundImage: NetworkImage(imageProfole!),
                            ):
                            const CircleAvatar(
                              radius: 35,
                              child: Icon(Icons.person),),
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
                                const SizedBox(height: 20,),
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
}
