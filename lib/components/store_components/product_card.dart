import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/screens/product_details_screen.dart';
import 'package:marketsapce_app/models/data_transfer_objects/product_info.dart';

class ProductCard extends StatelessWidget {
  final ProductInfo productInfo;

  const ProductCard({super.key, required this.productInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: productInfo.product.id,
          child: Container(
            clipBehavior: Clip.hardEdge,
            constraints: const BoxConstraints(
              maxHeight: 120,
              maxWidth: double.infinity,
            ),
            decoration: BoxDecoration(
              color: AppColors.blueLight,
              image: DecorationImage(
                image: CachedNetworkImageProvider(productInfo.images[0].url),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProductDetailsScreen(
                            productId: productInfo.product.id,
                          ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              // backgroundColor: Colors.transparent,
                              backgroundImage: CachedNetworkImageProvider(
                                productInfo.owner.avatar ??
                                    'https://api.dicebear.com/9.x/thumbs/png?seed=${productInfo.owner.name}',
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  productInfo.product.isNew
                                      ? const Color.fromARGB(100, 54, 77, 157)
                                      : const Color.fromARGB(100, 0, 0, 0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              productInfo.product.isNew ? 'NOVO' : 'USADO',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Text(
          productInfo.product.name,
          style: TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),
        ),
        Text(
          NumberFormat.simpleCurrency(
            locale: 'pt-BR',
            decimalDigits: 2,
          ).format((productInfo.product.price / 100)),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
