import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/components/custom_text_field.dart';

class CreateAdVertiseScreen extends StatefulWidget {
  const CreateAdVertiseScreen({super.key});

  @override
  State<CreateAdVertiseScreen> createState() => _CreateAdVertiseScreen();
}

class _CreateAdVertiseScreen extends State<CreateAdVertiseScreen> {
  bool? isChecked = true;
  bool light1 = true;
  List<File> _pickedImages = [];

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

  Future<void> _takePicture(BuildContext ctx, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? singleImageFromCamera;
    final List<XFile>? multiImageFromCamera;

    print('Source camera: $source');

    if (source == ImageSource.camera) {
      final imageFromCamera = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (imageFromCamera == null) return;

      setState(() {
        print('Image path: ${imageFromCamera.path}');
        _pickedImages.add(File(imageFromCamera.path));
      });
    } else {
      print('Should pick from gallery!');
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
          print('Image path: ${image.path}');
          _pickedImages.add(File(image.path));
        });
      });
    }

    if (ctx.mounted) {
      Navigator.of(ctx).pop();
    }
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
      appBar: AppBar(title: Text('Criar anúncio')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 32,
            left: 16,
            right: 16,
          ),
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
                Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: MediaQuery.sizeOf(context).width - 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _pickedImages.length,
                        separatorBuilder:
                            (_, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: _takePictureDialog,
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              Text(
                'Sobre o produto',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 20),
              CustomTextField(hintText: 'Título do anúncio'),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Descreva do produto...',
                minLines: 1,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Novo',
                        groupValue: 'NOVO',
                        onChanged: (String? value) {
                          setState(() {});
                        },
                      ),
                      Text('Produto Novo'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Novo',
                        groupValue: 'NOVO',
                        onChanged: (String? value) {
                          setState(() {});
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
              ),
              const SizedBox(height: 10),
              Text(
                'Aceita troca?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Switch(
                thumbIcon: thumbIcon,
                value: light1,
                onChanged: (bool value) {
                  setState(() {
                    light1 = value;
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
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value;
                          });
                        },
                      ),
                      Text('Pix'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value;
                          });
                        },
                      ),
                      Text('Boleto'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value;
                          });
                        },
                      ),
                      Text('Dinheiro'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value;
                          });
                        },
                      ),
                      Text('Crédito'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value;
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
                child: CustomButton(label: 'Avançar', onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
