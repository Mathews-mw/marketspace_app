import 'package:flutter/material.dart';
import 'package:marketsapce_app/app_routes.dart';

import 'package:marketsapce_app/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  String id;
  String name;
  String price;
  String owner;
  String ownerImageUrl;
  bool isNew;
  String imageUrl;

  ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.owner,
    required this.ownerImageUrl,
    required this.isNew,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: id,
          child: Container(
            clipBehavior: Clip.hardEdge,
            constraints: const BoxConstraints(
              maxHeight: 120,
              maxWidth: double.infinity,
            ),
            decoration: BoxDecoration(
              color: AppColors.blueLight,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.productDetails, arguments: id);
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
                              backgroundImage: NetworkImage(ownerImageUrl),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isNew
                                      ? Color.fromARGB(100, 54, 77, 157)
                                      : const Color.fromARGB(100, 0, 0, 0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isNew ? 'NOVO' : 'USADO',
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
        Text(' $name', style: TextStyle(fontSize: 16)),
        Text(
          ' $price',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
