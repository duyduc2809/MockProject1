import 'Account.dart';

class Note {
  final int? id;
  final int? accountId; 
  late final String? name;
  late final String? categoryName;
  late final String? priorityName;
  late final String? statusName;
  late final String? planDate;
  late final String? createdAt;


  Note({this.name, this.categoryName, this.priorityName,this.statusName, this.planDate,  this.accountId, this.id, this.createdAt});

  

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "accountId": accountId,
      "name": name,
      "categoryName": categoryName,
      "priorityName": priorityName,
      "statusName": statusName,
      "planDate": planDate,
      "createdAt": createdAt
    };
  }
}