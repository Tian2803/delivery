// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/controller/alert_dialog.dart';
import 'package:delivery/controller/aux_controller.dart';
import 'package:delivery/model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class ProductController {
  void registerProduct(
    BuildContext context,
    String productName,
    String productQuantity,
    String productPrice,
    String productCategory,
    String productPreparationTime,
    String productDescription,
    XFile image, // Include imageUrl parameter
  ) async {
    try {
      if (productName.isEmpty ||
          productQuantity.isEmpty ||
          productPrice.isEmpty ||
          productCategory.isEmpty ||
          productPreparationTime.isEmpty ||
          productDescription.isEmpty) {
        showPersonalizedAlert(context, 'Por favor, llene todos los campos',
            AlertMessageType.warning);
        return;
      }

      // Mostrar indicador de carga
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Guardando producto..."),
              ],
            ),
          );
        },
      );

      final uid = FirebaseAuth.instance.currentUser!.uid;

      String productId = AuxController().generateId();

      String extension =
          image.path.split('.').last; // Obtener la extensión del archivo
      String fileName =
          "${productId}_${DateTime.now().millisecondsSinceEpoch}.$extension";

      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('productImages')
          .child(fileName);

      await reference.putFile(File(image.path));
      String downloadURL = await reference.getDownloadURL();
      print("Imagen subida con éxito. URL: $downloadURL");

      Product product = Product(
          productName: productName,
          productPrice: double.parse(productPrice),
          productImage: downloadURL,
          productQuantity: int.parse(productQuantity),
          description: productDescription,
          category: productCategory,
          preparationTime: productPreparationTime,
          productId: productId,
          userId: uid);

      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set(product.toJson());

      // Cerrar el indicador de carga
      Navigator.of(context).pop();

      showPersonalizedAlert(
          context, "Registro exitoso", AlertMessageType.success);
    } catch (e) {
      // Cerrar el indicador de carga
      Navigator.of(context).pop();
      showPersonalizedAlert(
          context, 'Error al registrar la Food', AlertMessageType.error);
    }
  }

  Future<List<Product>> getProductDetails(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Realiza la consulta a Firebase Firestore
      QuerySnapshot snapshot = await firestore
          .collection('products')
          .where('userId', isEqualTo: userId)
          .get();

      // Inicializa una lista para almacenar los productos
      List<Product> products = [];
      // Recorre los documentos y crea instancias de la clase Producto
      for (var doc in snapshot.docs) {
        products.add(Product(
          productName: doc['productName'],
          productPrice: doc['productPrice'],
          productImage: doc['productImage'],
          productQuantity: doc['productQuantity'],
          description: doc['description'],
          category: doc['category'],
          preparationTime: doc['preparationTime'],
          productId: doc['productId'],
          userId: doc['userId'],
        ));
      }

      // Devuelve la lista de productos
      return products;
    } catch (e) {
      // Maneja errores de forma adecuada
      throw Exception('No se pudo obtener la información de los productos.');
    }
  }

  Future<void> updateProduct(
      Product product, XFile image, BuildContext context) async {
    try {
      String downloadURL = product.productImage;
      deleteImageProduct(downloadURL);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Actualizando producto..."),
              ],
            ),
          );
        },
      );

      if (image.path.isNotEmpty) {
        print("Hola ${image.path}");

        String extension = image.path.split('.').last;
        String fileName =
            "${product.productId}_${DateTime.now().millisecondsSinceEpoch}.$extension";

        firebase_storage.Reference reference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('productImages')
            .child(fileName);

        await reference.putFile(File(image.path));
        downloadURL = await reference.getDownloadURL();
        print("Imagen subida con éxito. URL: $downloadURL");
      }

      // Obtén una referencia al documento del producto en Firestore
      DocumentReference productRef = FirebaseFirestore.instance
          .collection('products')
          .doc(product.productId);

      // Actualiza los campos del producto en Firestore
      await productRef.update({
        'productName': product.productName,
        'productQuantity': product.productQuantity,
        'description': product.description,
        'productPrice': product.productPrice,
        'category': product.category,
        'productImage': downloadURL,
        'preparationTime': product.preparationTime,
      });
      Navigator.of(context).pop();
      print("Producto actualizado con éxito");
      showPersonalizedAlert(
          context, "Actualizacion exitosa", AlertMessageType.success);
    } catch (error) {
      Navigator.of(context).pop();
      print("Error al actualizar el producto: $error");
      showPersonalizedAlert(
          context, "Actualizacion fallida", AlertMessageType.error);
    }
  }

  //En uso
  Future<Product> getProduct(String productId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productId', isEqualTo: productId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Map the data to a Food object
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        Product product = Product(
          productName: data['productName'],
          productPrice: data['productPrice'],
          productImage: data['productImage'],
          productQuantity: data['productQuantity'],
          description: data['description'],
          category: data['category'],
          preparationTime: data['preparationTime'],
          productId: data['productId'],
          userId: data['userId'],
        );

        return product;
      } else {
        // No se encontró la comida con el ID proporcionado
        throw Exception('No se encontró la comida');
      }
    } catch (e) {
      throw Exception('No se pudo obtener la comida.');
    }
  }

//En uso
  Future<List<Product>> getProductsDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Realiza la consulta a Firebase Firestore
      QuerySnapshot snapshot = await firestore.collection('products').get();

      // Inicializa una lista para almacenar los productos
      List<Product> products = [];
      // Recorre los documentos y crea instancias de la clase Producto
      for (var doc in snapshot.docs) {
        products.add(Product(
          productName: doc['productName'],
          productPrice: doc['productPrice'],
          productImage: doc['productImage'],
          productQuantity: doc['productQuantity'],
          description: doc['description'],
          category: doc['category'],
          preparationTime: doc['preparationTime'],
          productId: doc['productId'],
          userId: doc['userId'],
        ));
      }

      // Devuelve la lista de productos
      return products;
    } catch (e) {
      // Maneja errores de forma adecuada
      throw Exception('No se pudo obtener la información de los productos.');
    }
  }

  void deleteProduct(Product product) {
    DocumentReference productRef = FirebaseFirestore.instance
        .collection('products')
        .doc(product.productId);

    productRef.delete().then((doc) {
      print("Producto eliminado correctamente");
      deleteImageProduct(product.productImage);
      print(product.productImage);
    }).catchError((error) {
      print('Error al eliminar el producto: $error');
    });
  }

  void deleteImageProduct(String imageUrl) {
    try {
      // Referencia al almacenamiento de Firebase
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instanceFor(bucket: 'productImages')
              .refFromURL(imageUrl);
      // Eliminar la imagen
      reference.delete();
      print("Imagen eliminada correctamente");
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }

  Future<String> getProductName(String productId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (userDoc.exists) {
        final product = userDoc.data()?['productName'];
        return product as String;
      } else {
        return "No existe";
      }
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del producto.');
    }
  }
}
