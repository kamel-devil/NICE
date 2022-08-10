import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MedicineHealth extends StatelessWidget {
  const MedicineHealth({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

    void bottomSheetHappened() {
      scaffoldState.currentState?.showBottomSheet(
          (context) => Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, right: 5, left: 5, bottom: 5),
                child: Container(
                  height: 370,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            // top: 17.0,
                            left: 10,
                            right: 10,
                            bottom: 5),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: 'Event'),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            // top: 17.0,
                            left: 10,
                            right: 10,
                            bottom: 5),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: 'Event'),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'ADD',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          backgroundColor: Colors.white.withOpacity(0.1));
    }

    return Scaffold(
      key: scaffoldState,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/Hospi.jpeg'), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            top: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.apps,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                  image: NetworkImage(
                                      'https://images.unsplash.com/photo-1542595734-38b8d61fc977?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                """   How is your
   health Today?""",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: Container(
                  width: double.infinity,
                  height: 553,
                  decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      )),
                  child: Column(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CalendarDatePicker(
                                firstDate: DateTime.now(),
                                initialDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 100000)),
                                onDateChanged: (val) => bottomSheetHappened(),
                              ))),
                      const SizedBox(
                        height: 5,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 5.0),
                      //   child: Container(
                      //     height: 250,
                      //     width: double.infinity,
                      //     decoration: const BoxDecoration(
                      //         color: Colors.grey,
                      //         borderRadius: BorderRadius.only(
                      //             topRight: Radius.circular(30),
                      //             topLeft: Radius.circular(30))),
                      //     child: Row(
                      //       children: [],
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
