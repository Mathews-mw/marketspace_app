import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/providers/users_provider.dart';
import 'package:marketsapce_app/components/user_adds_components/user_product_card.dart';

typedef ProductStateEntry = DropdownMenuEntry<ProductStateLabel>;

enum ProductStateLabel {
  all('Todos', 'ALL'),
  active('Ativado', 'ACTIVE'),
  disabled('Desativado', 'disable');

  const ProductStateLabel(this.label, this.value);
  final String label;
  final String value;

  static final List<ProductStateEntry> entries =
      UnmodifiableListView<ProductStateEntry>(
        values.map<ProductStateEntry>(
          (ProductStateLabel item) =>
              ProductStateEntry(value: item, label: item.label),
        ),
      );
}

class UserAdsScreen extends StatefulWidget {
  const UserAdsScreen({super.key});

  @override
  State<UserAdsScreen> createState() => _UserAdsScreenState();
}

class _UserAdsScreenState extends State<UserAdsScreen> {
  bool _isLoading = false;
  bool _initialized = false;

  final TextEditingController productStateController = TextEditingController();
  ProductStateLabel? productState;

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
        child: Consumer<UsersProvider>(
          builder: (ctx, userProvider, child) {
            final userProducts = userProvider.userProducts;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeletonizer(
                      enabled: _isLoading,
                      child: Text('${userProducts.length} anúncio(s)'),
                    ),
                    Skeletonizer(
                      enabled: _isLoading,
                      child: DropdownMenu<ProductStateLabel>(
                        requestFocusOnTap: true,
                        controller: productStateController,
                        dropdownMenuEntries: ProductStateLabel.entries,
                        initialSelection: ProductStateLabel.all,
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: Colors.white,
                          constraints: BoxConstraints(
                            maxHeight: 50,
                            maxWidth: 180,
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onSelected: (ProductStateLabel? value) {
                          setState(() {
                            productState = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    itemCount: userProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return UserProductCard(
                        productInfo: userProducts[index],
                        onUpdateProduct: _loadUserProductsData,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
