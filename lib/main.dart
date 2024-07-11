import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/config/routes/app_route.dart';
import 'package:hospital/config/themes/theme_constants.dart';
import 'package:hospital/features/auth/login/login_page.dart';
import 'package:hospital/features/auth/register/signup_page.dart';
import 'package:hospital/features/display/admin/admin_display.dart';
import 'package:hospital/features/display/user/user_display.dart';
// import 'package:hospital/features/display/doctor/home.dart';
// import 'package:hospital/features/display/patient/booking.dart';
// import 'package:hospital/features/display/patient/home.dart';
import 'package:hospital/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoute.initial,

      routes: {
        AppRoute.initial : (context) => const LoginPage(),
        AppRoute.signup :(context) => const SignupPage(),
        AppRoute.admin_home: (context) => const AdminDisplay(),
        AppRoute.user_home: (context) => const UserDisplay(),
        
      },
    );
     
  }
}
