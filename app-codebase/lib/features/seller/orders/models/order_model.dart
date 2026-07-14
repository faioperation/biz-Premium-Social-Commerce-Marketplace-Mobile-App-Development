// ══════════════════════════════════════════════════════════
// Seller Order Models
// API integration: fromJson/toJson methods ready
// ══════════════════════════════════════════════════════════

enum OrderStatus { newOrder, processing, shipped, completed }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.newOrder:
        return 'New';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.completed:
        return 'Completed';
    }
  }

  // Next logical status for the action button
  OrderStatus? get nextStatus {
    switch (this) {
      case OrderStatus.newOrder:
        return OrderStatus.processing;
      case OrderStatus.processing:
        return OrderStatus.shipped;
      case OrderStatus.shipped:
        return OrderStatus.completed;
      case OrderStatus.completed:
        return null; // no further action
    }
  }

  String get actionLabel {
    switch (this) {
      case OrderStatus.newOrder:
        return 'Accept & Process';
      case OrderStatus.processing:
        return 'Mark as Shipped';
      case OrderStatus.shipped:
        return 'Mark as Completed';
      case OrderStatus.completed:
        return 'Order Completed';
    }
  }
}

enum PaymentStatus { paid, pending, failed, refunded }

extension PaymentStatusLabel on PaymentStatus {
  String get label {
    switch (this) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }
}

class DeliveryAddressModel {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String country;

  const DeliveryAddressModel({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.country,
  });

  String get fullAddress {
    final parts = [addressLine1, if (addressLine2.isNotEmpty) addressLine2, city, country];
    return parts.join(', ');
  }

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'phone': phone,
        'address_line1': addressLine1,
        'address_line2': addressLine2,
        'city': city,
        'country': country,
      };
}

class OrderItemModel {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get subtotal => price * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'quantity': quantity,
        'image_url': imageUrl,
      };
}

class SellerOrderModel {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerLocation;
  final String customerAvatar;
  final List<OrderItemModel> items;
  final double totalAmount;
  final double deliveryCharge;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String paymentMethod;
  final DeliveryAddressModel deliveryAddress;
  final DateTime createdAt;
  final String? note;

  const SellerOrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerLocation,
    required this.customerAvatar,
    required this.items,
    required this.totalAmount,
    this.deliveryCharge = 0,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.createdAt,
    this.note,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);
  double get grandTotal => subtotal + deliveryCharge;

  factory SellerOrderModel.fromJson(Map<String, dynamic> json) {
    return SellerOrderModel(
      id: json['id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerLocation: json['customer_location'] ?? '',
      customerAvatar: json['customer_avatar'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      deliveryCharge: (json['delivery_charge'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.newOrder,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (s) => s.name == json['payment_status'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: json['payment_method'] ?? 'Cash on Delivery',
      deliveryAddress: DeliveryAddressModel.fromJson(
        json['delivery_address'] ?? {},
      ),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_number': orderNumber,
        'customer_name': customerName,
        'customer_location': customerLocation,
        'customer_avatar': customerAvatar,
        'items': items.map((e) => e.toJson()).toList(),
        'total_amount': totalAmount,
        'delivery_charge': deliveryCharge,
        'status': status.name,
        'payment_status': paymentStatus.name,
        'payment_method': paymentMethod,
        'delivery_address': deliveryAddress.toJson(),
        'created_at': createdAt.toIso8601String(),
        'note': note,
      };
}
