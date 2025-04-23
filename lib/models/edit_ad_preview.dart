import 'dart:io';

import 'package:marketsapce_app/models/product_image.dart';

class EditAdPreview {
  final String productId;
  final String author;
  final String perfilUrl;
  final String title;
  final String description;
  final double price;
  final bool isNew;
  final bool isTradable;
  final List<String> paymentMethods;
  final List<({bool isLocalImage, File? file, ProductImage? image})> images;
  final List<String>? removeMarkedImages;

  EditAdPreview({
    required this.productId,
    required this.author,
    required this.perfilUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.isNew,
    required this.isTradable,
    required this.paymentMethods,
    required this.images,
    this.removeMarkedImages,
  });

  @override
  String toString() {
    return 'AdPreview(author: $author, perfilUrl: $perfilUrl, title: $title, description: $description, price: $price, isNew: $isNew, isTradable: $isTradable, paymentMethods: $paymentMethods, images: $images)';
  }
}
