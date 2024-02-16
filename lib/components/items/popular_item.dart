// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:delivery/components/animation/ScaleRoute.dart';
import 'package:delivery/model/product.dart';
import 'package:delivery/styles/app_colors.dart';
import 'package:delivery/views/food_detail.dart';
import 'package:flutter/material.dart';

import 'favorite_box.dart';

class PopularItem extends StatelessWidget {
  const PopularItem({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, ScaleRoute(page: FoodDetailsPage(product: product,)));
        },
        child: Container(
          margin: const EdgeInsets.only(right: 15),
          height: 170,
          width: 220,
          child: Stack(
            children: [
              Positioned(
                top: 10,
                child: _buildItemImage(),
              ),
              const Positioned(
                top: 0,
                right: 5,
                child: FavoriteBox(
                  isFavorited: false,
                ),
              ),
              Positioned(
                top: 140,
                child: _buildItemInfo(),
              )
            ],
          ),
        ));
  }

  _buildItemImage() {
    return Container(
      height: 120,
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(product.productImage),
        ),
      ),
    );
  }

  _buildItemInfo() {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                product.productPrice.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
