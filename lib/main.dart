import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:penny/Services/auth_service.dart';
import 'package:penny/Screens/mainScreen/Screens/homeScreen/HomePage.dart';
import 'package:penny/Screens/signUp.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkAuthentication() async {
    final authService = AuthService();
    return await authService.isAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthentication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Penny Saved',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromRGBO(22, 22, 33, 1),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(22, 22, 33, 1),
                background: const Color.fromRGBO(22, 22, 33, 1),
              ),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Penny Saved',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromRGBO(22, 22, 33, 1),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(22, 22, 33, 1),
                background: const Color.fromRGBO(22, 22, 33, 1),
              ),
              useMaterial3: true,
            ),
            home: const Signup(),
          );
        }
      },
    );
  }
}
