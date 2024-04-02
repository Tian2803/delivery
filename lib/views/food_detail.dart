// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:delivery/components/animation/ScaleRoute.dart';
import 'package:delivery/components/nav_bar_customer.dart';
import 'package:delivery/model/product.dart';
import 'package:delivery/views/food_order.dart';
import 'package:delivery/views/home_customer.dart';
import 'package:flutter/material.dart';

class FoodDetailsPage extends StatefulWidget {
  const FoodDetailsPage({super.key, required this.product});
  final Product product;
  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAFAFA),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF3a3737),
            ),
            onPressed: () {
              Navigator.push(
                  context, ScaleRoute(page: const HomeScreenCustomer()));
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.business_center,
                  color: Color(0xFF3a3737),
                ),
                onPressed: () {
                  Navigator.push(
                      context, ScaleRoute(page: const FoodOrderPage()));
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(widget.product.productImage),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  elevation: 1,
                  margin: const EdgeInsets.all(5),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.product.productName,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF3a3a3b),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '\$${widget.product.productPrice.toString()}',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF3a3a3b),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        const Text(
                          "by ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFa9a9a9),
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          widget.product.category,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1f1f1f),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          if (selectedQuantity > 1) {
                            setState(() {
                              selectedQuantity--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                        color: Colors.black,
                        iconSize: 30,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context, ScaleRoute(page: const FoodOrderPage()));
                        },
                        child: Container(
                          width: 200.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFfd2c2c),
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Add x $selectedQuantity',
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedQuantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                        color: const Color(0xFFfd2c2c),
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: TabBar(
                    labelColor: Color(0xFFfd3f40),
                    indicatorColor: Color(0xFFfd3f40),
                    unselectedLabelColor: Color(0xFFa4a1a1),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(
                        text: 'Food Details',
                      ),
                      Tab(
                        text: 'Food Reviews',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: TabBarView(
                    children: [
                      Container(
                        color: Colors.white24,
                        child: const Text(
                          'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero\'s De Finibus Bonorum et Malorum for use in a type specimen book.',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              height: 1.50),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Container(
                        color: Colors.white24,
                        child: const Text(
                          'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero\'s De Finibus Bonorum et Malorum for use in a type specimen book.',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              height: 1.50),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.timelapse,
                            color: Color(0xFF404aff),
                            size: 35,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "12pm-3pm",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFa9a9a9),
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.directions,
                            color: Color(0xFF23c58a),
                            size: 35,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "3.5 km",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFa9a9a9),
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.map,
                            color: Color(0xFFff0654),
                            size: 35,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Map View",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFa9a9a9),
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.directions_bike,
                            color: Color(0xFFe95959),
                            size: 35,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Delivery",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFa9a9a9),
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavBarCustomer(),
      ),
    );
  }
}
