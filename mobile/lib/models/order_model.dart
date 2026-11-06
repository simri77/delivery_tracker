class OrderModel {
  final int id;
  final String orderIdString;
  final String status;
  final String estimatedTime;
  final String driverName;
  final String deliveryAddress;
  final double totalPrice;

  OrderModel({
    required this.id,
    required this.orderIdString,
    required this.status,
    required this.estimatedTime,
    required this.driverName,
    required this.deliveryAddress,
    required this.totalPrice,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderIdString: json['orderIdString'],
      status: json['status'],
      estimatedTime: json['estimatedTime'],
      driverName: json['driverName'],
      deliveryAddress: json['deliveryAddress'],
      totalPrice: double.parse(json['totalPrice'].toString()),
    );
  }
}