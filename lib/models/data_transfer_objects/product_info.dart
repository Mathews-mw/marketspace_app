import 'package:marketsapce_app/models/product.dart';
import 'package:marketsapce_app/models/product_image.dart';
import 'package:marketsapce_app/models/payment_method.dart';

class ProductInfo {
  final Product product;
  final List<ProductImage> images;
  final List<PaymentMethod> paymentMethods;
  final ProductOwner owner;

  const ProductInfo({
    required this.product,
    required this.images,
    required this.paymentMethods,
    required this.owner,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      product: Product.fromJson(json),
      images:
          (json['images'] as List)
              .map((image) => ProductImage.fromJson(image))
              .toList(),
      paymentMethods:
          (json['payment_methods'] as List)
              .map((method) => PaymentMethod.fromJson(method))
              .toList(),
      owner: ProductOwner.fromJson(json['owner']),
    );
  }
}

class ProductOwner {
  final String name;
  final String email;
  final String? avatar;

  const ProductOwner({required this.name, required this.email, this.avatar});

  factory ProductOwner.fromJson(Map<String, dynamic> json) {
    return ProductOwner(
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] != null ? json['avatar'] as String : null,
    );
  }
}
