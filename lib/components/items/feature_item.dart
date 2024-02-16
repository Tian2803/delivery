// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:delivery/components/animation/ScaleRoute.dart';
import 'package:delivery/components/items/custom_image.dart';
import 'package:delivery/model/product.dart';
import 'package:delivery/styles/app_colors.dart';
import 'package:delivery/views/food_detail.dart';
import 'package:flutter/material.dart';

import 'favorite_box.dart';

class FeaturedItem extends StatelessWidget {
  const FeaturedItem({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(context, ScaleRoute(page: FoodDetailsPage(product: product)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImage(
              product.productImage,
              width: 60,
              height: 60,
              radius: 10,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildItemInfo(),
            ),
            _buildItemPrice(),
          ],
        ),
      ),
    );
  }

  _buildItemPrice() {
    return Column(
      children: <Widget>[
        Text(
          product.productPrice.toString(),
          maxLines: 1,
          //overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary),
        ),
        const SizedBox(
          height: 10,
        ),
        const FavoriteBox(
          iconSize: 13,
          isFavorited: false,
        )
      ],
    );
  }

  _buildItemInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          product.preparationTime,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(
          height: 4,
        ),
        /*Row(
          children: [
            const Icon(
              Icons.star_rounded,
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              data["rate"] + " (" + data["rate_number"] + ")",
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
            ),
          ],
        )*/
      ],
    );
  }
}
