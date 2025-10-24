import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/presentation/features/show_password/show_password.dart';
import 'package:flutter/material.dart';

import '../../../themes/sizes.dart';

class ServiceCard extends StatelessWidget {

  final String serviceName;
  final bool isFavorite;
  final IconData serviceIcon; //api FavIcon генерит ссылку на лого по назавнию сайта
  final VoidCallback onFavoriteIconTap;
  final Password password;
  final VoidCallback? onPasswordDeleted; // Добавляем callback

  const ServiceCard({
    required this.serviceName,
    required this.isFavorite,
    required this.serviceIcon,
    required this.password,
    this.onPasswordDeleted, // Делаем опциональным
    super.key, required this.onFavoriteIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowPasswordScreen(selectedPassword: password),
          ),
        ).then((value) {
          // Этот код выполнится после возвращения с экрана пароля
          onPasswordDeleted?.call();
        });
      },
      child: Container(
        width: double.infinity,
        height: 56,
        margin: EdgeInsets.symmetric(horizontal: Sizes.spacingMd),
        padding: EdgeInsets.fromLTRB(
          Sizes.spacingMd,
          0,
          Sizes.spacingSm,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.background,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  serviceIcon,
                  size: Sizes.iconSizeLg,
                ),
                SizedBox(width: Sizes.spacingSm),
                Text(serviceName),
              ],
            ),
            IconButton(
              onPressed: () {
                onFavoriteIconTap();
              },
              icon: isFavorite? Icon(Icons.favorite, color: colorScheme.error,) : Icon(Icons.favorite_border_outlined),
            ),
          ],
        ),
      ),
    );
  }

}
