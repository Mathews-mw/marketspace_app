import 'package:flutter/material.dart';
import 'package:marketsapce_app/providers/users_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/components/user_adds_components/user_product_card.dart';
import 'package:provider/provider.dart';

class UserAdsScreen extends StatefulWidget {
  const UserAdsScreen({super.key});

  @override
  State<UserAdsScreen> createState() => _UserAdsScreenState();
}

class _UserAdsScreenState extends State<UserAdsScreen> {
  bool _isLoading = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;
      _loadUserProductsData();
    }
  }

  Future<void> _loadUserProductsData() async {
    setState(() => _isLoading = true);

    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    try {
      final user = userProvider.user;

      if (user != null) {
        await userProvider.fetchUserProducts(user.id);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        backgroundColor: AppColors.gray100,
        title: Text('Meus anúncios'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.plus),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.createAdvertise);
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints.expand(height: double.infinity),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Text('9 anúncios')]),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: productList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return UserProductCard(
                    id: productList[index].id,
                    name: productList[index].name,
                    price: productList[index].price,
                    owner: productList[index].owner,
                    ownerImageUrl: productList[index].ownerImageUrl,
                    isNew: productList[index].isNew,
                    isActive: productList[index].isActive,
                    imageUrl: productList[index].imageUrl,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<ProductItem> productList = [
  ProductItem(
    id: '1',
    name: 'Bicicleta Cross',
    price: '1500,00',
    owner: 'Maria Gomes',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    isActive: true,
    imageUrl:
        'https://plus.unsplash.com/premium_photo-1678718713393-2b88cde9605b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '2',
    name: 'Bicicleta Street',
    price: '1200,00',
    owner: 'Maria Gomes',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    isActive: true,
    imageUrl:
        'https://images.unsplash.com/photo-1485965120184-e220f721d03e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '3',
    name: 'Camisa 705 - Preta',
    price: '59,00',
    owner: 'Maria Gomes',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    isActive: true,
    imageUrl:
        'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?q=80&w=2030&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '4',
    name: 'Tênis Nike',
    price: '500,00',
    owner: 'Maria Gomes',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    isActive: true,
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '5',
    name: 'Tênis All Star',
    price: '249,99',
    owner: 'Maria Gomes',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: false,
    isActive: false,
    imageUrl:
        'https://plus.unsplash.com/premium_photo-1682125177822-63c27a3830ea?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
];

class ProductItem {
  String id;
  String name;
  String price;
  String owner;
  String ownerImageUrl;
  bool isNew;
  bool isActive;
  String imageUrl;

  ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.owner,
    required this.ownerImageUrl,
    required this.isNew,
    required this.isActive,
    required this.imageUrl,
  });
}
