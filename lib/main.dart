import 'package:flutter/material.dart';
import 'package:login/home.dart';
import 'package:login/verify.dart';
import 'package:provider/provider.dart';
import 'phone_provider.dart';
import 'splash_screen.dart';
import 'phone.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhoneProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
        theme: ThemeData(primarySwatch: Colors.red),
        initialRoute: 'splash_screen',
        routes: {
          'splash_screen': (context) => const SplashScreen(),
          'phone': (context) => const MyPhone(),
          'home': (context) => const MyHome(),
          'verify': (context) => MyVerify(
                phoneNumber: '', // Provide a default value if necessary
                data: '',
              )
        },
      ),
    ),
  );
}
