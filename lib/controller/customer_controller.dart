// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/controller/alert_dialog.dart';
import 'package:delivery/controller/auth_controller.dart';
import 'package:delivery/controller/aux_controller.dart';
import 'package:delivery/model/customer.dart';
import 'package:delivery/views/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomerController {
  Future<String?> getUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final customer = await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get();

      if (customer.exists) {
        final userName = customer.data()?['name'];
        final lastName = customer.data()?['lastName'];
        return userName + " " + lastName as String;
      }
      return "User name";
    } catch (e) {
      throw Exception('No se pudo obtener el nombre del usuario.');
    }
  }

  Future<String?> getUserPhone() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final customer = await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get();

      if (customer.exists) {
        final userPhone = customer.data()?['phone'];
        return userPhone as String;
      }
      return "User phone";
    } catch (e) {
      throw Exception('No se pudo obtener el telefono.');
    }
  }

  Future<void> registerCustomer(
      BuildContext context,
      String name,
      String lastName,
      String address,
      String phone,
      String email,
      XFile imageProfile,
      String deliveryPreference,
      String password,
      String passwordConf) async {
    try {
      if (name.isEmpty ||
          lastName.isEmpty ||
          phone.isEmpty ||
          address.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          deliveryPreference.isEmpty ||
          passwordConf.isEmpty) {
        showPersonalizedAlert(context, 'Por favor, complete todos los campos',
            AlertMessageType.warning);
      } else {
        bool isEmailValid = AuxController.validateEmail(email);
        bool isPasswordValid =
            AuxController.validatePasswords(password, passwordConf);

        if (isEmailValid && isPasswordValid) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Registrando usuario..."),
                  ],
                ),
              );
            },
          );
          UserCredential authResult =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (authResult.user != null) {
            String uid = authResult.user!.uid;
            String extension = imageProfile.path
                .split('.')
                .last; // Obtener la extensión del archivo
            String fileName =
                "${uid}_${DateTime.now().millisecondsSinceEpoch}.$extension";

            firebase_storage.Reference reference = firebase_storage
                .FirebaseStorage.instance
                .ref()
                .child('customerImages')
                .child(fileName);

            await reference.putFile(File(imageProfile.path));
            String downloadURL = await reference.getDownloadURL();
            print("\nImagen subida con éxito. URL: $downloadURL\n");

            Customer customer = Customer(
              name,
              lastName,
              phone,
              address,
              email,
              downloadURL,
              uid,
              deliveryPreference,
            );

            await FirebaseFirestore.instance
                .collection('customers')
                .doc(uid)
                .set(customer.toJson());

            showPersonalizedAlert(
                context, "Registro exitoso", AlertMessageType.success);

            User? user = FirebaseAuth.instance.currentUser;

            // Cerrar el indicador de carga
            Navigator.of(context).pop();

            if (user != null && user.emailVerified == false) {
              AuthController().sendEmailVerificationLink();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => VerifyEmail(user: user)),
              );
            }
          } else {
            Navigator.of(context).pop();
            showPersonalizedAlert(context, "Error al registrar al usuario}",
                AlertMessageType.error);
          }
        } else {
          Navigator.of(context).pop();
          showPersonalizedAlert(
              context, "Las contraseñas no coinciden", AlertMessageType.error);
        }
      }
    } on FirebaseAuthException catch (e) {
      // Maneja errores específicos de FirebaseAuth
      if (e.code == 'email-already-in-use') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
            context,
            'Correo electrónico ya registrado,\ninicia sesión en lugar de registrarse.',
            AlertMessageType.error);
      } else if (e.code == 'invalid-email') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
            context,
            'El formato del correo electrónico\nno es válido.',
            AlertMessageType.error);
      } else if (e.code == 'operation-not-allowed') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
            context,
            'La operación de registro no está\npermitida.',
            AlertMessageType.error);
      } else if (e.code == 'weak-password') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
            context,
            'La contraseña es débil, debe tener\nal menos 15 caracteres.',
            AlertMessageType.error);
      } else {
        Navigator.of(context).pop();
        // Muestra una alerta si ocurre otro tipo de error en la autenticación
        showPersonalizedAlert(
            context, 'Error al registrar al usuario', AlertMessageType.error);
        print(e);
      }
    }
  }

  Future<String?> getCustomerId() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final customerId = userDoc.data()?['id'];
        return customerId as String;
      }
    } catch (e) {
      print('No existe el usuario en la colecccion.');
      print(e);
    }
    return null;
  }

  Future<void> updateAddress(String address, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('customers').doc(uid);
    await productRef.update({
      'streetAddress': address,
    });
  }

  Future<void> updateEmail(String email, String uid) async {
    //await FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(email);
    await FirebaseAuth.instance.currentUser?.updateEmail(email);

    DocumentReference productRef =
        FirebaseFirestore.instance.collection('customers').doc(uid);
    await productRef.update({
      'email': email,
    });
  }

  Future<void> updateLastName(String lastName, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('customers').doc(uid);
    await productRef.update({
      'lastName': lastName,
    });
  }

  Future<void> updateName(String name, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('customers').doc(uid);
    await productRef.update({
      'name': name,
    });
  }

  Future<void> updatePhone(String phone, String uid) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('customers').doc(uid);
    await productRef.update({
      'phone': phone,
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
        .child('customerImages')
        .child(fileName);
    await reference.putFile(File(image.path));
    String downloadURL = await reference.getDownloadURL();
    print("Imagen subida con éxito. URL: $downloadURL");

    DocumentReference productRef =
        FirebaseFirestore.instance.collection('customers').doc(uid);
    await productRef.update({
      'profileImage': downloadURL,
    });

    Navigator.of(context).pop();
    Navigator.pop(context);
  }
}
