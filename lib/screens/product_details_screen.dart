import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/@exceptions/api_exceptions.dart';
import 'package:marketsapce_app/providers/products_providers.dart';
import 'package:marketsapce_app/components/error_alert_dialog.dart';
import 'package:marketsapce_app/components/product_state_badge.dart';
import 'package:marketsapce_app/models/data_transfer_objects/product-details.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Future<ProductDetails>? _productDetailsFuture;

  @override
  void initState() {
    super.initState();

    _productDetailsFuture = getProductDetails(context, widget.productId);
  }

  Future<ProductDetails> getProductDetails(
    BuildContext ctx,
    String productId,
  ) async {
    try {
      final productDetails = await Provider.of<ProductsProviders>(
        context,
        listen: false,
      ).getProductDetails(productId);

      return productDetails;
    } on ApiExceptions catch (error) {
      if (ctx.mounted) {
        ErrorAlertDialog.showDialogError(
          context: ctx,
          title: 'Erro ao tentar buscar por produto',
          code: error.code,
          message: error.message,
        );
      }
      throw Exception('Failed to fetch product details: ${error.message}');
    } catch (error) {
      print('Unexpected error: $error');
      throw Exception('Unexpected error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProductDetails>(
        future: _productDetailsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return Center(
              child: Text(
                'Produto não encontrado!',
                textAlign: TextAlign.center,
              ),
            );
          }

          final productDetails = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.black38),
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                // iconTheme: const IconThemeData(color: Colors.white),
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: widget.productId,
                    child: CarouselView.weighted(
                      padding: EdgeInsets.all(0),
                      flexWeights: [10],
                      itemSnapping:
                          true, // Suavidade da transição entre as imagens
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      onTap:
                          (index) => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => Scaffold(
                                    appBar: AppBar(),
                                    body: SizedBox.expand(
                                      child: Image.network(
                                        productDetails.images[index].url,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                      children:
                          productDetails.images.map((image) {
                            return Image.network(image.url, fit: BoxFit.cover);
                          }).toList(),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                  color: AppColors.blueLight,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(
                                  productDetails.owner.avatar ??
                                      'https://api.dicebear.com/9.x/thumbs/png?seed=${productDetails.owner.name}',
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              productDetails.owner.name,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ProductStateBadge(isNew: true),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                productDetails.product.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Text(
                              NumberFormat.simpleCurrency(
                                locale: 'pt-BR',
                                decimalDigits: 2,
                              ).format((productDetails.product.price / 100)),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blueLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          productDetails.product.description,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              'Aceita troca?',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              productDetails.product.acceptTrade
                                  ? 'Sim'
                                  : 'Não',
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Meios de pagamento: ',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              productDetails.paymentMethods.map((item) {
                                return Text(
                                  '\u2022 ${item.type.label}',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
      bottomSheet: FutureBuilder<ProductDetails>(
        future: _productDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return Center(child: Text('', textAlign: TextAlign.center));
          }

          final productDetails = snapshot.data!;

          return BottomSheet(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
            ),
            onClosing: () {},
            builder: (ctx) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      NumberFormat.simpleCurrency(
                        locale: 'pt-BR',
                        decimalDigits: 2,
                      ).format((productDetails.product.price / 100)),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueLight,
                      ),
                    ),
                    CustomButton(label: 'Comprar', onPressed: () {}),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
