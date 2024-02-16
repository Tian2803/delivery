// ignore_for_file: use_build_context_synchronously

import 'package:delivery/components/appbar_widget.dart';
import 'package:delivery/controller/customer_controller.dart';
import 'package:delivery/controller/owner_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class EditAddressFormPage extends StatefulWidget {
  const EditAddressFormPage({Key? key}) : super(key: key);

  @override
  EditAddressFormPageState createState() {
    return EditAddressFormPageState();
  }
}

class EditAddressFormPageState extends State<EditAddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                  width: 330,
                  child: Text(
                    "What's Your Address?",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                      child: SizedBox(
                          height: 100,
                          width: 300,
                          child: TextFormField(
                            // Handles Form Validation for First Name
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              } /* else if (isAlpha(value)) {
                                return 'Only Letters Please';
                              }*/
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Address'),
                            controller: addressController,
                          ))),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              final uid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              String? ownerId =
                                  await OwnerController().getOwnerId();
                              if (uid != ownerId) {
                                CustomerController()
                                    .updateAddress(addressController.text, uid);
                              } else {
                                OwnerController()
                                    .updateAddress(addressController.text, uid);
                              }
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )))
            ],
          ),
        ));
  }
}
