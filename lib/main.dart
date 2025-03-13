import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/View/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async{

WidgetsFlutterBinding.ensureInitialized();

Firebase.initializeApp(
  // options: FirebaseOptions(
  //   apiKey: "AIzaSyB7F1AwsNU0b5bmLwOgbeJ_lxjmV93MK0E",
  // authDomain: "project-1-6f4c1.firebaseapp.com",
  // projectId: "project-1-6f4c1",
  // storageBucket: "project-1-6f4c1.firebasestorage.app",
  // messagingSenderId: "251652989210",
  // appId: "1:251652989210:web:1887a06310b5c388e00ca3",
  // measurementId: "G-H93FBV7LGY"
  //  )
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}