class AppNotification{
  final int id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  ///json to object
  factory AppNotification.fromJson(Map<String,dynamic> json){
    return AppNotification(
      id:_parseInt(json['id']),
      title:json['title']??'',
      message:json['message']??'',
      createdAt:_parseDate(json['createdAt']),
      isRead:json['isRead']??false,
    );
  }

  ///parse int
  static int _parseInt(dynamic value){
    if(value is int){
      return value;
    }

    return int.tryParse(value.toString())??0;
  }

  ///parse date
  static DateTime _parseDate(dynamic value){
    try{
      return DateTime.parse(value.toString());
    }catch(_){
      return DateTime.now();
    }
  }

  ///object to json
  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'title':title,
      'message':message,
      'createdAt':createdAt.toIso8601String(),
      'isRead':isRead,
    };
  }
}