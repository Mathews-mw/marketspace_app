import 'package:marketsapce_app/models/user.dart';
import 'package:marketsapce_app/models/product.dart';
import 'package:marketsapce_app/models/product_image.dart';
import 'package:marketsapce_app/models/payment_method.dart';

class ProductDetails {
  final Product product;
  final List<ProductImage> images;
  final List<PaymentMethod> paymentMethods;
  final User owner;

  const ProductDetails({
    required this.product,
    required this.images,
    required this.paymentMethods,
    required this.owner,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      product: Product.fromJson(json),
      images:
          (json['images'] as List)
              .map((image) => ProductImage.fromJson(image))
              .toList(),
      paymentMethods:
          (json['payment_methods'] as List)
              .map((method) => PaymentMethod.fromJson(method))
              .toList(),
      owner: User.fromJson(json['owner']),
    );
  }
}
