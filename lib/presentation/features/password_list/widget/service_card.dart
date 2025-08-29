import 'package:flutter/material.dart';

import '../../../themes/sizes.dart';

class ServiceCard extends StatelessWidget {

  final String serviceName;
  final bool isFavorite;
  final String serviceIconURL; //api FavIcon генерит ссылку на лого по назавнию сайта
  final VoidCallback onFavoriteIconTap;

  const ServiceCard({
    required this.serviceName,
    required this.isFavorite,
    required this.serviceIconURL,
    super.key, required this.onFavoriteIconTap
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return GestureDetector(
      onTap:
          () =>
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
              SnackBar(content: Text("Тапнуто на сервис $serviceName"))),
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
                Image(image: NetworkImage(serviceIconURL),
                  width: Sizes.iconSizeLg,
                  height: Sizes.iconSizeLg,
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
