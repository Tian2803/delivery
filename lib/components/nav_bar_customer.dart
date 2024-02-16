// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:delivery/components/items/bottombar_item.dart';
import 'package:delivery/styles/app_colors.dart';
import 'package:delivery/views/food_order.dart';
import 'package:delivery/views/home_customer.dart';
import 'package:delivery/views/profile_page_customer.dart';
import 'package:flutter/material.dart';

class NavBarCustomer extends StatefulWidget {
  const NavBarCustomer({super.key});

  @override
  _NavBarCustomerState createState() => _NavBarCustomerState();
}

class _NavBarCustomerState extends State<NavBarCustomer> {
  int _activeTab = 0;

  final List<IconData> _tapIcons = [
    Icons.home_rounded,
    Icons.explore_rounded,
    Icons.shopping_cart_rounded,
    Icons.person_rounded
  ];

  final List<Widget> _pages = [
    const HomeScreenCustomer(),
    const HomeScreenCustomer(),
    const FoodOrderPage(),
    const ProfilePageCustomer(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.whiteshade,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: .5,
            spreadRadius: .5,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          _tapIcons.length,
          (index) => BottomBarItem(
            _tapIcons[index],
            isActive: _activeTab == index,
            activeColor: AppColors.primary,
            onTap: () {
              setState(() {
                _activeTab = index;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => _pages[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
