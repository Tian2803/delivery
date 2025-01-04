// ignore_for_file: avoid_print, unused_element

import 'dart:async';

import 'package:delivery/controller/notification_controller.dart';
import 'package:delivery/controller/shopping_controller.dart';
import 'package:delivery/firebase_options.dart';
import 'package:delivery/views/onboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Envuelve la inicialización y la ejecución de la aplicación en la misma zona
  runZonedGuarded(() async {
    NotificationServices notificationServices = NotificationServices();
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    @override
    void initState() {
      initState();
      notificationServices.requestNotificationPermission;
      notificationServices.isTokenRefresh();
      notificationServices.getDeviceToken().then((value) {
        print("Device token: ");
        print(value);
      });

    }

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

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification?.title.toString());
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
