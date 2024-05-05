// ignore_for_file: use_key_in_widget_constructors
import 'package:delivery/components/items/historial_item.dart';
import 'package:delivery/controller/detail_payment_controller.dart';
import 'package:delivery/model/detail_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistorialView extends StatelessWidget {
  HistorialView();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // Add any other app bar customization as needed
      ),
      body: FutureBuilder<List<DetailPayment>>(
        future: DetailPaymentController().getDetailPaymentDelivered(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Transform.scale(
                scale: 0.7,
                child: const CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Obtener la lista de detalles
            List<DetailPayment>? detail = snapshot.data;

            // Ordenar la lista por fecha en orden descendente
            detail?.sort((a, b) => b.date.compareTo(a.date));

            if (detail != null && detail.isNotEmpty) {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: detail.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                          height:
                              10); // Espacio de 10 de alto entre cada tarjeta
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return HistorialFoodItem(food: detail[index]);
                    },
                  ),
                ),
              );
            } else {
              return const Text("Realice la compra de un producto");
            }
          }
        },
      ),
    );
  }
}
