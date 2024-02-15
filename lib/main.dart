import 'package:flutter/material.dart';
import 'package:loginusingsharedpref/LifeCycleManager.dart';
import 'package:loginusingsharedpref/locator.dart';
import 'loginpage.dart';

void main() {
  setupLocator();
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:Scaffold(
              body: const Loginpage(),
              // Ensure 'Loginpage' is properly defined
          ),
        initialRoute: '/login',
        routes: {'/login':(context)=>Loginpage()},),
    );
  }
}
