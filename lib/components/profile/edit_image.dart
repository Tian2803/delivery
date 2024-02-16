// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';

import 'package:delivery/controller/customer_controller.dart';
import 'package:delivery/controller/owner_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  late XFile sampleImage = XFile('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Upload a photo of yourself",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const BackButton(),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                      width: 330,
                      child: GestureDetector(
                        onTap: () async {
                          var tempImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (tempImage != null) {
                            setState(() {
                              sampleImage = XFile(tempImage.path);
                            });
                          }
                        },
                        child: Column(
                          children: [
                            if (sampleImage.path.isEmpty)
                              Image.network(widget.image),
                            if (sampleImage.path.isNotEmpty)
                              Image.file(File(sampleImage.path)),
                          ],
                        ),
                      ))),
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final uid = FirebaseAuth.instance.currentUser!.uid;
                            String? ownerId =
                                await OwnerController().getOwnerId();
                            if (uid != ownerId) {
                              CustomerController()
                                  .updateImageProfile(sampleImage, uid, context);
                            } else {
                              OwnerController()
                                  .updateImageProfile(sampleImage, uid, context);
                            }
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ))),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }
}
