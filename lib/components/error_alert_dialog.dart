import 'package:flutter/material.dart';
import 'package:marketsapce_app/theme/app_colors.dart';

class ErrorAlertDialog {
  static Future<void> showDialogError({
    required BuildContext context,
    required String title,
    required String code,
    required String message,
    String? description,
  }) {
    return showDialog<String>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            backgroundColor: AppColors.gray100,
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Código:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(code, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mensagem:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  if (description != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descrição:',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
