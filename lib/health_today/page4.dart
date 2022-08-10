import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc_state/bloc_state.dart';
import '../bloc/blocc/bloc.dart';
class Nave extends StatefulWidget {
  const Nave({Key? key}) : super(key: key);

  @override
  State<Nave> createState() => _NaveState();
}

class _NaveState extends State<Nave> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BlocPage(),
        child: BlocConsumer<BlocPage, BlocState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: BlocPage.get(context)
                  .screens[BlocPage.get(context).currentIndex],
              bottomNavigationBar: BottomNavyBar(
                backgroundColor: Colors.black,
                showElevation: false,
                selectedIndex: BlocPage.get(context).currentIndex,
                onItemSelected: (index) =>
                    BlocPage.get(context).changeScreen(index),
                items: [
                  BottomNavyBarItem(
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: const Text(
                        "Home",
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.cyan,
                      inactiveColor: Colors.grey),
                  BottomNavyBarItem(
                      icon: const Icon(
                        Icons.search_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.cyan,
                      inactiveColor: Colors.grey),
                  BottomNavyBarItem(
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                      title: const Text(
                        "Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.cyan,
                      inactiveColor: Colors.grey),
                  BottomNavyBarItem(
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      title: const Text(
                        "Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.cyan,
                      inactiveColor: Colors.grey),
                ],
              ),
            );
          },
        ));;
  }
}
