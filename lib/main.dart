import 'package:flutter/material.dart';
import 'package:task_form/DisplayDetails.dart';
import 'package:task_form/RegistrtionForm.dart';

import 'Splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Form',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/registration': (context) => const RegistrationForm(),
        '/registration/details': (context) => DisplayDetails(
            firstName: '', lastName: '', email: '', phone: '', age: '', cv: ''),
      },
    );
  }
}
