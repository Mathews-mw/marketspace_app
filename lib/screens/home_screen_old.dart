import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/components/custom_app_bar.dart';
import 'package:marketsapce_app/components/custom_text_field.dart';
import 'package:marketsapce_app/components/home_components/filters.dart';
import 'package:marketsapce_app/components/home_components/top_card.dart';
import 'package:marketsapce_app/components/home_components/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScreenIndex = 0;

  // _handleShowFilterBottomSheet(BuildContext ctx) {
  //   return showModalBottomSheet(
  //     context: ctx,
  //     isScrollControlled: true,
  //     useSafeArea: true,
  //     builder: (context) {
  //       return DraggableScrollableSheet(
  //         initialChildSize: 0.65,
  //         maxChildSize: 0.9,
  //         expand: false, // Impede que ocupe todo o espaço imediatamente
  //         builder: (context, scrollController) {
  //           return Filters(scrollController: scrollController);
  //         },
  //       );
  //     },
  //   );
  // }

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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.gray100,
        appBar: CustomAppBar(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seus produtos anunciados para venda',
                style: TextStyle(fontSize: 16, color: AppColors.gray600),
              ),
              const SizedBox(height: 10),
              TopCard(),
              const SizedBox(height: 20),
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
                      textInputAction: TextInputAction.search,
                      suffixIcon: Icon(PhosphorIconsRegular.magnifyingGlass),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () => _handleShowFilterBottomSheet(context),
                    icon: Icon(PhosphorIconsRegular.funnel),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: productList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      id: productList[index].id,
                      name: productList[index].name,
                      price: productList[index].price,
                      owner: productList[index].owner,
                      ownerImageUrl: productList[index].ownerImageUrl,
                      isNew: productList[index].isNew,
                      imageUrl: productList[index].imageUrl,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          selectedIndex: _currentScreenIndex,
          onDestinationSelected: (index) {
            setState(() => _currentScreenIndex = index);
          },
          destinations: [
            NavigationDestination(
              icon: Icon(PhosphorIconsFill.house),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(PhosphorIconsFill.tag),
              label: 'Meus anúncios',
            ),
          ],
        ),
      ),
    );
  }
}

final List<ProductItem> productList = [
  ProductItem(
    id: '1',
    name: 'Bicicleta Cross',
    price: 'R\$ 1500,00',
    owner: 'Bernard Stanley',
    ownerImageUrl:
        'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    imageUrl:
        'https://plus.unsplash.com/premium_photo-1678718713393-2b88cde9605b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '2',
    name: 'Bicicleta Street',
    price: 'R\$ 1200,00',
    owner: 'Bernard Stanley',
    ownerImageUrl:
        'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    imageUrl:
        'https://images.unsplash.com/photo-1485965120184-e220f721d03e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '3',
    name: 'Camisa 705 - Preta',
    price: 'R\$ 59,00',
    owner: 'Gavin Ryan',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    imageUrl:
        'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?q=80&w=2030&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '4',
    name: 'Tênis Nike',
    price: 'R\$ 500,00',
    owner: 'Gavin Ryan',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '5',
    name: 'Tênis All Star',
    price: 'R\$ 249,99',
    owner: 'Gavin Ryan',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: false,
    imageUrl:
        'https://plus.unsplash.com/premium_photo-1682125177822-63c27a3830ea?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '6',
    name: 'IPhone X',
    price: 'R\$ 999,99',
    owner: 'Violet Riley',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    imageUrl:
        'https://plus.unsplash.com/premium_photo-1680985551009-05107cd2752c?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '7',
    name: 'Pixel Phone',
    price: 'R\$ 799,99',
    owner: 'Violet Riley',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: false,
    imageUrl:
        'https://images.unsplash.com/photo-1598327105666-5b89351aff97?q=80&w=2118&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '8',
    name: 'Mac Book Air',
    price: 'R\$ 800,00',
    owner: 'Maud Johnson',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: false,
    imageUrl:
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '9',
    name: 'Bateria Acústica',
    price: 'R\$ 2200,00',
    owner: 'Chris Mack',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1543610892-0b1f7e6d8ac1?q=80&w=1856&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: false,
    imageUrl:
        'https://images.unsplash.com/photo-1524230659092-07f99a75c013?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  ProductItem(
    id: '10',
    name: 'Guitarra Les Paul',
    price: 'R\$ 1900,00',
    owner: 'Hilda Payne',
    ownerImageUrl:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isNew: true,
    imageUrl:
        'https://images.unsplash.com/photo-1508186736123-44a5fcb36f9f?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
];

class ProductItem {
  String id;
  String name;
  String price;
  String owner;
  String ownerImageUrl;
  bool isNew;
  String imageUrl;

  ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.owner,
    required this.ownerImageUrl,
    required this.isNew,
    required this.imageUrl,
  });
}
