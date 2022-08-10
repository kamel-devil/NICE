class ChatDetailsModel {
  String? sendId;
  String? receiveId;
  String? text;
  String? dateTime;
  String? image;

  ChatDetailsModel({
    this.sendId,
    this.receiveId,
    this.text,
    this.dateTime,
    this.image,
  });

  ChatDetailsModel.fromJson(Map<String, dynamic> json) {
    sendId = json['sendId'];
    receiveId = json['receiveId'];

    text = json['text'];
    dateTime = json['dateTime'];
    image = json['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'receiveId': receiveId,
      'sendId': sendId,
      'text': text,
      'dateTime': dateTime,
      'image': image,
    };
  }
}
