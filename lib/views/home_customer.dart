import 'package:delivery/components/SearchWidget.dart';
import 'package:delivery/components/drawer/custom_drawer_customer.dart';
import 'package:delivery/components/items/category_item.dart';
import 'package:delivery/components/items/data.dart';
import 'package:delivery/components/items/feature_item.dart';
import 'package:delivery/components/items/popular_item.dart';
import 'package:delivery/controller/product_controller.dart';
import 'package:delivery/model/product.dart';
import 'package:delivery/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreenCustomer extends StatefulWidget {
  const HomeScreenCustomer({super.key});

  @override
  State<HomeScreenCustomer> createState() => _HomeScreenCustomerState();
}

class _HomeScreenCustomerState extends State<HomeScreenCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "What would you like to eat?",
          style: TextStyle(
              color: Color(0xFF3a3737),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Color(0xFF3a3737),
              ),
              onPressed: () {
                // Navigator.push(context, ScaleRoute(page: const HomeScreenCustomer()));
              })
        ],
      ),
      drawer: const CustomDrawerCustomer(),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchWidget(),
          const SizedBox(
            height: 25,
          ),
          _buildAdsImage(),
          const SizedBox(
            height: 25,
          ),
          _buildCategories(),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular foods",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: AppColors.darker),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          _buildPopulars(),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              "Featured",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _buildFeatured(),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _buildAdsImage() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
          ),
        ),
      ),
    );
  }

  _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      child: Row(
        children: [
          const CategoryItem(
            data: {
              "name": "All",
              "icon": FontAwesomeIcons.th,
            },
            seleted: true,
          ),
          ...List.generate(
            categories.length,
            (index) => CategoryItem(data: categories[index]),
          )
        ],
      ),
    );
  }

  _buildPopulars() {
    return FutureBuilder<List<Product>>(
      future: ProductController()
          .getProductsDetails(), // Asumiendo que hay un método específico para obtener productos populares
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Product> popularProducts = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: List.generate(
                popularProducts.length,
                (index) => PopularItem(
                  product: popularProducts[index],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  _buildFeatured() {
    return FutureBuilder<List<Product>>(
      future: ProductController()
          .getProductsDetails(), // Call the function to get product details
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the data is still loading, display a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there is an error while fetching data, display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // If the data is successfully loaded, pass it to FeaturedItem widget
          List<Product> products = snapshot.data!;
          return Column(
            children: List.generate(
              products.length,
              (index) => FeaturedItem(product: products[index]),
            ),
          );
        }
      },
    );
  }
}
