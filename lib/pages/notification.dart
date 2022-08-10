import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../size_config.dart';
import '../widgets/dismissible.dart';

class Notification_Page extends StatefulWidget {
  const Notification_Page({Key? key}) : super(key: key);

  @override
  State<Notification_Page> createState() => _NotificationState();
}

class _NotificationState extends State<Notification_Page> {
  String user = FirebaseAuth.instance.currentUser!.uid;
  String? imageProfole;
  String name = '';
  List noti = [];
  bool edit = false;

  getNotification() async {
    CollectionReference pp = FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('notification');
    await pp.get().then((value) => value.docs.forEach((element) {
          setState(() {
            noti.add(element.data());
          });
        }));
  }

  deleteNotification(String id) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('notification')
        .doc(id)
        .delete();
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
      });
    });
  }

  @override
  void initState() {
    getNotification();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        itemCount: noti.length,
        itemBuilder: (context, index) => noti.isNotEmpty
            ? DismissibleWidget(
              onDismissed: (DismissDirection direction) {
                deleteNotification(noti[index]['id']);
              },
              item: noti,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10, left: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                            radius: 28,
                            child: Icon(Icons.person),
                          ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 4),
                        padding: const EdgeInsets.only(
                            left: 10, right: 0, top: 0, bottom: 8),
                        height: 125,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(noti[index]['title'],
                                    style: GoogleFonts.nunito(
                                      color: Colors.grey.shade900,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w800,
                                    )),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    setState(() {
                                      edit = !edit;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Expanded(
                              child: Text(
                                noti[index]['body'],
                                softWrap: true,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(child: Container()),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8.0,
                                  ),
                                  child: Text(
                                    noti[index]['time'],
                                    softWrap: true,
                                    style: GoogleFonts.quicksand(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            : const Center(
                child: CircularProgressIndicator(
                strokeWidth: 4,
              )),
      );
  }

  // _buildBottomSheet(
  //     {String? label, Function()? onTap, Color? clr, bool isClose = false}) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 4),
  //       height: 65,
  //       width: SizeConfig.screenWidth * 0.9,
  //       decoration: BoxDecoration(
  //         border: Border.all(
  //           width: 2,
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //         color: isClose ? Colors.transparent : clr,
  //       ),
  //       child: Center(
  //         child: Text(
  //           label!,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
