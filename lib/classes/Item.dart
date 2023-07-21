class Item{
  final int? id;
  final String? function;
  final String? name;
  final String? createdAt;

  Item({this.id, this.function, this.name , this.createdAt});

  Map<String, dynamic> toMap(){
    return{
      'id' :id,
      'function' :function,
      'name' :name,
      'createdAt' :createdAt,
    };
  }

}