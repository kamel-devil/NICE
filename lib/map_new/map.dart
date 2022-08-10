

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/blocc/bloc.dart';

import '../bloc/bloc_state/bloc_state.dart';

class MapFileRun extends StatelessWidget {
   MapFileRun({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlocPage, BlocState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = BlocPage.get(context);
        return Scaffold(
          body: Stack(
            children: [
              BlocPage.position != null
                  ? cubit.buildMap(context)
                  : const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: cubit.goToMyCurrentPosition,
            child: const Icon(
              Icons.place,
              color: Colors.white,
            ),
          ),
        );
      },
    );



  }
}
