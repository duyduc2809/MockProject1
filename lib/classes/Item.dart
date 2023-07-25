class Item {
  final int? id;
  final String? function;
  final String? name;
  final String? createdAt;
  final int? userId;

  Item({this.id, this.userId, this.function, this.name, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'function': function,
      'name': name,
      'createdAt': createdAt,
    };
  }
}
