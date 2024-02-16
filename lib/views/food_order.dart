// ignore_for_file: must_be_immutable, avoid_unnecessary_containers, library_private_types_in_public_api, file_names

import 'package:delivery/components/nav_bar_customer.dart';
import 'package:delivery/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FoodOrderPage extends StatefulWidget {
  const FoodOrderPage({super.key});

  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  int counter = 0;
  List<CartItemModel> cartItems = [
    CartItemModel("Grilled Salmon", 96, 2, "ic_popular_food_1"),
    CartItemModel("Meat vegetable", 65.08, 5, "ic_popular_food_4"),
    // Agrega otros elementos según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF3a3737),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            "Item Carts",
            style: TextStyle(
                color: Color(0xFF3a3737),
                fontWeight: FontWeight.w600,
                fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          CartIconWithBadge(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  "Your Food Cart",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3a3a3b),
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CartItem(
                  cartItem: CartItemModel(
                      "Grilled Salmon", 96, 2, "ic_popular_food_1")),
              const SizedBox(
                height: 10,
              ),
              CartItem(
                cartItem: CartItemModel(
                    "Meat vegetable", 65.08, 5, "ic_popular_food_4"),
              ),
              const SizedBox(
                height: 10,
              ),
              const PromoCodeWidget(),
              const SizedBox(
                height: 10,
              ),
              TotalCalculationWidget(cartItems: cartItems),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  "Payment Method",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3a3a3b),
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const PaymentMethodWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBarCustomer(),
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding:
              const EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/menus/ic_credit_card.png",
                  width: 50,
                  height: 50,
                ),
              ),
              const Text(
                "Credit/Debit Card",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TotalCalculationWidget extends StatefulWidget {
  final List<CartItemModel> cartItems;

  const TotalCalculationWidget({
    Key? key,
    required this.cartItems,
  }) : super(key: key);

  @override
  _TotalCalculationWidgetState createState() => _TotalCalculationWidgetState();
}

class _TotalCalculationWidgetState extends State<TotalCalculationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFfae3e2).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              for (var item in widget.cartItems)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      item.productName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "\$${item.productPrice}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF3a3a3b),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "\$${calculateTotal()}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF3a3a3b),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotal() {
    return widget.cartItems.fold(0,
        (sum, item) => sum + item.productPrice * item.initialProductQuantity);
  }
}

class CartItemModel {
  final String productName;
  final double productPrice;
  final int initialProductQuantity;
  final String productImage;

  CartItemModel(this.productName, this.productPrice,
      this.initialProductQuantity, this.productImage);
}

class PromoCodeWidget extends StatelessWidget {
  const PromoCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 3, right: 3),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: const Color(0xFFfae3e2).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ]),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
                  borderRadius: BorderRadius.circular(7)),
              fillColor: Colors.white,
              hintText: 'Add Your Promo Code',
              filled: true,
              suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.local_offer,
                    color: Color(0xFFfd2c2c),
                  ),
                  onPressed: () {
                    debugPrint('222');
                  })),
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  final CartItemModel cartItem;

  const CartItem({
    super.key,
    required this.cartItem,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int productQuantity;

  @override
  void initState() {
    super.initState();
    productQuantity = widget.cartItem.initialProductQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding:
              const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Image.asset(
                      "assets/images/popular_foods/${widget.cartItem.productImage}.png",
                      width: 110,
                      height: 100,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              widget.cartItem.productName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF3a3a3b),
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              "\$${widget.cartItem.productPrice}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF3a3a3b),
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red, // Customize the color if needed
                            size: 25,
                          ),
                          onPressed: () {
                            // Handle delete action here
                          },
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerRight,
                    child: AddToCartMenu(
                      productQuantity,
                      onIncrease: () {
                        setState(() {
                          productQuantity++;
                        });
                      },
                      onDecrease: () {
                        if (productQuantity > 1) {
                          setState(() {
                            productQuantity--;
                          });
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CartIconWithBadge extends StatelessWidget {
  int counter = 1;

  CartIconWithBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(
            icon: const Icon(
              Icons.business_center,
              color: Color(0xFF3a3737),
            ),
            onPressed: () {}),
        counter != 0
            ? Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '$counter',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}

class AddToCartMenu extends StatelessWidget {
  int productCounter;
  final Function() onIncrease;
  final Function() onDecrease;

  AddToCartMenu(this.productCounter,
      {super.key, required this.onIncrease, required this.onDecrease});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: onDecrease,
            icon: const Icon(Icons.remove),
            color: Colors.black,
            iconSize: 18,
          ),
          Container(
            width: 50.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: AppColors.turquoise,
              border: Border.all(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Text(
                '$productCounter',
                style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            onPressed: onIncrease,
            icon: const Icon(Icons.add),
            color: AppColors.darker,
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}
