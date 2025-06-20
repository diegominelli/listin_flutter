import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listin/_core/my_colors.dart';
import 'package:listin/authentication/screen/auth_screen.dart';
import 'package:listin/firestore/presentation/home_screen.dart';
import 'package:listin/storage/storage_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore.collection("Só para testar").doc("Estou testando").set({
    "Funcionou?": true,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listin - Lista Colaborativa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MyColors.earthyBrown,
        useMaterial3: false,
        scaffoldBackgroundColor: MyColors.cornYellow,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: MyColors.red,
        ),
        listTileTheme: ListTileThemeData(iconColor: MyColors.blue),
        appBarTheme: AppBarTheme(
          toolbarHeight: 72,
          centerTitle: true,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
      ),
      home: const StorageScreen(),
    );
  }
}

class RoteadorTelas extends StatelessWidget {
  const RoteadorTelas({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return HomeScreen(user: snapshot.data!);
          } else {
            return const AuthScreen();
          }
        }
      },
    );
  }
}
