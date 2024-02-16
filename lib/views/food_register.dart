// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:io';
import 'package:delivery/components/items/custom_formfield.dart';
import 'package:delivery/components/nav_bar_owner.dart';
import 'package:delivery/controller/alert_dialog.dart';
import 'package:delivery/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:raised_buttons/raised_buttons.dart';

class FoodRegister extends StatefulWidget {
  const FoodRegister({Key? key}) : super(key: key);

  @override
  _FoodRegisterState createState() => _FoodRegisterState();
}

class _FoodRegisterState extends State<FoodRegister> {
  late XFile sampleImage = XFile('');
  //late final List<XFile> images = [];
  final formKey = GlobalKey<FormState>();
  final TextEditingController productController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController preparationTimeController =
      TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Product"),
        centerTitle: true,
        /*leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF3a3737),
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, ScaleRoute(page: const HomeScreenOwner()));
          },
        ),*/
      ),
      body: enableUpload(),
      bottomNavigationBar: const NavBarOwner(),
    );
  }

  Future getImage() async {
    try {
      var tempImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (tempImage != null) {
        setState(() {
          sampleImage = XFile(tempImage.path);
          print("Hola ${sampleImage.path}");
        });
      }
    } catch (e) {
      showPersonalizedAlert(
          context, "Unexpected error", AlertMessageType.error);
    }
  }

  /*Future<void> getImages() async {
    try {
      final List<XFile> pickedImages = await ImagePicker().pickMultiImage();

      if (pickedImages.isNotEmpty) {
        setState(() {
          images.addAll(pickedImages);
        });
      }
    } catch (e) {
      // Manejar errores aquí
      showPersonalizedAlert(
          context, "Unexpected error", AlertMessageType.error);
    }
  }*/

  Widget enableUpload() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            CustomFormField(
                headingText: "Product",
                hintText: "Example: soup chicken",
                obsecureText: false,
                suffixIcon: const Icon(Icons.food_bank_rounded),
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.done,
                controller: productController,
                maxLines: 1),
            const SizedBox(height: 16.0),
            CustomFormField(
                headingText: "Quantity",
                hintText: "Example: 12",
                obsecureText: false,
                suffixIcon: const Icon(Icons.unfold_more_double_sharp),
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
                controller: quantityController,
                maxLines: 1),
            const SizedBox(height: 16.0),
            CustomFormField(
                headingText: "Price",
                hintText: "Example: 12000",
                obsecureText: false,
                suffixIcon: const Icon(Icons.monetization_on_outlined),
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
                controller: priceController,
                maxLines: 1),
            const SizedBox(height: 16.0),
            CustomFormField(
                headingText: "Category",
                hintText: "Example: Fast food",
                obsecureText: false,
                suffixIcon: const Icon(Icons.category_rounded),
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: categoryController,
                maxLines: 1),
            const SizedBox(height: 16.0),
            CustomFormField(
                headingText: "Preparation time",
                hintText: "Example: 30 minuts",
                obsecureText: false,
                suffixIcon: const Icon(Icons.timelapse_outlined),
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: preparationTimeController,
                maxLines: 1),
            const SizedBox(height: 16.0),
            CustomFormField(
                headingText: "Description",
                hintText: "Example: Prepare with meal and salad the apples",
                obsecureText: false,
                suffixIcon: const Icon(Icons.description),
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: descriptionController,
                maxLines: 10),
            const SizedBox(height: 16.0),
            const Text("Add image your product"),
            /*Wrap(
              children: [
                ...images.map((e) => Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.file(
                        File(e.path),
                        height: 90,
                        width: 100,
                      ),
                    ))
              ],
            ),*/

            if (sampleImage.path.isNotEmpty)
              Image.file(
                File(sampleImage.path),
                height: 300,
                width: 600,
              ),
            const SizedBox(height: 16.0),
            IconButton(
                onPressed: () {
                  getImage();
                },
                icon: const Icon(Icons.add_a_photo)),
            const SizedBox(height: 16.0),
            RaisedButtons(
              GlobalKey<FormState>(),
              text: "Guardar",
              onPressed: () {
                validateAndSave();
                //Navigator.pop(context);
                setState(() {
                  productController.clear();
                  quantityController.clear();
                  descriptionController.clear();
                  priceController.clear();
                  categoryController.clear();
                  preparationTimeController.clear();
                  sampleImage = XFile('');
                });
              },
              fontSize: 18,
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }

  void validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      ProductController().registerProduct(
          context,
          productController.text,
          quantityController.text,
          priceController.text,
          categoryController.text,
          preparationTimeController.text,
          descriptionController.text,
          sampleImage);
    } else {
      showPersonalizedAlert(context, "Expected error", AlertMessageType.error);
    }
  }
}
