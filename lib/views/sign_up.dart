// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:delivery/components/items/custom_button.dart';
import 'package:delivery/components/items/custom_formfield.dart';
import 'package:delivery/components/items/custom_header.dart';
import 'package:delivery/components/items/custom_richtext.dart';
import 'package:delivery/controller/alert_dialog.dart';
import 'package:delivery/controller/aux_controller.dart';
import 'package:delivery/controller/customer_controller.dart';
import 'package:delivery/styles/app_colors.dart';
import 'package:delivery/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _deliveryPreferenceController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfController = TextEditingController();
  late XFile sampleImage = XFile('');

  String get name => _nameController.text.trim();
  String get lastName => _lastNameController.text.trim();
  String get phone => _phoneController.text.trim();
  String get streetAddress => _streetAddressController.text.trim();
  String get deliveryPreference => _deliveryPreferenceController.text.trim();
  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  String get passwordConf => _passwordConfController.text.trim();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  String? _errorTextEmail;
  String? _errorText1;
  String? _errorText2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.blue,
          ),
          CustomHeader(
            text: 'Sign Up.',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Signin()),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.whiteshade,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.09,
                      ),
                      child: Image.asset("assets/images/login.png"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Name",
                      hintText: "Jaeger",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _nameController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Last name",
                      hintText: "Kutski Saraki",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _lastNameController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Delivery preference",
                      hintText: "Home, Store",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _deliveryPreferenceController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Phone",
                      hintText: "3214567980",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.phone,
                      controller: _phoneController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Street address",
                      hintText: "Cartagena 32B Tower 2 Apto 1521",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.streetAddress,
                      controller: _streetAddressController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Email",
                      hintText: "exampledelivery@gmail.com",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress,
                      controller: _emailController,
                      errorText: _errorTextEmail,
                      onChanged: (value) {
                        setState(() {
                          _errorTextEmail =
                              !(AuxController.validateEmail(value))
                                  ? 'Invalid email'
                                  : null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _passwordController,
                      headingText: "Password",
                      hintText: "At least 15 Character",
                      obsecureText: _obscureText1,
                      suffixIcon: IconButton(
                        icon: _obscureText1
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                      ),
                      errorText: _errorText1,
                      onChanged: (value) {
                        setState(() {
                          _errorText1 = (AuxController()
                                  .isPasswordLengthValid(value))
                              ? 'Password must be at least 15 characters long'
                              : null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _passwordConfController,
                      headingText: "Password confirm",
                      hintText: "At least 15 Character",
                      obsecureText: _obscureText2,
                      suffixIcon: IconButton(
                        icon: _obscureText2
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                      ),
                      errorText: _errorText2,
                      onChanged: (value) {
                        setState(() {
                          _errorText2 = (AuxController()
                                  .isPasswordLengthValid(value))
                              ? 'Password must be at least 15 characters long'
                              : null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Text("Add image to your profile"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (sampleImage.path.isNotEmpty)
                      Container(
                        // Ajusta la altura según tus necesidades
                        alignment: Alignment.center,
                        child: ClipOval(
                          child: Image.file(
                            File(sampleImage.path),
                            width: 200,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () async {
                          try {
                            var tempImage = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (tempImage != null) {
                              setState(() {
                                sampleImage = XFile(tempImage.path);
                              });
                            }
                          } catch (e) {
                            showPersonalizedAlert(
                              context,
                              "Unexpected error",
                              AlertMessageType.error,
                            );
                          }
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    AuthButton(
                      onTap: () {
                        CustomerController().registerCustomer(
                          context,
                          name,
                          lastName,
                          streetAddress,
                          phone,
                          email,
                          sampleImage,
                          deliveryPreference,
                          password,
                          passwordConf,
                        );
                        //OwnerController().registerOwner("Softsian",name, lastName, phone, email, streetAddress,password, passwordConf, sampleImage, context);
                      },
                      text: 'Sign Up',
                    ),
                    CustomRichText(
                      discription: 'Already Have an account? ',
                      text: 'Log In here',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Signin(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
