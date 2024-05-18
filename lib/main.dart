// ignore_for_file: avoid_print

import 'dart:async';

import 'package:delivery/controller/notification_controller.dart';
import 'package:delivery/controller/shopping_controller.dart';
import 'package:delivery/firebase_options.dart';
import 'package:delivery/views/onboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Envuelve la inicialización y la ejecución de la aplicación en la misma zona
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await initNotifications();
    
    runApp(
      ChangeNotifierProvider<ShoppingController>(
        create: (context) => ShoppingController(),
        child: const MyApp(),
      ),
    );
  }, (error, stackTrace) {
    print('Error caught by zone: $error');
    print(stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardScreen(),
    );
  }
}
