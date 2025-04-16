import 'package:flutter/material.dart';
import 'package:marketsapce_app/app_routes.dart';

import 'package:marketsapce_app/theme/app_colors.dart';

class UserProductCard extends StatelessWidget {
  String id;
  String name;
  String price;
  String owner;
  String ownerImageUrl;
  bool isNew;
  bool isActive;
  String imageUrl;

  UserProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.owner,
    required this.ownerImageUrl,
    required this.isNew,
    required this.isActive,
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
                colorFilter:
                    isNew
                        ? null
                        : ColorFilter.mode(Colors.black45, BlendMode.darken),
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
                  ).pushNamed(AppRoutes.userProductDetails, arguments: id);
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
                      if (!isActive)
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
        Text(' $name'),
        Text.rich(
          TextSpan(
            text: ' R\$ ',
            children: [TextSpan(text: price, style: TextStyle(fontSize: 18))],
          ),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            height: 0.8,
          ),
        ),
      ],
    );
  }
}
