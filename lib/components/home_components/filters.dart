import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/theme/app_colors.dart';

class Filters extends StatefulWidget {
  // final ScrollController scrollController;

  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  bool? isChecked = true;
  bool light1 = true;

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // controller: widget.scrollController,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 20,
          left: 32,
          right: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray400,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                height: 4,
                width: 80,
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            Text(
              'Filtrar Anúncios',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text('Condição', style: Theme.of(context).textTheme.labelLarge),
            Row(
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
                    Text('Novo'),
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
                    Text('Usado'),
                  ],
                ),
              ],
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  label: 'Limpar filtros',
                  variant: Variant.muted,
                  onPressed: () {},
                ),
                CustomButton(
                  label: 'Aplicar filtros',
                  variant: Variant.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
