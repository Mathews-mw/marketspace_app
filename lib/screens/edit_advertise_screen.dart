import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/@types/payment_type.dart';
import 'package:marketsapce_app/models/product_image.dart';
import 'package:marketsapce_app/models/edit_ad_preview.dart';
import 'package:marketsapce_app/providers/users_provider.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/components/custom_text_field.dart';
import 'package:marketsapce_app/utils/currency_format_remover.dart';
import 'package:marketsapce_app/@mixins/form_validations_mixin.dart';
import 'package:marketsapce_app/screens/edit_ad_preview_screen.dart';
import 'package:marketsapce_app/models/data_transfer_objects/product-details.dart';

class EditAdVertiseScreen extends StatefulWidget {
  final ProductDetails productDetails;

  const EditAdVertiseScreen({super.key, required this.productDetails});

  @override
  State<EditAdVertiseScreen> createState() => _EditAdVertiseScreen();
}

class _EditAdVertiseScreen extends State<EditAdVertiseScreen>
    with FormValidationsMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  bool _isLoading = false;

  String? isNew;
  bool? isCheckedPix = false;
  bool? isCheckedBoleto = false;
  bool? isCheckedDinheiro = false;
  bool? isCheckedCredito = false;
  bool? isCheckedDeposito = false;
  bool acceptTrade = false;

  List<String> _paymentMethods = [];

  final List<String> _removeMarkedImages = [];
  final List<({bool isLocalImage, File? file, ProductImage? image})> _images =
      [];

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

  Future<void> _takePicture(BuildContext ctx, ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    if (source == ImageSource.camera) {
      final imageFromCamera = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (imageFromCamera == null) return;

      final file = File(imageFromCamera.path);

      setState(() {
        _images.add((isLocalImage: true, file: file, image: null));
      });
    } else {
      final imagesFromCamera = await picker.pickMultiImage(limit: 3);

      if (imagesFromCamera.length > 3) {
        if (ctx.mounted) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Por favor, selecione apenas 3 imagens!')),
          );

          return;
        } else {
          return;
        }
      }

      imagesFromCamera.forEach((image) {
        final file = File(image.path);

        setState(() {
          _images.add((isLocalImage: true, file: file, image: null));
        });
      });
    }

    if (ctx.mounted) {
      Navigator.of(ctx).pop();
    }
  }

  _removeImageFromList(int index) {
    setState(() {
      final removed = _images.removeAt(index);
      print('removed item: $removed');
      if (!removed.isLocalImage) {
        _removeMarkedImages.add(removed.image!.id);
      }
    });
  }

  _onReorderList(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final item = _images.removeAt(oldIndex);

      _images.insert(newIndex, item);
    });
  }

  Future<void> handleSubmitForm() async {
    setState(() => _isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      print('Invalid form!');
      return;
    }

    formKey.currentState?.save();

    try {
      final user = Provider.of<UsersProvider>(context, listen: false).user;

      final adPreviewData = EditAdPreview(
        productId: widget.productDetails.product.id,
        author: user!.name,
        perfilUrl:
            user.avatar ??
            'https://api.dicebear.com/9.x/thumbs/png?seed=${user.name}',
        title: formData['title'] as String,
        description: formData['description'] as String,
        price: CurrencyFormatRemover.parseBrl(formData['price'] as String),
        isNew: formData['isNew'] as bool,
        isTradable: formData['acceptTrade'] as bool,
        paymentMethods: _paymentMethods,
        images: _images,
        removeMarkedImages: _removeMarkedImages,
      );

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => EditAdPreviewScreen(adPreviewData: adPreviewData),
          ),
        );
      }
    } catch (error) {
      print('Submit form error: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    formData['id'] = widget.productDetails.product.id;
    formData['title'] = widget.productDetails.product.name;
    formData['description'] = widget.productDetails.product.description;
    formData['price'] = widget.productDetails.product.price;
    formData['isNew'] = widget.productDetails.product.isNew;
    formData['acceptTrade'] = widget.productDetails.product.acceptTrade;

    acceptTrade = widget.productDetails.product.acceptTrade;
    isNew = widget.productDetails.product.isNew ? 'NEW' : 'OLD';

    widget.productDetails.images.forEach((item) {
      _images.add((isLocalImage: false, file: null, image: item));
    });

    _paymentMethods =
        widget.productDetails.paymentMethods
            .map((item) => item.type.value)
            .toList();

    isCheckedPix = _paymentMethods.contains(PaymentType.pix.value);
    isCheckedBoleto = _paymentMethods.contains(PaymentType.boleto.value);
    isCheckedDinheiro = _paymentMethods.contains(PaymentType.dinheiro.value);
    isCheckedCredito = _paymentMethods.contains(PaymentType.credito.value);
    isCheckedDeposito = _paymentMethods.contains(PaymentType.deposito.value);
  }

  @override
  void dispose() {
    formData.clear();
    super.dispose();
  }

  Future<void> _takePictureDialog() async {
    await showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: AppColors.gray100,
            title: Text('Selecione uma imagem'),
            content: Text(
              'Selecione uma imagem da sua galeria de fotos ou tire uma nova foto com a câmera do seu smartphone.',
            ),
            actions: [
              TextButton(
                onPressed: () => _takePicture(context, ImageSource.gallery),
                child: const Text('GALERIA'),
              ),
              TextButton(
                onPressed: () => _takePicture(context, ImageSource.camera),
                child: const Text('CÂMERA'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(centerTitle: true, title: Text('Editar anúncio')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 32,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Imagens', style: Theme.of(context).textTheme.labelLarge),
                Text(
                  'Escolha até 3 imagens para mostrar o quando o seu produto é incrível!',
                ),
                const SizedBox(height: 10),
                if (_images.length < 3)
                  CustomButton(
                    label: 'Selecionar imagens',
                    onPressed: _takePictureDialog,
                    variant: Variant.muted,
                    icon: Icon(PhosphorIconsRegular.images),
                  ),
                const SizedBox(height: 10),
                if (_images.isNotEmpty)
                  SizedBox(
                    height: 100,
                    width: MediaQuery.sizeOf(context).width - 32,
                    child: ReorderableListView(
                      scrollDirection: Axis.horizontal,
                      onReorder: _onReorderList,
                      children: List.generate(
                        _images.length,
                        (index) => Container(
                          key: ValueKey(_images[index]),
                          child: ReorderableDragStartListener(
                            index: index,
                            child: Stack(
                              key: ValueKey(_images[index]),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: AppColors.gray300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child:
                                          _images[index].isLocalImage
                                              ? Image.file(
                                                _images[index].file!,
                                                fit: BoxFit.cover,
                                                width: 100,
                                              )
                                              : Image.network(
                                                _images[index].image!.url,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -5,
                                  right: -5,
                                  child: IconButton.filled(
                                    onPressed:
                                        () => _removeImageFromList(index),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.black45,
                                    ),
                                    iconSize: 18,
                                    padding: const EdgeInsets.all(2),
                                    constraints: BoxConstraints(
                                      maxHeight: 32,
                                      maxWidth: 32,
                                    ),
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 30),

                Text(
                  'Sobre o produto',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Título do anúncio',
                  textInputAction: TextInputAction.next,
                  validator: isNotEmpty,
                  initialValue: formData['title']?.toString(),
                  onSaved: (value) {
                    formData['title'] = value ?? '';
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Descreva do produto...',
                  minLines: 1,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  initialValue: formData['description']?.toString(),
                  validator: isNotEmpty,
                  onSaved: (value) {
                    formData['description'] = value ?? '';
                  },
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'NEW',
                          groupValue: isNew,
                          onChanged: (value) {
                            setState(() {
                              isNew = value;
                              formData['isNew'] = true;
                            });
                          },
                        ),
                        Text('Produto Novo'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'OLD',
                          groupValue: isNew,
                          onChanged: (value) {
                            setState(() {
                              isNew = value;
                              formData['isNew'] = false;
                            });
                          },
                        ),
                        Text('Produto Usado'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Venda', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Valor do produto',
                  keyboardType: TextInputType.number,
                  initialValue: NumberFormat.simpleCurrency(
                    locale: 'pt-BR',
                    decimalDigits: 2,
                  ).format((widget.productDetails.product.price / 100)),
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'pt-BR',
                      decimalDigits: 2,
                      symbol: 'R\$',
                    ),
                  ],
                  textInputAction: TextInputAction.next,
                  validator: isNotEmpty,
                  onSaved: (value) {
                    formData['price'] = value ?? '';
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Aceita troca?',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Switch(
                  thumbIcon: thumbIcon,
                  value: acceptTrade,
                  onChanged: (bool value) {
                    setState(() {
                      acceptTrade = value;
                      formData['acceptTrade'] = value;
                    });
                  },
                ),
                Text(
                  'Meios de pagamento',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedPix,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedPix = value;
                              if (value == true) {
                                _paymentMethods.add('PIX');
                              } else {
                                _paymentMethods.remove('PIX');
                              }
                            });
                          },
                        ),
                        Text('Pix'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedBoleto,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedBoleto = value;
                              if (value == true) {
                                _paymentMethods.add('BOLETO');
                              } else {
                                _paymentMethods.remove('BOLETO');
                              }
                            });
                          },
                        ),
                        Text('Boleto'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedDinheiro,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedDinheiro = value;
                              if (value == true) {
                                _paymentMethods.add('DINHEIRO');
                              } else {
                                _paymentMethods.remove('DINHEIRO');
                              }
                            });
                          },
                        ),
                        Text('Dinheiro'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedCredito,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedCredito = value;
                              if (value == true) {
                                _paymentMethods.add('CREDITO');
                              } else {
                                _paymentMethods.remove('CREDITO');
                              }
                            });
                          },
                        ),
                        Text('Crédito'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedDeposito,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedDeposito = value;
                              if (value == true) {
                                _paymentMethods.add('DEPOSITO');
                              } else {
                                _paymentMethods.remove('DEPOSITO');
                              }
                            });
                          },
                        ),
                        Text('Depósito'),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'Avançar',
                    onPressed: handleSubmitForm,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
