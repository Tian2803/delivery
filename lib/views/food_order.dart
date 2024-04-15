// ignore_for_file: must_be_immutable, avoid_unnecessary_containers, library_private_types_in_public_api, file_names, unused_element

import 'package:delivery/components/animation/ScaleRoute.dart';
import 'package:delivery/components/items/custom_button.dart';
import 'package:delivery/components/items/custom_image.dart';
import 'package:delivery/components/nav_bar_customer.dart';
import 'package:delivery/controller/shopping_controller.dart';
import 'package:delivery/styles/app_colors.dart';
import 'package:delivery/views/home_customer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<String> genderItems = ['Efectivo', 'Nequi', 'Daviplata'];
String? selectedValue;

class FoodOrderPage extends StatefulWidget {
  const FoodOrderPage({super.key});

  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  int counter = 0;
  double total = 0;
  @override
  Widget build(BuildContext context) {
    final shoppingCartProvider = Provider.of<ShoppingController>(context);
    final productsPurchased = shoppingCartProvider.listProductsPurchased;
    total = ShoppingController().total(productsPurchased);
    counter = productsPurchased.length;
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
            Navigator.push(
                context, ScaleRoute(page: const HomeScreenCustomer()));
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
          Stack(
            children: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.business_center,
                    color: Colors.amber,
                  ),
                  onPressed: () {}),
              counter != 0
                  ? Positioned(
                      right: 16,
                      top: 16,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$counter',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              productsPurchased.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_shopping_cart,
                            color: AppColors.kPrimaryColor,
                            size: 150,
                          ),
                          Text(
                            'Carrito vacio',
                            style: TextStyle(
                              color: AppColors.kTextTitleColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productsPurchased.length,
                      itemBuilder: (BuildContext context, int index) {
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
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 10, bottom: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Center(
                                        child: CustomImage(
                                          productsPurchased[index].image,
                                          width: 130,
                                          height: 100,
                                          radius: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  productsPurchased[index]
                                                      .product,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xFF3a3a3b),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                child: Text(
                                                  "\$${productsPurchased[index].price}",
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xFF3a3a3b),
                                                      fontWeight:
                                                          FontWeight.w400),
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
                                                color: Colors
                                                    .red, // Customize the color if needed
                                                size: 25,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  productsPurchased.remove(
                                                      productsPurchased[index]);
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              IconButton(
                                                onPressed: () {
                                                  if (productsPurchased[index]
                                                          .quantity >
                                                      1) {
                                                    setState(() {
                                                      productsPurchased[index]
                                                          .quantity--;
                                                    });
                                                  }
                                                  // Actualizar la cantidad del producto aquí si es necesario
                                                },
                                                icon: const Icon(Icons.remove),
                                                color: Colors.black,
                                                iconSize: 18,
                                              ),
                                              Container(
                                                width: 50.0,
                                                height: 30.0,
                                                decoration: BoxDecoration(
                                                  color: AppColors.turquoise,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    productsPurchased[index]
                                                        .quantity
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    productsPurchased[index]
                                                        .quantity++;
                                                  });
                                                  // Actualizar la cantidad del producto aquí si es necesario
                                                },
                                                icon: const Icon(Icons.add),
                                                color: AppColors.darker,
                                                iconSize: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(
                height: 10,
              ),
              const PromoCodeWidget(),
              const SizedBox(
                height: 10,
              ),
              Container(
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
                        for (var item in productsPurchased)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                item.product,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF3a3a3b),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "\$${item.price * item.quantity}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF3a3a3b),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 10,
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
                              "\$$total", // Aquí deberías calcular el total
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
              ),
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
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const PaymentMethodWidget(),
              const SizedBox(height: 10,),
              AuthButton(onTap: () {}, text: "Finalizar Compra")
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBarCustomer(),
    );
  }
}

// Se queda
class PaymentMethodWidget extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const PaymentMethodWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey =
        GlobalKey<FormState>(); // Declare _formKey here

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 110, // Ajusta la altura según sea necesario
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/menus/ic_credit_card.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(
                      width: 20), // Espacio entre la imagen y el dropdown
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              hint: const Text(
                                'Select payment method',
                                style: TextStyle(fontSize: 14),
                              ),
                              items: genderItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select payment method.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                //Do something when selected item is changed.
                              },
                              onSaved: (value) {
                                selectedValue = value.toString();
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 24,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}

//Se queda
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
