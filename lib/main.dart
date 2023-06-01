import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_file_structure/controllers/app_binding.dart';
import 'package:flutter_file_structure/pages/EndNotify.dart';
import 'package:flutter_file_structure/pages/ErrorPage.dart';
import 'package:flutter_file_structure/pages/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SignInScreen(),
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
