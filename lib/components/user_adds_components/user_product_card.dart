import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/screens/user_product_details_screen.dart';
import 'package:marketsapce_app/models/data_transfer_objects/product_info.dart';

class UserProductCard extends StatelessWidget {
  final ProductInfo productInfo;
  final Future<void> Function() onUpdateProduct;

  const UserProductCard({
    super.key,
    required this.productInfo,
    required this.onUpdateProduct,
  });

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
                colorFilter:
                    productInfo.product.isNew
                        ? null
                        : ColorFilter.mode(Colors.black45, BlendMode.darken),
                image: CachedNetworkImageProvider(productInfo.images[0].url),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final updated = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UserProductDetailsScreen(
                            productId: productInfo.product.id,
                          ),
                    ),
                  );

                  if (updated == true) {
                    await onUpdateProduct();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  productInfo.product.isNew
                                      ? Color.fromARGB(100, 54, 77, 157)
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
                      if (!productInfo.product.isActive)
                        Text(
                          'ANÚNCIO DESATIVADO',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
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
