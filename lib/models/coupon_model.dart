class CouponModel {
  String name, description, type;
  DateTime startDate, endDate;
  int minAmount;
  int offAmount;
  List<dynamic> usedById;
  CouponModel(
      {required this.name,
      required this.description,
      required this.type,
      required this.startDate,
      required this.endDate,
      required this.minAmount,
      required this.offAmount,
      required this.usedById});
  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      name: json['name'],
      description: json['description'],
      type: json['type'],
      startDate: DateTime.parse(json['startDate'].toDate().toString()),
      endDate: DateTime.parse(json['endDate'].toDate().toString()),
      minAmount: json['minAmount'],
      offAmount: json['offAmount'],
      usedById: json['usedById'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'startDate': startDate,
      'endDate': endDate,
      'minAmount': minAmount,
      'offAmount': offAmount,
      'usedById': usedById
    };
  }
}
