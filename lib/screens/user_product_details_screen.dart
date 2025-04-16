import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/components/product_state_badge.dart';

class UserProductDetailsScreen extends StatelessWidget {
  const UserProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;

    final isActive = false;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: productId,
                child: CarouselView.weighted(
                  padding: EdgeInsets.all(0),
                  flexWeights: [10],
                  itemSnapping: true, // Suavidade da transição entre as imagens
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  onTap:
                      (index) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => Scaffold(
                                appBar: AppBar(),
                                body: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: SizedBox.expand(
                                    child: Image.network(images[2]),
                                  ),
                                ),
                              ),
                        ),
                      ),
                  children:
                      images.map((image) {
                        return Image.network(image, fit: BoxFit.cover);
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
                                  'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('Maria Gomes', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ProductStateBadge(isNew: true),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bicicleta',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'R\$ ',
                                children: [
                                  TextSpan(
                                    text: '1.200',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blueLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
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
                            Text('Sim'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Meios de pagamento: ',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\u2022 Pix',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              '\u2022 Boleto',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              '\u2022 Crédito',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isActive)
                          CustomButton(
                            icon: Icon(PhosphorIconsRegular.power),
                            label: 'Desativar Anúncio',
                            variant: Variant.muted,
                            onPressed: () {},
                          ),
                        if (!isActive)
                          CustomButton(
                            icon: Icon(PhosphorIconsRegular.power),
                            label: 'Ativar',
                            onPressed: () {},
                          ),
                        CustomButton(
                          icon: Icon(PhosphorIconsRegular.trash),
                          label: 'Excluir Anúncio',
                          variant: Variant.danger,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

final List<String> images = [
  'https://plus.unsplash.com/premium_photo-1678718713393-2b88cde9605b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

  'https://images.unsplash.com/photo-1485965120184-e220f721d03e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

  'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?q=80&w=2030&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

  'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

  'https://plus.unsplash.com/premium_photo-1682125177822-63c27a3830ea?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
];
