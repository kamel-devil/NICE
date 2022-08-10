import 'package:intl/intl.dart';

class PostModel {
  String? name;
  String? description;
  String? postController;
  String? imageUrl;
  bool? imageProfile;
  String? currentUser;
  String? docId;
  String? mtoken;

  PostModel(
      {this.description,
        this.name,
        this.postController,
        this.imageUrl,
        this.imageProfile,
        this.currentUser,
        this.mtoken,
        this.docId});

  PostModel.fromJson(Map<String, dynamic> json) {
    description = json['Email'];
    name = json['Username'];
    postController = json['phone'];
    imageUrl = json['ID'];
    imageProfile = json['isEmailVerified'];
    currentUser = json['Image'];
    docId = json['cover'];
    mtoken = json['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'Description': postController,
      'imageurl': imageUrl,
      'imageProfile': imageProfile,
      'user': currentUser,
      'time': DateFormat('hh:mm a').format(DateTime.now()).toString(),
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      'docID': docId,
      'likes': {},
      'token': mtoken
    };
  }
}
