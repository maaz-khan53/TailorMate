enum OrderStatus {
  pending,
  inProgress,
  ready,
  delivered,
  cancelled,
}

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class OrderPayment {
  const OrderPayment({
    required this.id,
    required this.amount,
    required this.receivedAt,
    this.note = '',
  });

  final String id;
  final double amount;
  final DateTime receivedAt;
  final String note;
}

class TailorOrder {
  const TailorOrder({
    required this.id,
    required this.orderCode,
    required this.customerId,
    required this.customerCode,
    required this.customerName,
    required this.phone,
    required this.category,
    required this.dressName,
    required this.createdAt,
    required this.deliveryDate,
    required this.totalBill,
    required this.advance,
    required this.status,
    this.customerPhotoPath,
    this.orderNotes = '',
    this.tailorNotes = '',
    this.measurements = const <String, String>{},
    this.designDetails = const <String, String>{},
    this.payments = const <OrderPayment>[],
  });

  final String id;
  final String orderCode;
  final String customerId;
  final String customerCode;
  final String customerName;
  final String phone;
  final String category;
  final String dressName;
  final DateTime createdAt;
  final DateTime deliveryDate;
  final double totalBill;
  final double advance;
  final OrderStatus status;
  final String? customerPhotoPath;
  final String orderNotes;
  final String tailorNotes;
  final Map<String, String> measurements;
  final Map<String, String> designDetails;
  final List<OrderPayment> payments;

  double get receivedAfterAdvance {
    return payments.fold<double>(
      0,
          (double total, OrderPayment payment) => total + payment.amount,
    );
  }

  double get totalReceived => advance + receivedAfterAdvance;

  double get remaining {
    final double value = totalBill - totalReceived;
    return value < 0 ? 0 : value;
  }

  bool get isFullyPaid => remaining <= 0;

  TailorOrder copyWith({
    String? id,
    String? orderCode,
    String? customerId,
    String? customerCode,
    String? customerName,
    String? phone,
    String? category,
    String? dressName,
    DateTime? createdAt,
    DateTime? deliveryDate,
    double? totalBill,
    double? advance,
    OrderStatus? status,
    String? customerPhotoPath,
    String? orderNotes,
    String? tailorNotes,
    Map<String, String>? measurements,
    Map<String, String>? designDetails,
    List<OrderPayment>? payments,
  }) {
    return TailorOrder(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      customerId: customerId ?? this.customerId,
      customerCode: customerCode ?? this.customerCode,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      category: category ?? this.category,
      dressName: dressName ?? this.dressName,
      createdAt: createdAt ?? this.createdAt,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      totalBill: totalBill ?? this.totalBill,
      advance: advance ?? this.advance,
      status: status ?? this.status,
      customerPhotoPath: customerPhotoPath ?? this.customerPhotoPath,
      orderNotes: orderNotes ?? this.orderNotes,
      tailorNotes: tailorNotes ?? this.tailorNotes,
      measurements: measurements ?? this.measurements,
      designDetails: designDetails ?? this.designDetails,
      payments: payments ?? this.payments,
    );
  }

  static List<TailorOrder> demoOrders() {
    return <TailorOrder>[
      TailorOrder(
        id: 'order-1',
        orderCode: 'ORD-1001',
        customerId: 'customer-1',
        customerCode: 'TX-0012',
        customerName: 'Ali Ahmed',
        phone: '0300 1234567',
        category: 'Gents',
        dressName: 'Shalwar Kameez',
        createdAt: DateTime(2026, 7, 22),
        deliveryDate: DateTime(2026, 7, 28),
        totalBill: 5500,
        advance: 2000,
        status: OrderStatus.pending,
        orderNotes: 'Customer needs delivery before evening.',
        tailorNotes: 'Keep normal fitting and previous collar style.',
        measurements: const <String, String>{
          'Length': '43',
          'Sleeve': '24',
          'Shoulder': '18',
          'Collar': '15.5',
          'Chest': '43',
          'Waist': '44',
          'Shalwar': '40',
          'Pancha': '8',
        },
        designDetails: const <String, String>{
          'Side Pocket': 'Double Side Pocket',
          'Front Pocket': 'Yes',
          'Collar Style': 'Small',
          'Daman Style': 'Rounded',
        },
      ),
      TailorOrder(
        id: 'order-2',
        orderCode: 'ORD-1002',
        customerId: 'customer-2',
        customerCode: 'TX-0013',
        customerName: 'Usman Khan',
        phone: '0312 7654321',
        category: 'Gents',
        dressName: 'Waistcoat',
        createdAt: DateTime(2026, 7, 23),
        deliveryDate: DateTime(2026, 7, 27),
        totalBill: 4200,
        advance: 1500,
        status: OrderStatus.inProgress,
        measurements: const <String, String>{
          'Collar': '15',
          'Shoulder': '17.5',
          'Chest': '41',
          'Waist': '39',
          'Length': '27',
          'Hip': '42',
        },
        designDetails: const <String, String>{
          'Buttons': '5 Buttons',
          'Pocket': 'Three Pocket',
        },
      ),
      TailorOrder(
        id: 'order-3',
        orderCode: 'ORD-1003',
        customerId: 'customer-3',
        customerCode: 'TX-0014',
        customerName: 'Hamza Tariq',
        phone: '0333 1112233',
        category: 'Gents',
        dressName: 'Kurta',
        createdAt: DateTime(2026, 7, 20),
        deliveryDate: DateTime(2026, 7, 25),
        totalBill: 3500,
        advance: 3500,
        status: OrderStatus.ready,
        payments: const <OrderPayment>[],
        measurements: const <String, String>{
          'Length': '42',
          'Sleeve': '23',
          'Shoulder': '17',
          'Collar': '15',
          'Chest': '40',
        },
      ),
      TailorOrder(
        id: 'order-4',
        orderCode: 'ORD-1004',
        customerId: 'customer-4',
        customerCode: 'TX-0015',
        customerName: 'Bilal Noor',
        phone: '0345 2223344',
        category: 'Gents',
        dressName: 'Suit / Blazer',
        createdAt: DateTime(2026, 7, 15),
        deliveryDate: DateTime(2026, 7, 24),
        totalBill: 18500,
        advance: 10000,
        status: OrderStatus.delivered,
        payments: <OrderPayment>[
          OrderPayment(
            id: 'payment-1',
            amount: 8500,
            receivedAt: DateTime(2026, 7, 24),
            note: 'Final payment received.',
          ),
        ],
      ),
      TailorOrder(
        id: 'order-5',
        orderCode: 'ORD-1005',
        customerId: 'customer-5',
        customerCode: 'TX-0016',
        customerName: 'Saad Raza',
        phone: '0301 9988776',
        category: 'Gents',
        dressName: 'Dress Shirt',
        createdAt: DateTime(2026, 7, 21),
        deliveryDate: DateTime(2026, 7, 30),
        totalBill: 3000,
        advance: 500,
        status: OrderStatus.cancelled,
        orderNotes: 'Cancelled by customer.',
      ),
    ];
  }
}
