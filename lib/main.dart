import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:penny/Services/auth_service.dart';
import 'package:penny/Providers/app_state.dart';
import 'package:penny/Screens/mainScreen/index.dart';
import 'package:penny/Screens/signUp.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51RpFIsQRaQw4CMhiugQ1h7MJyH1tcdXSlzfbtbMygoDpj8qkryct9lWszfjL5VUjBFJi9nxaZkQvJXSybdK7Cswj00eLTN1R2S';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
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
          return ChangeNotifierProvider(
            create: (_) {
              final appState = AppState();
              // seed AppState with stored token and listen for future token changes
              AuthService().getToken().then((t) {
                if (t != null) {
                  appState.setAuthToken(t);
                  appState.fetchUserProfile();
                }
              });
              AuthService().tokenStream.listen((tok) {
                if (tok != null) {
                  appState.setAuthToken(tok);
                  appState.fetchUserProfile();
                } else {
                  appState.setAuthToken('');
                }
              });
              return appState;
            },
            child: MaterialApp(
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
              home: const mainScreen(),
            ),
          );
        } else {
          return ChangeNotifierProvider(
            create: (_) {
              final appState = AppState();
              AuthService().getToken().then((t) {
                if (t != null) {
                  appState.setAuthToken(t);
                  appState.fetchUserProfile();
                }
              });
              AuthService().tokenStream.listen((tok) {
                if (tok != null) {
                  appState.setAuthToken(tok);
                  appState.fetchUserProfile();
                } else {
                  appState.setAuthToken('');
                }
              });
              return appState;
            },
            child: MaterialApp(
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
            ),
          );
        }
      },
    );
  }
}
