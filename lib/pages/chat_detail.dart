import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../bloc/bloc_state/bloc_state.dart';
import '../bloc/blocc/bloc.dart';
import '../model/model_create.dart';
import '../model/modelchats.dart';
import '../widgets/icons_broken.dart';

class ChatsDetails extends StatelessWidget {
  UserCreateModel? userCreateModel;

  ChatsDetails({Key? key, this.userCreateModel}) : super(key: key);

  var textControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        BlocPage.get(context).getMessages(receiveID: userCreateModel!.ID);
        return BlocConsumer<BlocPage, BlocState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    userCreateModel!.image != 'null'
                        ? CircleAvatar(
                            radius: 23.0,
                            backgroundImage:
                                NetworkImage('${userCreateModel!.image}'),
                          )
                        : const CircleAvatar(
                            radius: 37.0,
                            child: Icon(Icons.person),
                          ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '${userCreateModel!.Username}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: BlocPage.get(context).messages.length >= 0,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var message =
                                  BlocPage.get(context).messages[index];
                              if (BlocPage.get(context).model!.ID ==
                                  message.sendId) {
                                return sendMine(message, context);
                              } else {
                                return sendToHim(message, context);
                              }
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 6,
                                ),
                            itemCount: BlocPage.get(context).messages.length),
                      ),
                      if (BlocPage.get(context).imageSend != null &&
                          userCreateModel!.ID ==
                              BlocPage.get(context).model!.ID)
                        Column(
                          children: [
                            const SizedBox(
                              height: 6,
                            ),
                            Container(
                              height: 140,
                              width: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: FileImage(
                                      BlocPage.get(context).imageSend!,
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      if (BlocPage.get(context).imageSend != null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: FileImage(
                                        BlocPage.get(context).imageSend!),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  onPressed: () {
                                    BlocPage.get(context).removeImageSender();
                                  },
                                  icon: const Icon(
                                    IconBroken.Delete,
                                    color: Colors.deepOrange,
                                  )),
                            )
                          ],
                        ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    controller: textControl,
                                    onChanged: (value) {
                                      if (state
                                          is SuccessSendAllChatsDetailsStateHome) {
                                        textControl.text = '';
                                      }
                                    },
                                    decoration:  InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type your message here.....'.tr,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.7),
                              radius: 27,
                              child: TextButton(
                                onPressed: () {
                                  BlocPage.get(context).getImageSend();
                                },
                                child: const Icon(
                                  IconBroken.Image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.7),
                              radius: 27,
                              child: TextButton(
                                onPressed: () {
                                  if (BlocPage.get(context).imageSend == null) {
                                    BlocPage.get(context).sendChatDetails(
                                        text: textControl.text,
                                        dateTime: DateTime.now().toString(),
                                        receiveID: userCreateModel!.ID,
                                        image: '');
                                  } else {
                                    BlocPage.get(context).uploadingImageSend(
                                        text: textControl.text,
                                        dateTime: DateTime.now().toString(),
                                        receiveID: userCreateModel!.ID);
                                  }
                                },
                                child: const Icon(
                                  IconBroken.Send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget sendToHim(ChatDetailsModel model, context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(15),
                    topEnd: Radius.circular(15),
                    topStart: Radius.circular(15),
                  )),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                '${model.text}',
              ),
            ),
          ),
          if (model.image != '')
            const SizedBox(
              height: 6,
            ),
          if (model.image != '')
            Container(
              height: 150,
              width: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage('${model.image}'),
                    fit: BoxFit.cover,
                  )),
            ),
          if (model.image != '')
            const SizedBox(
              height: 14,
            ),
          const SizedBox(
            height: 4,
          )
        ],
      );

  Widget sendMine(ChatDetailsModel? model, context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(15),
                    topEnd: Radius.circular(15),
                    topStart: Radius.circular(15),
                  )),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                '${model!.text}',
              ),
            ),
          ),
          if (model.image != '')
            const SizedBox(
              height: 6,
            ),
          if (model.image != '')
            Container(
              height: 150,
              width: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage('${model.image}'),
                    fit: BoxFit.cover,
                  )),
            ),
          if (model.image != '')
            const SizedBox(
              height: 6,
            ),
          const SizedBox(
            height: 4,
          )
        ],
      );
}
