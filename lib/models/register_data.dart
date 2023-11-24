enum Gender {
  male, female, diverse
}

extension ParseToString on Gender {
  String getName() {
    return toString().split(".").last;
  }
}

class RegisterData {
  String? email;
  String? password;
  String? username;
  Gender? gender;

  RegisterData();

  Map<String, dynamic> toMap() => {
    "email": email,
    "password": password,
    "username": username,
    "gender": gender!.getName                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ()
  };
}