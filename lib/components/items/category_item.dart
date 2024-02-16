// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:delivery/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
  Key? key,
  required this.data,
  this.seleted = false,
  this.onTap,
});


  final data;
  final bool seleted;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 10),
        width: 90,
        decoration: BoxDecoration(
          color: seleted ? AppColors.primary : AppColors.cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.05),
              spreadRadius: .5,
              blurRadius: .5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              data["icon"],
              size: 17,
              color: seleted ? Colors.white : AppColors.darker,
            ),
            const SizedBox(width: 7),
            Text(
              data["name"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: seleted ? Colors.white : AppColors.darker,
              ),
            )
          ],
        ),
      ),
    );
  }
}
