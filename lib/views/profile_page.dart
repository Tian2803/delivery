// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:async';

import 'package:delivery/components/display_image_widget.dart';
import 'package:delivery/components/nav_bar_owner.dart';
import 'package:delivery/components/profile/edit_address.dart';
import 'package:delivery/components/profile/edit_email.dart';
import 'package:delivery/components/profile/edit_image.dart';
import 'package:delivery/components/profile/edit_last_name.dart';
import 'package:delivery/components/profile/edit_name.dart';
import 'package:delivery/components/profile/edit_phone.dart';
import 'package:delivery/controller/person_controller.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<String>> userInfo;

  @override
  void initState() {
    userInfo = PersonController().getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(64, 105, 225, 1),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        /*leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF3a3737),
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, ScaleRoute(page: const HomeScreenOwner()));
          },
        ),*/
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<List<String>>(
            future: userInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se obtiene la información
                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Muestra un mensaje de error si hay algún problema
                print('Error: ${snapshot.error}');
                return const Text("Unexpected error");
              } else {
                // Muestra la información del usuario si la operación fue exitosa
                List<String> userInfoList = snapshot.data!;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        navigateSecondPage(EditImagePage(
                          image: userInfoList[5],
                        ));
                      },
                      child: DisplayImage(
                        imagePath: userInfoList[
                            5], // Asegúrate de usar el índice correcto
                        onPressed: () {},
                      ),
                    ),
                    buildUserInfoDisplay(
                        userInfoList[0], 'Name', const EditNameFormPage()),
                    buildUserInfoDisplay(userInfoList[1], 'Last Name',
                        const EditLastNameFormPage()),
                    buildUserInfoDisplay(
                        userInfoList[2], 'Phone', const EditPhoneFormPage()),
                    buildUserInfoDisplay(
                        userInfoList[3], 'Email', const EditEmailFormPage()),
                    buildUserInfoDisplay(userInfoList[4], 'Address',
                        const EditAddressFormPage()),
                  ],
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: const NavBarOwner(),
    );
  }

  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Container(
              width: 350,
              height: 40,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        navigateSecondPage(editPage);
                      },
                      child: Text(
                        getValue,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ),
                  IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      navigateSecondPage(editPage);
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      size: 40.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  FutureOr onGoBack(dynamic value) {
    // Actualiza la información del usuario cuando se vuelve de la página de edición
    setState(() {
      userInfo = PersonController().getProfileData();
    });
  }

  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
