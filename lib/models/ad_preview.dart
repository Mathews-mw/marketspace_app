import 'dart:io';

class AdPreview {
  final String author;
  final String perfilUrl;
  final String title;
  final String description;
  final double price;
  final bool isNew;
  final bool isTradable;
  final List<String> paymentMethods;
  final List<File> images;

  AdPreview({
    required this.author,
    required this.perfilUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.isNew,
    required this.isTradable,
    required this.paymentMethods,
    required this.images,
  });

  @override
  String toString() {
    return 'AdPreview(author: $author, perfilUrl: $perfilUrl, title: $title, description: $description, price: $price, isNew: $isNew, isTradable: $isTradable, paymentMethods: $paymentMethods, images: $images)';
  }
}
