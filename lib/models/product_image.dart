class ProductImage {
  final String id;
  final String fileName;
  final String uniqueName;
  final String url;
  final String productId;

  const ProductImage({
    required this.id,
    required this.fileName,
    required this.uniqueName,
    required this.url,
    required this.productId,
  });

  set id(String id) {
    this.id = id;
  }

  set fileName(String fileName) {
    this.fileName = fileName;
  }

  set uniqueName(String uniqueName) {
    this.uniqueName = uniqueName;
  }

  set url(String url) {
    this.url = url;
  }

  set productId(String productId) {
    this.productId = productId;
  }

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      fileName: json['file_name'],
      uniqueName: json['unique_name'],
      url: json['url'],
      productId: json['product_id'],
    );
  }

  @override
  String toString() {
    return 'ProductImage{id: $id, fileName: $fileName, uniqueName: $uniqueName, url: $url, productId: $productId}';
  }
}
