// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/controller/alert_dialog.dart';
import 'package:delivery/controller/aux_controller.dart';
import 'package:delivery/controller/owner_controller.dart';
import 'package:delivery/model/detail_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailPaymentController {
  void detailRegister(BuildContext context, List<Map<String, dynamic>> products, String pay, String state) async {
    try {
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

      print('Pago exitoso');
      products.clear();
    } catch (e) {
      showPersonalizedAlert(
          context, 'Error al registrar el pago', AlertMessageType.error);
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

  //Historial
  Future<List<DetailPayment>> getDetailPaymentUser(String id) async {
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
            .where('state', isNotEqualTo: 'delivered')
            .get();

        // Recorre los documentos y crea instancias de la clase DetallePago
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          // Obtener el nombre del producto
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
            .where('state', isNotEqualTo: 'delivered')
            .get();

        // Recorre los documentos y crea instancias de la clase DetallePago
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          // Obtener el nombre del producto

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
}
