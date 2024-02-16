import 'package:delivery/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FavoriteBox extends StatelessWidget {
  const FavoriteBox(
      {super.key,
      this.padding = 5,
      this.iconSize = 18,
      this.isFavorited = false,
      this.onTap});

  final double padding;
  final double iconSize;
  final bool isFavorited;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: const BoxDecoration(
            color: AppColors.primary, shape: BoxShape.circle),
        child: Icon(
          isFavorited ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
