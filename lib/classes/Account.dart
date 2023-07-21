class Account {
  final int? id;
  final String? password;
  final String? email;
  final String? createAt;
  final String? firstName;
  final String? lastName;

  Account({this.firstName, this.lastName, this.id, this.password, this.email, this.createAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'password': password,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
