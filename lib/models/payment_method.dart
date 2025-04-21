import 'package:marketsapce_app/@types/payment_type.dart';

class PaymentMethod {
  final String id;
  final String productId;
  final PaymentType type;

  const PaymentMethod({
    required this.id,
    required this.productId,
    required this.type,
  });

  set id(String id) {
    this.id = id;
  }

  set productId(String productId) {
    this.productId = productId;
  }

  set type(PaymentType type) {
    this.type = type;
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      productId: json['product_id'],
      type: PaymentType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => PaymentType.pix,
      ),
    );
  }
}
