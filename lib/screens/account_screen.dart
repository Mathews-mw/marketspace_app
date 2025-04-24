import 'package:flutter/material.dart';
import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/components/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/providers/users_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isLoading = false;

  Future<void> signOut() async {
    setState(() => _isLoading = true);

    try {
      // await Future.delayed(Duration(seconds: 4));
      Provider.of<UsersProvider>(context, listen: false).logout();
    } catch (error) {
      print('Erro ao tentar sair da aplicação: $error');
    } finally {
      setState(() => _isLoading = false);
    }

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  Future<void> _signOutDialog() async {
    await showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: AppColors.gray100,
            title: Text('Sair do app'),
            content: Text(
              'Certeza que deseja encerrar sua sessão atual do aplicativo?',
            ),
            actions: [
              TextButton(
                child: const Text('NÃO'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('SAIR'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await signOut();
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UsersProvider>(context, listen: false).user;

    return Scaffold(
      backgroundColor: AppColors.gray100,
      extendBody: _isLoading,
      appBar:
          _isLoading
              ? null
              : AppBar(title: Text('Sua conta'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Skeletonizer(
                      enabled: user == null,
                      ignoreContainers: true,
                      effect: ShimmerEffect(
                        baseColor: Colors.black12,
                        highlightColor: AppColors.gray200,
                        duration: Duration(milliseconds: 1500),
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundImage: CachedNetworkImageProvider(
                          user!.avatar ??
                              'https://api.dicebear.com/9.x/thumbs/png?seed=${user.name}',
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Anúncios',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          '8',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Vendas',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          '4',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Compras',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          '2',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Gerenciar conta',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                Card.outlined(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(PhosphorIconsBold.userGear),
                        title: const Text('Editar perfil'),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIconsRegular.caretRight),
                        ),
                      ),
                      ListTile(
                        leading: Icon(PhosphorIconsBold.shield),
                        title: const Text('Senha e segurança'),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIconsRegular.caretRight),
                        ),
                      ),
                      ListTile(
                        leading: Icon(PhosphorIconsBold.signOut),
                        title: const Text('Sair da conta'),
                        trailing: IconButton(
                          onPressed: _signOutDialog,
                          icon: Icon(PhosphorIconsRegular.caretRight),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) LoadingOverlay(message: 'Saindo...'),
        ],
      ),
    );
  }
}
