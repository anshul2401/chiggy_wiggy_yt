import 'package:chiggy_wiggy/models/cart_model.dart';
import 'package:chiggy_wiggy/models/user_model.dart';

class OrderModel {
  String name, status, phoneNumber, userId, totalAmount, date;
  AddressModel address;
  List<CartModel> items;
  DateTime dateTime;
  OrderModel(
      {required this.name,
      required this.status,
      required this.address,
      required this.items,
      required this.dateTime,
      required this.phoneNumber,
      required this.userId,
      required this.totalAmount,
      required this.date});
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      userId: json['userId'],
      address: AddressModel.fromJson(json['address']),
      dateTime: DateTime.parse(json['dateTime'].toDate().toString()),
      items: json['items'] != []
          ? List<CartModel>.from(
              json['items'].map((x) => CartModel.fromJson(x)))
          : [],
      name: json['name'],
      status: json['status'],
      date: json['date'],
      phoneNumber: json['phoneNumber'],
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'address': address.toJson(),
      'dateTime': dateTime,
      'date': date,
      'items': List<dynamic>.from(items.map((e) => e.toJson())),
      'name': name,
      'status': status,
      'phoneNumber': phoneNumber,
      'totalAmount': totalAmount
    };
  }
}
