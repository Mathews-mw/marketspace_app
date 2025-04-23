import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/components/loading_overlay.dart';
import 'package:marketsapce_app/@exceptions/api_exceptions.dart';
import 'package:marketsapce_app/providers/products_providers.dart';
import 'package:marketsapce_app/screens/edit_advertise_screen.dart';
import 'package:marketsapce_app/components/error_alert_dialog.dart';
import 'package:marketsapce_app/components/product_state_badge.dart';
import 'package:marketsapce_app/models/data_transfer_objects/product-details.dart';

class UserProductDetailsScreen extends StatefulWidget {
  final String productId;

  const UserProductDetailsScreen({super.key, required this.productId});

  @override
  State<UserProductDetailsScreen> createState() =>
      _UserProductDetailsScreenState();
}

class _UserProductDetailsScreenState extends State<UserProductDetailsScreen> {
  Future<ProductDetails>? _productDetailsFuture;
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  bool _isLoading = false;

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

  Future<void> toggleProductActivation(String productId, bool isActive) async {
    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductsProviders>(
        context,
        listen: false,
      ).updateProduct(productId, {"is_active": isActive});
    } on ApiExceptions catch (error) {
      ErrorAlertDialog.showDialogError(
        context: context,
        title: 'Erro ao tentar alterar o status de ativação do produto',
        code: error.code,
        message: error.message,
      );
      throw Exception('Failed to update product: ${error.message}');
    } catch (error) {
      print('Unexpected error: $error');
      throw Exception('Unexpected error occurred');
    } finally {
      setState(() => _isLoading = false);
    }

    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> handleDeleteProduct(String productId) async {
    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductsProviders>(
        context,
        listen: false,
      ).deleteProduct(productId);
    } on ApiExceptions catch (error) {
      ErrorAlertDialog.showDialogError(
        context: context,
        title: 'Erro ao tentar deletar produto',
        code: error.code,
        message: error.message,
      );
      throw Exception('Failed to delete product: ${error.message}');
    } catch (error) {
      print('Unexpected error: $error');
      throw Exception('Unexpected error occurred');
    } finally {
      setState(() => _isLoading = false);
    }

    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductDetails>(
      future: _productDetailsFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            extendBody: true,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Gerenciar anúncio')),
            body: const Center(
              child: Text(
                'Produto não encontrado!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final productDetails = snapshot.data!;

        return Scaffold(
          extendBody: _isLoading,
          appBar:
              _isLoading
                  ? null
                  : AppBar(
                    title: const Text('Gerenciar anúncio'),
                    actions: <Widget>[
                      MyCascadingMenu(
                        productDetails: productDetails,
                        onActivationAd: () async {
                          await toggleProductActivation(
                            productDetails.product.id,
                            !productDetails.product.isActive,
                          );
                        },
                        onDeleteAd: () async {
                          await handleDeleteProduct(productDetails.product.id);
                        },
                      ),
                    ],
                  ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        onTap:
                            (index) => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => Scaffold(
                                      appBar: AppBar(),
                                      body: SizedBox.expand(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              productDetails.images[index].url,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                        children:
                            productDetails.images.map((image) {
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(image.url, fit: BoxFit.cover),
                                  if (!productDetails.product.isActive)
                                    const DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'ANÚNCIO DESATIVADO',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.gray300,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                        bottom: 42,
                      ),
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
                                  backgroundImage: CachedNetworkImageProvider(
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
                          ProductStateBadge(
                            isNew: productDetails.product.isNew,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  productDetails.product.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading) LoadingOverlay(message: 'Atualizando...'),
            ],
          ),
        );
      },
    );
  }
}

class MyCascadingMenu extends StatefulWidget {
  final ProductDetails productDetails;
  final Future<void> Function() onActivationAd;
  final Future<void> Function() onDeleteAd;

  const MyCascadingMenu({
    super.key,
    required this.productDetails,
    required this.onActivationAd,
    required this.onDeleteAd,
  });

  @override
  State<MyCascadingMenu> createState() => _MyCascadingMenuState();
}

class _MyCascadingMenuState extends State<MyCascadingMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  showActivationAdDialog() {
    return showDialog<bool>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            backgroundColor: AppColors.gray100,
            title: Text(
              widget.productDetails.product.isActive
                  ? 'Desativar anúncio'
                  : 'Ativar anúncio',
            ),
            content: Text(
              widget.productDetails.product.isActive
                  ? 'Você tem certeza que deseja desativar esse anúncio?'
                  : 'Você tem certeza que deseja ativar esse anúncio?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  widget.productDetails.product.isActive
                      ? 'DESATIVAR'
                      : 'ATIVAR',
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('NÃO'),
              ),
            ],
          ),
    );
  }

  showDeleteAdDialog() {
    return showDialog<bool>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            backgroundColor: AppColors.gray100,
            title: const Text(
              'DELETAR PRODUTO',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Text('Você realmente deseja DELETAR esse anúncio?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('SIM', style: TextStyle(color: AppColors.error)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('NÃO'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      menuChildren: <Widget>[
        MenuItemButton(
          leadingIcon: Icon(PhosphorIconsRegular.pencilSimpleLine, size: 20),
          child: const Text('Editar'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EditAdVertiseScreen(
                      productDetails: widget.productDetails,
                    ),
              ),
            );
          },
        ),
        if (widget.productDetails.product.isActive)
          MenuItemButton(
            leadingIcon: Icon(PhosphorIconsRegular.power, size: 20),
            onPressed: () async {
              final result = await showActivationAdDialog();

              if (result) {
                await widget.onActivationAd();
              } else {
                return;
              }
            },
            child: const Text('Desativar'),
          ),
        if (!widget.productDetails.product.isActive)
          MenuItemButton(
            leadingIcon: Icon(PhosphorIconsRegular.power, size: 20),
            child: const Text('Reativar'),
            onPressed: () async {
              final result = await showActivationAdDialog();

              if (result) {
                await widget.onActivationAd();
              } else {
                return;
              }
            },
          ),
        MenuItemButton(
          leadingIcon: Icon(PhosphorIconsRegular.trash, size: 20),
          child: const Text('Excluir'),
          onPressed: () async {
            final result = await showDeleteAdDialog();
            if (result) {
              await widget.onDeleteAd();
            } else {
              return;
            }
          },
        ),
      ],
      builder: (_, MenuController controller, Widget? child) {
        return IconButton(
          focusNode: _buttonFocusNode,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
        );
      },
    );
  }
}
