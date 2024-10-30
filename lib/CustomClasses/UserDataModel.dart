class UserDataModel {
  late String name, gender, date_of_birth, about, email, profilePic, userId;
  late int phoneNumber;

  UserDataModel(
      {required this.name,
      required this.gender,
      required this.date_of_birth,
      required this.about,
      required this.email,
      required this.profilePic,
      required this.phoneNumber,
      required this.userId});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["name"] = name;
    map["gender"] = gender;
    map["date_of_birth"] = date_of_birth;
    map["about"] = about;
    map["email"] = email;
    map["profilePic"] = profilePic;
    map["phoneNumber"] = phoneNumber;
    map["userId"] = userId;
    return map;
  }

  static UserDataModel toUserDataModel(Map map) {
    return UserDataModel(
        name: map["name"],
        gender: map["gender"],
        date_of_birth: map["date_of_birth"],
        about: map["about"],
        email: map["email"],
        profilePic: map["profilePic"],
        phoneNumber: map["phoneNumber"],
        userId: map["userId"]);
  }
}
