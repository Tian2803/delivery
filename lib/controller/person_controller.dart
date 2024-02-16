import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonController {
  Future<List<String>> getUserName() async {
    try {
      List<String> info = [];

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final customerSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get();

      if (customerSnapshot.exists) {
        info.add(customerSnapshot.data()?['customerName'] ?? '');
        info.add(customerSnapshot.data()?['customerLastName'] ?? '');
        info.add(customerSnapshot.data()?['customerProfile'] ?? '');
      } else {
        final ownerSnapshot = await FirebaseFirestore.instance
            .collection('owners')
            .doc(uid)
            .get();
        if (ownerSnapshot.exists) {
          info.add(ownerSnapshot.data()?['ownerName'] ?? '');
          info.add(ownerSnapshot.data()?['ownerLastName'] ?? '');
          info.add(ownerSnapshot.data()?['ownerProfile'] ?? '');
        }
      }

      return info;
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del usuario.');
    }
  }

  Future<List<String>> getProfileData() async {
    try {
      List<String> info = [];

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final customerSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get();

      if (customerSnapshot.exists) {
        info.add(customerSnapshot.data()?['customerName'] ?? '');
        info.add(customerSnapshot.data()?['customerLastName'] ?? '');
        info.add(customerSnapshot.data()?['customerPhone'] ?? '');
        info.add(customerSnapshot.data()?['customerEmail'] ?? '');
        info.add(customerSnapshot.data()?['customerStreetAddress'] ?? '');
        info.add(customerSnapshot.data()?['customerProfile'] ?? '');
      } else {
        final ownerSnapshot = await FirebaseFirestore.instance
            .collection('owners')
            .doc(uid)
            .get();
        if (ownerSnapshot.exists) {
          info.add(ownerSnapshot.data()?['ownerName'] ?? '');
          info.add(ownerSnapshot.data()?['ownerLastName'] ?? '');
          info.add(ownerSnapshot.data()?['ownerPhone'] ?? '');
          info.add(ownerSnapshot.data()?['ownerEmail'] ?? '');
          info.add(ownerSnapshot.data()?['ownerStreetAddress'] ?? '');
          info.add(ownerSnapshot.data()?['ownerProfile'] ?? '');
        }
      }

      return info;
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del usuario.');
    }
  }
}
