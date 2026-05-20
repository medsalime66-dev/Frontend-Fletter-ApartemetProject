class Payment{
  final int id;
  final String walletName;
  final String phone;
  final String transactionCode;
  final double amount;
  final String status;

  const Payment({
    required this.id,
    required this.walletName,
    required this.phone,
    required this.transactionCode,
    required this.amount,
    required this.status,
  });

  ///json to object
  factory Payment.fromJson(Map<String,dynamic> json){
    return Payment(
      id:_parseInt(json['id']),
      walletName:json['walletName']??'',
      phone:json['phone']??'',
      transactionCode:json['transactionCode']??'',
      amount:_parseDouble(json['amount']),
      status:json['status']??'',
    );
  }

  ///parse int
  static int _parseInt(dynamic value){
    if(value is int){
      return value;
    }

    return int.tryParse(value.toString())??0;
  }

  ///parse double
  static double _parseDouble(dynamic value){
    if(value is double){
      return value;
    }

    if(value is int){
      return value.toDouble();
    }

    return double.tryParse(value.toString())??0;
  }

  ///object to json
  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'walletName':walletName,
      'phone':phone,
      'transactionCode':transactionCode,
      'amount':amount,
      'status':status,
    };
  }
}

class Wallet{
  final String name;
  final String code;
  final String description;

  const Wallet({
    required this.name,
    required this.code,
    required this.description,
  });

  ///json to object
  factory Wallet.fromJson(Map<String,dynamic> json){
    return Wallet(
      name:json['name']??'',
      code:json['code']??'',
      description:json['description']??'',
    );
  }

  ///object to json
  Map<String,dynamic> toJson(){
    return{
      'name':name,
      'code':code,
      'description':description,
    };
  }
}