import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/models/edit_ad_preview.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/components/loading_overlay.dart';
import 'package:marketsapce_app/providers/products_providers.dart';
import 'package:marketsapce_app/components/product_state_badge.dart';

class EditAdPreviewScreen extends StatefulWidget {
  final EditAdPreview adPreviewData;

  const EditAdPreviewScreen({super.key, required this.adPreviewData});

  @override
  State<EditAdPreviewScreen> createState() => _EditAdPreviewScreenState();
}

class _EditAdPreviewScreenState extends State<EditAdPreviewScreen> {
  bool _isLoading = false;

  Future<void> publishAd() async {
    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> data = {
        'name': widget.adPreviewData.title,
        'description': widget.adPreviewData.description,
        'is_new': widget.adPreviewData.isNew,
        'price': widget.adPreviewData.price * 100,
        'accept_trade': widget.adPreviewData.isTradable,
        'payment_types': widget.adPreviewData.paymentMethods,
      };

      final productProvider = Provider.of<ProductsProviders>(
        context,
        listen: false,
      );

      await productProvider.updateProduct(widget.adPreviewData.productId, data);

      final imageFiles =
          widget.adPreviewData.images
              .where((item) => item.isLocalImage)
              .toList()
              .map((item) => item.file!)
              .toList();

      // Upload de imagens
      if (imageFiles.isNotEmpty) {
        await productProvider.uploadProductImages(
          widget.adPreviewData.productId,
          imageFiles,
        );
      }

      // Deletar imagens
      if (widget.adPreviewData.removeMarkedImages != null &&
          widget.adPreviewData.removeMarkedImages!.isNotEmpty) {
        await productProvider.deleteProductImages(
          widget.adPreviewData.removeMarkedImages!,
        );
      }

      if (context.mounted) {
        Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.home));
      }
    } catch (error) {
      print('Publish Edit Ad error: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar:
          !_isLoading
              ? AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: AppColors.blueLight,
                centerTitle: true,
                title: Column(
                  children: [
                    Text(
                      'Prévia do anúncio',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      'É assim que seu anúncio vai aparecer!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
              : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: CarouselView.weighted(
                    padding: EdgeInsets.all(0),
                    flexWeights: [10],
                    itemSnapping:
                        true, // Suavidade da transição entre as imagens
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    children:
                        widget.adPreviewData.images.map((item) {
                          return item.isLocalImage
                              ? Image.file(item.file!, fit: BoxFit.cover)
                              : Image.network(
                                item.image!.url,
                                fit: BoxFit.cover,
                              );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 80,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
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
                                    widget.adPreviewData.perfilUrl,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.adPreviewData.author,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ProductStateBadge(isNew: widget.adPreviewData.isNew),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.adPreviewData.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                NumberFormat.simpleCurrency(
                                  locale: 'pt-BR',
                                  decimalDigits: 2,
                                ).format(widget.adPreviewData.price),

                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blueLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.adPreviewData.description,
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
                                widget.adPreviewData.isTradable ? 'Sim' : 'Não',
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
                                widget.adPreviewData.paymentMethods.map((item) {
                                  return Text(
                                    '\u2022 $item',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  );
                                }).toList(),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) LoadingOverlay(message: 'Publicando...'),
        ],
      ),
      bottomSheet:
          !_isLoading
              ? BottomSheet(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          label: 'Voltar e editar',
                          variant: Variant.muted,
                          icon: Icon(PhosphorIconsRegular.arrowLeft),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CustomButton(
                          label: 'Publicar',
                          icon: Icon(PhosphorIconsRegular.tag),
                          onPressed: () => publishAd(),
                        ),
                      ],
                    ),
                  );
                },
              )
              : null,
    );
  }
}
