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
        info.add(customerSnapshot.data()?['name'] ?? '');
        info.add(customerSnapshot.data()?['lastName'] ?? '');
        info.add(customerSnapshot.data()?['profileImage'] ?? '');
      } else {
        final ownerSnapshot = await FirebaseFirestore.instance
            .collection('owners')
            .doc(uid)
            .get();
        if (ownerSnapshot.exists) {
          info.add(ownerSnapshot.data()?['name'] ?? '');
          info.add(ownerSnapshot.data()?['lastName'] ?? '');
          info.add(ownerSnapshot.data()?['profileImage'] ?? '');
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
        info.add(customerSnapshot.data()?['name'] ?? '');
        info.add(customerSnapshot.data()?['lastName'] ?? '');
        info.add(customerSnapshot.data()?['phone'] ?? '');
        info.add(customerSnapshot.data()?['email'] ?? '');
        info.add(customerSnapshot.data()?['streetAddress'] ?? '');
        info.add(customerSnapshot.data()?['profileImage'] ?? '');
      } else {
        final ownerSnapshot = await FirebaseFirestore.instance
            .collection('owners')
            .doc(uid)
            .get();
        if (ownerSnapshot.exists) {
          info.add(ownerSnapshot.data()?['name'] ?? '');
          info.add(ownerSnapshot.data()?['lastName'] ?? '');
          info.add(ownerSnapshot.data()?['phone'] ?? '');
          info.add(ownerSnapshot.data()?['email'] ?? '');
          info.add(ownerSnapshot.data()?['streetAddress'] ?? '');
          info.add(ownerSnapshot.data()?['profileImage'] ?? '');
        }
      }

      return info;
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del usuario.');
    }
  }
}
