class MyUser {
  String id;
  String firstName;
  String lastName;
  String birthday;
  String? phoneNumber;
  String? photoURL;
  String email;
  String password;
  Set<String>? listFavoriteProductID;

  MyUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    this.phoneNumber,
    this.photoURL,
    required this.email,
    required this.password,
    this.listFavoriteProductID,
  });

  @override
  String toString() {
    return 'MyUser{id: $id, firstName: $firstName, lastName: $lastName, email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
