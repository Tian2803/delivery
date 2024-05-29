// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:delivery/controller/alert_dialog.dart';
import 'package:delivery/controller/owner_controller.dart';
import 'package:delivery/views/home_customer.dart';
import 'package:delivery/views/home_owner.dart';
import 'package:delivery/views/sign_in.dart';
import 'package:delivery/views/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  Future<void> signInUser(
      BuildContext context, String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        showPersonalizedAlert(
          context,
          'Por favor ingrese su email y contraseña',
          AlertMessageType.error,
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Iniciando sesion..."),
                ],
              ),
            );
          },
        );

        final FirebaseAuth auth = FirebaseAuth.instance;

        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        User? user = userCredential.user;
        String uid = user!.uid;
        String? ownerId = await OwnerController().getOwnerId();

        // Cerrar el indicador de carga
        Navigator.of(context).pop();

        showPersonalizedAlert(
            context, "Inicio de sesion exitoso", AlertMessageType.success);

        if (user.emailVerified == false) {
          sendEmailVerificationLink();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VerifyEmail(user: user)),
          );
        } else {
          if (uid == ownerId) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreenOwner()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreenCustomer()),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
          context,
          'Usuario no encontrado',
          AlertMessageType.warning,
        );
      } else if (e.code == 'wrong-password') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
          context,
          'Contraseña incorrecta',
          AlertMessageType.warning,
        );
      } else if (e.code == 'invalid-email') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
          context,
          'El formato del correo electrónico\nno es válido.',
          AlertMessageType.error,
        );
      } else if (e.code == 'user-disabled') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
          context,
          'Su cuenta está deshabilitada.',
          AlertMessageType.error,
        );
      } else if (e.code == 'network-request-failed') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
          context,
          'Problema de red durante la autenticación.',
          AlertMessageType.error,
        );
      } else if (e.code == 'too-many-requests') {
        Navigator.of(context).pop();
        showPersonalizedAlert(
          context,
          'Demasiadas solicitudes desde el\nmismo dispositivo o IP.',
          AlertMessageType.error,
        );
      } else {
        Navigator.of(context).pop();
        showPersonalizedAlert(context, 'Error al iniciar sesión: ${e.message}',
            AlertMessageType.error);
        print(e.message);
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Signin()),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieveSession(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (user.emailVerified == false) {
          print("numero ${user.phoneNumber}");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VerifyEmail(user: user)),
          );
        } else {
          String uid = user.uid;

          // Obtener el ownerId desde Firestore
          String? ownerId = await OwnerController().getOwnerId();

          if (uid == ownerId) {
            // Si el UID del usuario es igual al ownerId, el usuario es un propietario
            if (user == false) {}
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreenOwner()),
            );
          } else {
            // Si el UID del usuario no es igual al ownerId, el usuario es un cliente
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreenCustomer()),
            );
          }
        }
      } else {
        // Si no hay usuario autenticado, redirigir a la pantalla de inicio de sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Signin()),
        );
      }
    } catch (e) {
      print('Error retrieving session: $e');
    }
  }

  String? email() {
    return FirebaseAuth.instance.currentUser!.email;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  Future<void> reload() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      await auth.currentUser!.reload();
    }
  }

  Future<void> sendEmailVerificationLink() async {
    final auth = FirebaseAuth.instance;
    try {
      if (auth.currentUser != null) {
        if (!auth.currentUser!.emailVerified) {
          await auth.currentUser?.sendEmailVerification();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendEmailResetPassword(
      String email, BuildContext context) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Reset Password',
        desc:
            'Link to Reset password send to your email, please check inbox messages.',
      ).show();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'Email not found',
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: e.message,
        ).show();
      }
    }
  }

  bool? get isEmailVerified => FirebaseAuth.instance.currentUser!.emailVerified;

  /*Future<void> sendEmailPhoneOTP(String email, BuildContext context) async {
    final auth = FirebaseAuth.instance;
    try {
      //await auth.verifyPhoneNumber(verificationCompleted: verificationCompleted, verificationFailed: verificationFailed, codeSent: codeSent, codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Change email',
        desc:
            'Link to Change email send to your email, please check inbox messages.',
      ).show();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'Email not found',
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: e.message,
        ).show();
      }
    }
  }*/
}
