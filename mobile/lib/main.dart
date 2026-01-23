import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/screens/add_vehicle_screen.dart';
import 'package:mobile/screens/bottom_navigation.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/logo_screen.dart';
import 'package:mobile/screens/registration_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Firebase initialized successfully!");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      routes: {
        '/': (context) => const LogoScreen(),
        '/signIn': (context) => const SignInScreen(),
        '/signUp': (context) => const RegisterScreen(),
        '/add-vehicle': (context) => const AddVehicleScreen(),
        '/home': (context) => const BottomNavigation(),
      },
    );
  }
}
