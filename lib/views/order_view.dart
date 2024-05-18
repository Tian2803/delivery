// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:delivery/components/items/custom_image.dart';
import 'package:delivery/components/items/historial_detail_item.dart';
import 'package:delivery/controller/detail_payment_controller.dart';
import 'package:delivery/model/detail_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  late Future<List<DetailPayment>> _detailPaymentFuture;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadDetailPayment();
  }

  void _loadDetailPayment() {
    setState(() {
      _detailPaymentFuture =
          DetailPaymentController().getDetailPaymentProcesing(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // Add any other app bar customization as needed
      ),
      body: FutureBuilder<List<DetailPayment>>(
        future: _detailPaymentFuture,
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      final food = detail[index];
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistorialDetailItem(
                                products: food.products,
                                title: 'Detalle de la compra',
                                detailPaymentId: food.detailPaymentId,
                              ),
                            ),
                          );
                          _loadDetailPayment(); // Vuelve a cargar los datos después de regresar
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomImage(
                                  food.products[0]['imageUrl'],
                                  width: double.infinity,
                                  height: double.infinity,
                                  radius: 10,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.products[0]['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Text(
                                            'Total: ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '\$${food.pay}',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Text(
                                            'Estado: ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            food.state,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Text(
                                            'Fecha: ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            food.date,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HistorialDetailItem(
                                        products: food.products,
                                        title: 'Purchase detail',
                                        detailPaymentId: food.detailPaymentId,
                                        active: true,
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    _loadDetailPayment();
                                  }); // Vuelve a cargar los datos después de regresar
                                },
                                icon: const Icon(
                                    Icons.arrow_forward_ios_outlined),
                              ),
                            ],
                          ),
                        ),
                      );
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
