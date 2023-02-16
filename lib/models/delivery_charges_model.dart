class DeliveryChargeModel {
  String name, deliveryCharge;

  DeliveryChargeModel({
    required this.name,
    required this.deliveryCharge,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'deliveryCharge': deliveryCharge,
    };
  }

  factory DeliveryChargeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryChargeModel(
      name: json['name'],
      deliveryCharge: json['deliveryCharge'],
    );
  }
}
