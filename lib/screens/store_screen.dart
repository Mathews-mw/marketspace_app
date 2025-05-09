import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/components/custom_app_bar.dart';
import 'package:marketsapce_app/components/custom_text_field.dart';
import 'package:marketsapce_app/providers/products_providers.dart';
import 'package:marketsapce_app/components/store_components/filters.dart';
import 'package:marketsapce_app/components/store_components/product_card.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool _hasLoadedData = false;
  bool _isLoading = false;
  bool _isDirtyField = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(infinityScrollListener);
    _searchController.addListener(_handleDirtyField);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoadedData) {
      _hasLoadedData = true;
      _loadProductData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchController.dispose();
  }

  infinityScrollListener() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      print('Reached the end of the list!');

      await _loadProductData();
    }
  }

  Future<void> _loadProductData() async {
    setState(() => _isLoading = true);

    final productProvider = Provider.of<ProductsProviders>(
      context,
      listen: false,
    );

    final cursor = productProvider.cursor;
    final (:nextCursor, :previousCursor, :stillHaveData) = cursor;

    try {
      if (stillHaveData == false) {
        print('all data has been fetched!');
        return;
      }

      await productProvider.fetchProductsInfo(cursor: nextCursor);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> searchProducts() async {
    if (_searchController.text.isEmpty) return;

    print('search on function: ${_searchController.text}');

    await Provider.of<ProductsProviders>(
      context,
      listen: false,
    ).fetchProductsInfo(search: _searchController.text);
  }

  Future<void> clearFilter() async {
    _searchController.clear();

    Provider.of<ProductsProviders>(context, listen: false).clearProductsInfo();

    await Provider.of<ProductsProviders>(
      context,
      listen: false,
    ).fetchProductsInfo();
  }

  _handleShowFilterBottomSheet(BuildContext ctx) {
    return showModalBottomSheet(
      backgroundColor: AppColors.gray100,
      context: ctx,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Filters();
      },
    );
  }

  void _handleDirtyField() {
    if (_searchController.text.isNotEmpty) {
      setState(() => _isDirtyField = true);
    } else {
      setState(() => _isDirtyField = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            backgroundColor: AppColors.gray100,
            pinned: true,
            actionsPadding: const EdgeInsets.only(right: 16),
            actions: [
              CustomButton(
                icon: Icon(PhosphorIconsRegular.plus),
                label: 'Anunciar',
                variant: Variant.secondary,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.createAdvertise);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CustomAppBar(),
              title: Text(
                'Market Space',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray700,
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),

          SliverAppBar(
            backgroundColor: AppColors.gray100,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compre produtos variados',
                      style: TextStyle(fontSize: 16, color: AppColors.gray600),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: 'Buscar anúncio',
                            controller: _searchController,
                            textInputAction: TextInputAction.search,
                            suffixIcon: IconButton(
                              onPressed:
                                  _isDirtyField
                                      ? () async {
                                        await clearFilter();
                                      }
                                      : null,
                              icon:
                                  _isDirtyField
                                      ? Icon(PhosphorIconsRegular.xCircle)
                                      : Icon(
                                        PhosphorIconsRegular.magnifyingGlass,
                                      ),
                            ),
                            onFieldSubmitted: (value) async {
                              await searchProducts();
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed:
                              () => _handleShowFilterBottomSheet(context),
                          icon: Icon(PhosphorIconsRegular.funnel),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: Consumer<ProductsProviders>(
              builder: (ctx, productsProvider, child) {
                final products = productsProvider.productsInfo;

                return SliverStack(
                  insetOnOverlap: false,
                  children: [
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        childCount: products.length,
                        (context, index) {
                          return ProductCard(productInfo: products[index]);
                        },
                      ),
                    ),
                    if (_isLoading) LoadingIndicator(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPositioned(
      left: (MediaQuery.sizeOf(context).width / 2) - 36,
      bottom: 16,
      child: const SizedBox(
        width: 40,
        height: 40,
        child: CircleAvatar(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}
