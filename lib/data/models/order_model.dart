class OrderModel {
  final String id;
  final String userId;
  final String orderNumber;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderDate;
  final List<OrderItem> items;
  final String? deliveryAddress;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.items,
    this.deliveryAddress,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      orderNumber: map['orderNumber'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${map['status']}',
        orElse: () => OrderStatus.pending,
      ),
      orderDate: DateTime.parse(map['orderDate'] ?? DateTime.now().toIso8601String()),
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ??
          [],
      deliveryAddress: map['deliveryAddress'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'orderNumber': orderNumber,
      'totalAmount': totalAmount,
      'status': status.name,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
      'deliveryAddress': deliveryAddress,
    };
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, userId: $userId, orderNumber: $orderNumber, totalAmount: $totalAmount, status: $status, orderDate: $orderDate, items: $items, deliveryAddress: $deliveryAddress)';
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'OrderItem(productId: $productId, productName: $productName, price: $price, quantity: $quantity, imageUrl: $imageUrl)';
  }
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}
