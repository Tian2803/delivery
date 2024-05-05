// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/controller/alert_dialog.dart';
import 'package:delivery/controller/aux_controller.dart';
import 'package:delivery/controller/owner_controller.dart';
import 'package:delivery/model/detail_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailPaymentController {
  Future<bool> detailRegister(BuildContext context,
      List<Map<String, dynamic>> products, String pay, String state) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Procesando orden..."),
              ],
            ),
          );
        },
      );
      String detailPaymentId = AuxController().generateId();

      final customerId = FirebaseAuth.instance.currentUser!.uid;

      DetailPayment detailPayment = DetailPayment(
          detailPaymentId: detailPaymentId,
          products: products,
          customerId: customerId,
          pay: pay,
          date: AuxController().getFechaActual(),
          state: state);

      await FirebaseFirestore.instance
          .collection('detailPayment')
          .doc(detailPaymentId)
          .set(detailPayment.toJson());
      Navigator.of(context).pop();
      return true;
      print('Pago exitoso');
      showPersonalizedAlert(
          context, "Compra exitosa", AlertMessageType.success);
    } catch (e) {
      Navigator.of(context).pop();
      showPersonalizedAlert(
          context, 'Error al registrar el pago', AlertMessageType.error);
      return false;
    }
  }

  Future<DetailPayment> getDetailPayment(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Realiza la consulta a Firebase Firestore
      DocumentSnapshot snapshot =
          await firestore.collection('detailPayment').doc(id).get();

      // Devuelve una instancia de la clase DetallePago
      return DetailPayment(
          detailPaymentId: snapshot['detailPaymentId'],
          products: snapshot['products'],
          customerId: snapshot['customerId'],
          pay: snapshot['pay'],
          date: snapshot['date'],
          state: snapshot['state']);
    } catch (e) {
      // Maneja errores de forma adecuada
      print(
          'Error, no se logró obtener la información del detalle de pago: $e');
      throw Exception('No se pudo obtener la información del detalle de pago.');
    }
  }

  //Mostrar el Historial delivered
  Future<List<DetailPayment>> getDetailPaymentDelivered(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      String? ownerId = await OwnerController().getOwnerId();
      // Initialize a list to store the detail payments
      List<DetailPayment> detailPayments = [];

      if (id != ownerId) {
        // Query Firestore
        QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
            .collection('detailPayment')
            .where('customerId', isEqualTo: id)
            .where('state', whereIn: ['Delivered', 'Cancelled']).get();

        // Iterate through documents and create DetailPayment instances
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          // Extract product data from the document
          List<Map<String, dynamic>> productsData =
              List<Map<String, dynamic>>.from(doc['products']);

          // Create a DetailPayment instance and add it to the list
          detailPayments.add(DetailPayment(
            detailPaymentId: doc['detailPaymentId'],
            products: productsData,
            customerId: doc['customerId'],
            pay: doc['pay'],
            date: doc['date'],
            state: doc['state'],
          ));
        }
      } else {
        // Query Firestore
        QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
            .collection('detailPayment')
            .where('state', whereIn: ['Delivered', 'Cancelled']).get();

        for (QueryDocumentSnapshot doc in snapshot.docs) {
          // Extract product data from the document
          List<Map<String, dynamic>> productsData =
              List<Map<String, dynamic>>.from(doc['products']);

          // Iterate through product data to find matches with the given ID
          for (var productData in productsData) {
            if (productData['ownerId'] == id) {
              // Create a DetailPayment instance and add it to the list
              detailPayments.add(DetailPayment(
                detailPaymentId: doc['detailPaymentId'],
                products: productsData,
                customerId: doc['customerId'],
                pay: doc['pay'],
                date: doc['date'],
                state: doc['state'],
              ));
              // Exit the loop once a match is found
              break;
            }
          }
        }
      }
      // Return the list of detail payments
      return detailPayments;
    } catch (e) {
      // Handle errors properly
      print('Error, could not fetch detail payment information: $e');
      throw Exception('Could not retrieve detail payment information.');
    }
  }

  //Mostrar las ordenes activas
  Future<List<DetailPayment>> getDetailPaymentProcesing(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      String? ownerId = await OwnerController().getOwnerId();
      // Initialize a list to store the detail payments
      List<DetailPayment> detailPayments = [];

      if (id != ownerId) {
        // Query Firestore
        QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
            .collection('detailPayment')
            .where('customerId', isEqualTo: id)
            .where('state', isEqualTo: 'Procesing')
            .get();

        // Iterate through documents and create DetailPayment instances
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          // Extract product data from the document
          List<Map<String, dynamic>> productsData =
              List<Map<String, dynamic>>.from(doc['products']);

          // Create a DetailPayment instance and add it to the list
          detailPayments.add(DetailPayment(
            detailPaymentId: doc['detailPaymentId'],
            products: productsData,
            customerId: doc['customerId'],
            pay: doc['pay'],
            date: doc['date'],
            state: doc['state'],
          ));
        }
      } else {
        // Query Firestore
        QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
            .collection('detailPayment')
            .where('state', isEqualTo: 'Procesing')
            .get();

        for (QueryDocumentSnapshot doc in snapshot.docs) {
          // Extract product data from the document
          List<Map<String, dynamic>> productsData =
              List<Map<String, dynamic>>.from(doc['products']);

          // Iterate through product data to find matches with the given ID
          for (var productData in productsData) {
            if (productData['ownerId'] == id) {
              // Create a DetailPayment instance and add it to the list
              detailPayments.add(DetailPayment(
                detailPaymentId: doc['detailPaymentId'],
                products: productsData,
                customerId: doc['customerId'],
                pay: doc['pay'],
                date: doc['date'],
                state: doc['state'],
              ));
              // Exit the loop once a match is found
              break;
            }
          }
        }
      }
      // Return the list of detail payments
      return detailPayments;
    } catch (e) {
      // Handle errors properly
      print('Error, could not fetch detail payment information: $e');
      throw Exception('Could not retrieve detail payment information.');
    }
  }

  //No sirve
  Future<List<DetailPayment>> getDetailPaymentState(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      String? ownerId = await OwnerController().getOwnerId();
      // Inicializa una lista para almacenar los detalles de pago
      List<DetailPayment> detailPayment = [];

      if (id != ownerId) {
        // Realiza la consulta a Firebase Firestore
        QuerySnapshot snapshot = await firestore
            .collection('detailPayment')
            .where('customerId', isEqualTo: id)
            .where('state', isEqualTo: 'Procesing')
            .get();

        // Recorre los documentos y crea instancias de la clase DetallePago
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          detailPayment.add(DetailPayment(
              detailPaymentId: doc['detailPaymentId'],
              products: doc['products'],
              customerId: doc['customerId'],
              pay: doc['pay'],
              date: doc['date'],
              state: doc['state']));
        }
      } else {
        // Realiza la consulta a Firebase Firestore
        QuerySnapshot snapshot = await firestore
            .collection('detailPayment')
            .where('ownerId', isEqualTo: id)
            .where('state', isEqualTo: 'Procesing')
            .get();

        // Recorre los documentos y crea instancias de la clase DetallePago
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          detailPayment.add(DetailPayment(
              detailPaymentId: doc['detailPaymentId'],
              products: doc['products'],
              customerId: doc['customerId'],
              pay: doc['pay'],
              date: doc['date'],
              state: doc['state']));
        }
      }

      // Devuelve la lista de detalles de pago
      return detailPayment;
    } catch (e) {
      // Maneja errores de forma adecuada
      print(
          'Error, no se logró obtener la información de los detalles de pago: $e');
      throw Exception(
          'No se pudo obtener la información de los detalles de pago.');
    }
  }

  Future<void> updateStatus(
      String status, String uidPayment, BuildContext context) async {
    print(uidPayment);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Actualizando estado..."),
            ],
          ),
        );
      },
    );
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('detailPayment').doc(uidPayment);
    await productRef.update({
      'state': status,
    });
    Navigator.of(context).pop();
    showPersonalizedAlert(
        context, "Estado actualizado exitosamente", AlertMessageType.success);
  }
}
