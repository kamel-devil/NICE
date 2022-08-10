class UserCreateModel {
  String? Email;
  String? Username;
  String? phone;
  String? ID;
  bool? isEmailVerified;
  String? image;
  String? cover;
  String? bio;

  UserCreateModel(
      {this.Email,
        this.Username,
        this.phone,
        this.ID,
        this.isEmailVerified,
        this.image,
        this.bio,
        this.cover});

  UserCreateModel.fromJson(Map<String, dynamic> json) {
    Email = json['Email'];
    Username = json['Username'];
    phone = json['phone'];
    ID = json['ID'];
    isEmailVerified = json['isEmailVerified'];
    image = json['Image'];
    cover = json['cover'];
    bio = json['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'Username': Username,
      'Email': Email,
      'phone': phone,
      'isEmailVerified': isEmailVerified,
      'Image': image,
      'cover': cover,
      'bio': bio,
      'ID': ID,
    };
  }
}