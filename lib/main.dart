import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taletalk/HomePage.dart';
import 'package:taletalk/PermissionsPage.dart';
import 'package:taletalk/SplashScreen.dart';
import 'package:taletalk/WelcomePage.dart';
import 'package:taletalk/SetUpPages/SetupPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "apiKey",
          appId: "appId",
          messagingSenderId: "id",
          projectId: "projectId"));
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen()
    );
  }
}

