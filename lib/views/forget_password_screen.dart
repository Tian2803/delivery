import 'package:delivery/components/password_reset/password_reset.dart';
import 'package:delivery/styles/text_styles.dart';
import 'package:delivery/views/sign_in.dart';
import 'package:flutter/material.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset password",
          style: KTextStyle.font24Blue700Weight,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back_ios_new_rounded), // Icono de flecha hacia atrás
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Signin()));
          },
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 5),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Enter email to reset password",
                              style: KTextStyle.font14Grey400Weight,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PasswordReset(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure minimum height
                  children: [
                    SizedBox(
                      height: 24,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
