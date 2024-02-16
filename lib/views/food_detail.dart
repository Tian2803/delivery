// ignore_for_file: file_names, sort_child_properties_last, must_be_immutable, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:delivery/components/animation/ScaleRoute.dart';
import 'package:delivery/model/product.dart';
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
              Navigator.push(context, ScaleRoute(page: const HomeScreenCustomer()));
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.business_center,
                  color: Color(0xFF3a3737),
                ),
                onPressed: () {
                  
                  /*Navigator.push(
                      context, ScaleRoute(page: const FoodOrderPage()));*/
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
                FoodTitleWidget(
                    productName: widget.product.productName,
                    productPrice: '\$${widget.product.productPrice.toString()}',
                    productHost: widget.product.category),
                const SizedBox(
                  height: 15,
                ),
                AddToCartMenu(
                  data: widget.product,
                  selectedQuantity: selectedQuantity,
                  onIncrease: () {
                    setState(() {
                      selectedQuantity++;
                    });
                  },
                  onDecrease: () {
                    if (selectedQuantity > 1) {
                      setState(() {
                        selectedQuantity--;
                      });
                    }
                  },
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
                    ], // list of tabs
                  ),
                ),
                Container(
                  height: 150,
                  child: TabBarView(
                    children: [
                      Container(
                        color: Colors.white24,
                        child: const DetailContentMenu(),
                      ),
                      Container(
                        color: Colors.white24,
                        child: const DetailContentMenu(),
                      ), // class name
                    ],
                  ),
                ),
                const BottomMenu(),
              ],
            ),
          ),
        ),
        //bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}

class FoodTitleWidget extends StatelessWidget {
  String productName;
  String productPrice;
  String productHost;

  FoodTitleWidget({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productHost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              productName,
              style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              productPrice,
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
              productHost,
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1f1f1f),
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: const Row(
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
    );
  }
}

class AddToCartMenu extends StatelessWidget {
  final int selectedQuantity;
  final Function() onIncrease;
  final Function() onDecrease;
  final data;

  const AddToCartMenu(
      {super.key,
      required this.selectedQuantity,
      required this.onIncrease,
      required this.onDecrease,
      this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: onDecrease,
            icon: const Icon(Icons.remove),
            color: Colors.black,
            iconSize: 30,
          ),
          InkWell(
            onTap: () {
              //Navigator.push(context, ScaleRoute(page: const FoodOrderPage()));
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
            onPressed: onIncrease,
            icon: const Icon(Icons.add),
            color: const Color(0xFFfd2c2c),
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}

class DetailContentMenu extends StatelessWidget {
  const DetailContentMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero\'s De Finibus Bonorum et Malorum for use in a type specimen book.',
      style: TextStyle(
          fontSize: 14.0,
          color: Colors.black87,
          fontWeight: FontWeight.w400,
          height: 1.50),
      textAlign: TextAlign.justify,
    );
  }
}
