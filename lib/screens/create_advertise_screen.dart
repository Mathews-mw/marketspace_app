import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/models/ad_preview.dart';
import 'package:marketsapce_app/screens/ad_preview_screen.dart';
import 'package:marketsapce_app/utils/currency_format_remover.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/components/custom_text_field.dart';
import 'package:marketsapce_app/@mixins/form_validations_mixin.dart';

class CreateAdVertiseScreen extends StatefulWidget {
  const CreateAdVertiseScreen({super.key});

  @override
  State<CreateAdVertiseScreen> createState() => _CreateAdVertiseScreen();
}

class _CreateAdVertiseScreen extends State<CreateAdVertiseScreen>
    with FormValidationsMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  String? isNew;
  bool? isCheckedPix = false;
  bool? isCheckedBoleto = false;
  bool? isCheckedDinheiro = false;
  bool? isCheckedCredito = false;
  bool? isCheckedDeposito = false;
  bool acceptTrade = false;

  List<String> _paymentMethods = [];
  List<File> _pickedImages = [];

  bool _isLoading = false;

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

      setState(() {
        _pickedImages.add(File(imageFromCamera.path));
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
        setState(() {
          _pickedImages.add(File(image.path));
        });
      });
    }

    if (ctx.mounted) {
      Navigator.of(ctx).pop();
    }
  }

  _removeImageFromList(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  _onReorderList(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final item = _pickedImages.removeAt(oldIndex);

      _pickedImages.insert(newIndex, item);
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
      // Simulate a network request
      // await Future.delayed(const Duration(seconds: 2));

      final adPreviewData = AdPreview(
        author: 'Maria Gomes',
        perfilUrl:
            'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        title: formData['title'] as String,
        description: formData['description'] as String,
        price: CurrencyFormatRemover.parseBrl(formData['price'] as String),
        isNew: formData['isNew'] as bool,
        isTradable: formData['acceptTrade'] as bool,
        paymentMethods: _paymentMethods,
        images: _pickedImages,
      );

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdPreviewScreen(adPreviewData: adPreviewData),
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('Criar anúncio', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.blueLight,
        iconTheme: IconThemeData(color: Colors.white),
      ),
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
                if (_pickedImages.length < 3)
                  CustomButton(
                    label: 'Selecionar imagens',
                    onPressed: _takePictureDialog,
                    variant: Variant.muted,
                    icon: Icon(PhosphorIconsRegular.images),
                  ),
                const SizedBox(height: 10),
                if (_pickedImages.isNotEmpty)
                  SizedBox(
                    height: 100,
                    width: MediaQuery.sizeOf(context).width - 32,
                    child: ReorderableListView(
                      scrollDirection: Axis.horizontal,
                      onReorder: _onReorderList,
                      children: List.generate(
                        _pickedImages.length,
                        (index) => Container(
                          key: ValueKey(_pickedImages[index]),
                          child: ReorderableDragStartListener(
                            index: index,
                            child: Stack(
                              key: ValueKey(_pickedImages[index]),
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
                                      child: Image.file(
                                        _pickedImages[index],
                                        fit: BoxFit.cover,
                                        width: 100,
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
