import 'package:delivery/components/items/custom_image.dart';
import 'package:delivery/controller/detail_payment_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistorialDetailItem extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final String title;
  final String detailPaymentId;
  final bool active;

  const HistorialDetailItem(
      {Key? key,
      required this.products,
      required this.title,
      required this.detailPaymentId,
      this.active = false
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    String uid = products[0]['ownerId'];
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (final product in products) ...[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //margin: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImage(
                        product['imageUrl'],
                        width: 90,
                        height: 90,
                        radius: 10,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildItemInfo(product),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
              if (currentUser != null &&
                  currentUser.uid ==
                      uid && active == true) // Verifica si el usuario está autenticado y es el propietario
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        DetailPaymentController().updateStatus(
                            'Delivered', detailPaymentId, context);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.done_rounded,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 20), // Espacio entre los botones
                    IconButton(
                      onPressed: () {
                        DetailPaymentController().updateStatus(
                            'Cancelled', detailPaymentId, context);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                        size: 40,
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

  Widget _buildItemInfo(Map<String, dynamic> product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product['name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Text(
              'Precio: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${product['price']}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Text(
              'Cantidad: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${product['quantity']}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
