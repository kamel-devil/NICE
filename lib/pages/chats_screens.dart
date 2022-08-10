import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc_state/bloc_state.dart';
import '../bloc/blocc/bloc.dart';
import '../model/model_create.dart';
import 'chat_detail.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>BlocPage()..getUserData()..getAllUsers(),
        child:BlocConsumer<BlocPage, BlocState>(
      listener: (context, state) {},
      builder: (BuildContext context, state) {
        return ConditionalBuilder(
          condition: BlocPage.get(context).allUsers.length > 0,
          builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => buildItemChats(
                  context, BlocPage.get(context).allUsers[index]),
              separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
              itemCount: BlocPage.get(context).allUsers.length),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    ));
  }
}

Widget buildItemChats(context, UserCreateModel model) => InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatsDetails(
                      userCreateModel: model,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            model.image != 'null'
                ? CircleAvatar(
                    radius: 37.0,
                    backgroundImage: NetworkImage('${model.image}'),
                  )
                : const CircleAvatar(
                    radius: 37.0,
                    child: Icon(Icons.person),
                  ),
            const SizedBox(
              width: 10.0,
            ),
            Text('${model.Username}',
                style: Theme.of(context).textTheme.bodyText1?.copyWith()),
          ],
        ),
      ),
    );
