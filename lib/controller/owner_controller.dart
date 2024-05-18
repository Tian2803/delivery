// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/controller/alert_dialog.dart';
import 'package:delivery/controller/aux_controller.dart';
import 'package:delivery/model/owner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OwnerController {
  void registerOwner(
      String ownerName,
      String ownerLastName,
      String ownerPhone,
      String ownerEmail,
      String ownerStreetAddress,
      String ownerPassword,
      String ownerPasswordConf,
      XFile ownerProfile,
      BuildContext context) async {
    try {
      if (ownerName.isEmpty ||
          ownerPhone.isEmpty ||
          ownerLastName.isEmpty ||
          ownerEmail.isEmpty ||
          ownerStreetAddress.isEmpty ||
          ownerPassword.isEmpty ||
          ownerPasswordConf.isEmpty ||
          ownerProfile.path.isEmpty) {
        showPersonalizedAlert(context, 'Por favor, complete todos los campos',
            AlertMessageType.warning);
      } else {
        bool isEmailValid = AuxController.validateEmail(ownerEmail);
        bool isPasswordValid =
            AuxController.validatePasswords(ownerPassword, ownerPasswordConf);
        if (isEmailValid && isPasswordValid) {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: ownerEmail, password: ownerPasswordConf);
          if (userCredential.user != null) {
            String uid = userCredential.user!.uid;

            String extension = ownerProfile.path
                .split('.')
                .last; // Obtener la extensión del archivo
            String fileName =
                "${uid}_${DateTime.now().millisecondsSinceEpoch}.$extension";

            firebase_storage.Reference reference = firebase_storage
                .FirebaseStorage.instance
                .ref()
                .child('ownerImages')
                .child(fileName);

            await reference.putFile(File(ownerProfile.path));
            String downloadURL = await reference.getDownloadURL();
            print("Imagen subida con éxito. URL: $downloadURL");

            Owner owner = Owner(
                ownerName: ownerName,
                ownerLastName: ownerLastName,
                ownerPhone: ownerPhone,
                ownerStreetAddress: ownerStreetAddress,
                ownerEmail: ownerEmail,
                ownerProfile: downloadURL,
                ownerId: uid);

            await FirebaseFirestore.instance
                .collection('owners')
                .doc(uid)
                .set(owner.toJson());

            showPersonalizedAlert(
              context,
              "Registro exitoso",
              AlertMessageType.success,
            );
          } else {
            showPersonalizedAlert(
                context,
                'Error al guardar datos del admnistrador',
                AlertMessageType.error);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      // Maneja errores específicos de FirebaseAuth
      if (e.code == 'email-already-in-use') {
        showPersonalizedAlert(
            context,
            'Correo electrónico ya registrado,\ninicia sesión en lugar de registrarse.',
            AlertMessageType.error);
      } else if (e.code == 'invalid-email') {
        showPersonalizedAlert(
            context,
            'El formato del correo electrónico\nno es válido.',
            AlertMessageType.error);
      } else if (e.code == 'operation-not-allowed') {
        showPersonalizedAlert(
            context,
            'La operación de registro no está\npermitida.',
            AlertMessageType.error);
      } else if (e.code == 'weak-password') {
        showPersonalizedAlert(
            context,
            'La contraseña es débil, debe tener\nal menos 15 caracteres.',
            AlertMessageType.error);
      } else {
        // Muestra una alerta si ocurre otro tipo de error en la autenticación
        showPersonalizedAlert(context, 'Error al registrar al administrador',
            AlertMessageType.error);
        print(e);
      }
    }
  }

  Future<String?> getUserNameOwner() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final owner =
          await FirebaseFirestore.instance.collection('owners').doc(uid).get();
      if (owner.exists) {
        final name = owner.data()?['ownerName'];
        final lastName = owner.data()?['ownerLastName'];
        return "$name $lastName";
      }
      return null;
    } catch (e) {
      throw Exception('No se pudo obtener el nombre de la compañía.');
    }
  }

  Future<String?> getOwnerId() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('owners').doc(uid).get();

      if (userDoc.exists) {
        final ownerId = userDoc.data()?['ownerId'];
        return ownerId as String;
      }
    } catch (e) {
      print('No existe el usuario en la colecccion.');
      print(e);
    }
    return null;
  }

  Future<bool> esOwner() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('owners').doc(uid).get();

      if (userDoc.exists) {
        return true;
      }
    } catch (e) {
      print('No existe el usuario en la colecccion.');
      print(e);
    }
    return false;
  }

  Future<List<Owner>> getOwnerDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Realiza la consulta a Firebase Firestore
      QuerySnapshot snapshot = await firestore.collection('owners').get();

      // Inicializa una lista para almacenar los owners
      List<Owner> owner = [];
      // Recorre los documentos y crea instancias de la clase Owner
      for (var doc in snapshot.docs) {
        owner.add(Owner(
            ownerName: doc['ownerName'],
            ownerLastName: doc['ownerLastName'],
            ownerPhone: doc['ownerPhone'],
            ownerStreetAddress: doc['ownerStreetAddress'],
            ownerEmail: doc['ownerEmail'],
            ownerProfile: doc['ownerProfile'],
            ownerId: doc['ownerId']));
      }
      // Devuelve la lista de owners
      return owner;
    } catch (e) {
      // Maneja errores de forma adecuada
      print('Error, no se logro obtener la información de los admins: $e');
      throw Exception(
          'No se pudo obtener la información de los administradores.');
    }
  }

  Future<String> getName(String idOwner) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('owners')
          .doc(idOwner)
          .get();

      final fullName =
          doc.data()?['ownerName'] + " " + doc.data()?['ownerLastName'];
      print(fullName);
      return fullName as String;
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del administardor.');
    }
  }

  Future<void> updateAddress(String address, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('owners').doc(uid);
    await productRef.update({
      'ownerStreetAddress': address,
    });
  }

  Future<void> updateEmail(String email, String uid) async {
    await FirebaseAuth.instance.currentUser!.updateEmail(email);

    DocumentReference productRef =
        FirebaseFirestore.instance.collection('owners').doc(uid);
    await productRef.update({
      'ownerEmail': email,
    });
  }

  Future<void> updateLastName(String lastName, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('owners').doc(uid);
    await productRef.update({
      'ownerLastName': lastName,
    });
  }

  Future<void> updateName(String name, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('owners').doc(uid);
    await productRef.update({
      'ownerName': name,
    });
  }

  Future<void> updatePhone(String phone, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('owners').doc(uid);
    await productRef.update({
      'ownerPhone': phone,
    });
  }

  Future<void> updateImageProfile(
      XFile image, String uid, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Actualizando foto ..."),
            ],
          ),
        );
      },
    );
    String extension = image.path.split('.').last;
    String fileName =
        "${uid}_${DateTime.now().millisecondsSinceEpoch}.$extension";

    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('ownerImages')
        .child(fileName);
    await reference.putFile(File(image.path));
    String downloadURL = await reference.getDownloadURL();
    print("Imagen subida con éxito. URL: $downloadURL");

    DocumentReference productRef =
        FirebaseFirestore.instance.collection('owners').doc(uid);
    await productRef.update({
      'ownerProfile': downloadURL,
    });

    Navigator.of(context).pop();
    Navigator.pop(context);
  }
}
