import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'apply.dart';
import 'chat.dart';

class HospitalDetails extends StatefulWidget {
  HospitalDetails(
      {Key? key, required this.data, required this.id, required this.url,required this.address})
      : super(key: key);
  List data = [];
  String id;
  String url;
  String address;

  @override
  _HospitalDetailsState createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = widget.data;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      post["name"],
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post["brand"],
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Image.asset(
                  "${post["image"]}",
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                )
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => apply(
                          id: widget.id,
                        )));
              },
              icon: const Icon(Icons.post_add_outlined),
              label: const Text(
                'Apply',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(10),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(width: 2, color: Colors.teal),
                )),
              ),
            )
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          height: size.height,
          child: Column(
            children: <Widget>[
              const Text(
                "Hospital Center",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: AssetImage(widget.url), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer ? 0 : 1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer ? 0 : categoryHeight,
                    child: CategoriesScroller(widget.id,address: widget.address,)),
              ),
              Expanded(
                child: ListView.builder(
                    controller: controller,
                    itemCount: itemsData.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      double scale = 1.0;
                      if (topContainer > 0.5) {
                        scale = index + 0.5 - topContainer;
                        if (scale < 0) {
                          scale = 0;
                        } else if (scale > 1) {
                          scale = 1;
                        }
                      }
                      return Opacity(
                        opacity: scale,
                        child: Transform(
                          transform: Matrix4.identity()..scale(scale, scale),
                          alignment: Alignment.bottomCenter,
                          child: Align(
                              heightFactor: 0.7,
                              alignment: Alignment.topCenter,
                              child: itemsData[index]),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: const Icon(Icons.chat_bubble),
          onPressed: () {
            String? user=FirebaseAuth.instance.currentUser?.uid;
            FirebaseFirestore.instance.collection('hospital').doc(widget.id).collection('client').doc(user).set({});
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chat(id: widget.id)));
          },

        ),
      ),
    );
  }
}

class CategoriesScroller extends StatefulWidget {
  CategoriesScroller(this.id, {Key? key,required this.address}) : super(key: key);
  String id;
  String address ;

  @override
  State<CategoriesScroller> createState() => _CategoriesScrollerState();
}

class _CategoriesScrollerState extends State<CategoriesScroller> {
  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;

  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Container(
                width: 270,
                margin: const EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.teal.shade300,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      star1 = !star1;
                                    });
                                  },
                                  icon:
                                      star1 || star2 || star3 || star4 || star5
                                          ? const Icon(
                                              Icons.star,
                                              size: 27,
                                              color: Colors.yellow,
                                            )
                                          : const Icon(
                                              Icons.star_border_outlined,
                                              size: 27,
                                              color: Colors.yellow,
                                            )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      star2 = !star2;
                                    });
                                  },
                                  icon: star2 || star3 || star4 || star5
                                      ? const Icon(
                                          Icons.star,
                                          size: 27,
                                          color: Colors.yellow,
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          size: 27,
                                          color: Colors.yellow,
                                        )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      star3 = !star3;
                                    });
                                  },
                                  icon: star3 || star4 || star5
                                      ? const Icon(
                                          Icons.star,
                                          size: 27,
                                          color: Colors.yellow,
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          size: 27,
                                          color: Colors.yellow,
                                        )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      star4 = !star4;
                                    });
                                  },
                                  icon: star4 || star5
                                      ? const Icon(
                                          Icons.star,
                                          size: 27,
                                          color: Colors.yellow,
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          size: 27,
                                          color: Colors.yellow,
                                        )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      star5 = !star5;
                                    });
                                  },
                                  icon: star5
                                      ? const Icon(
                                          Icons.star,
                                          size: 27,
                                          color: Colors.yellow,
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          size: 27,
                                          color: Colors.yellow,
                                        )),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (star1) {
                                FirebaseFirestore.instance
                                    .collection('hospital')
                                    .doc(widget.id)
                                    .collection('comments')
                                    .add({'star': 1});
                              } else if (star2) {
                                FirebaseFirestore.instance
                                    .collection('hospital')
                                    .doc(widget.id)
                                    .collection('comments')
                                    .add({'star': 2});
                              } else if (star3) {
                                FirebaseFirestore.instance
                                    .collection('hospital')
                                    .doc(widget.id)
                                    .collection('comments')
                                    .add({'star': 3});
                              } else if (star4) {
                                FirebaseFirestore.instance
                                    .collection('hospital')
                                    .doc(widget.id)
                                    .collection('comments')
                                    .add({'star': 4});
                              } else if (star5) {
                                FirebaseFirestore.instance
                                    .collection('hospital')
                                    .doc(widget.id)
                                    .collection('comments')
                                    .add({'star': 5});
                              }
                            },
                            icon: const Icon(Icons.post_add_outlined),
                            label: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w700),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              elevation: MaterialStateProperty.all(10),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    width: 2, color: Colors.white),
                              )),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                            },
                            icon: const Icon(Icons.add_comment_outlined),
                            label: const Text(
                              'Comment',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w700),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              elevation: MaterialStateProperty.all(10),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    width: 2, color: Colors.teal),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: const EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.orange.shade400,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Phone",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "01111419194",
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Home",
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "0225173511",
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: const EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "عماره شمس \n ش اللاسلكي- المعادي الجديده - القاهره",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: const EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.shade400,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  <Widget>[
                      Text(
                       widget.address,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
