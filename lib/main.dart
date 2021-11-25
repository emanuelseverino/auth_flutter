import 'package:auth_teste/check_page.dart';
import 'package:auth_teste/home_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: const Color(0xffeeb3b3),
            ),
        scaffoldBackgroundColor: const Color(0xfff9f2e4),
        inputDecorationTheme: const InputDecorationTheme(
          errorStyle: TextStyle(
            color: const Color(0xffeeb3b3),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            primary: const Color(0xff57554b),
            backgroundColor: const Color(0xffeeb3b3),
            shape: const StadiumBorder(),
            side: const BorderSide(
              width: 2,
              color: Color(0xff57554b),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: OutlinedButton.styleFrom(
            primary: const Color(0xff57554b),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
