import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loginusingsharedpref/navigationbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserEmailProvider extends ChangeNotifier {
  String _email=' ';

  String get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
}


class Loginpage extends StatefulWidget with WidgetsBindingObserver{
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> with WidgetsBindingObserver{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var _isobscure;
  bool _emailvalidate = false;
  bool _passwordvalidate = false;

  bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  void initState() {

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isobscure = true;
    checkLogin();
  }

  Future<void> checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = await pref.getString("login");
    if (val != null) {
      Navigator.of(context as BuildContext)
          .push(MaterialPageRoute(builder: (context) => Loginpage()));
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(email, password) async {
    try {
      Response response = await post(
        Uri.parse('https://reqres.in/api/login'), // Assuming this is a login endpoint
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) { // Assuming successful login returns status code 200
        var data = jsonDecode(response.body);

        if (data.containsKey('token')) { // Assuming your response contains a token
          final userToken = data['token'] as String;
          Provider.of<UserEmailProvider>(context, listen: false).setEmail(email);

          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("login", userToken);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NavigationMenu()));
          emailController.clear();
          passwordController.clear();
        } else {
          // Handle case when token is not found in the response
          print('Token not found in response');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred during login. Please try again later.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle case when login request fails
        print('Login failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any other errors
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 20,
                shadowColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Login Here..',
                        style: TextStyle(
                            color: Colors.amber.shade600,
                            fontSize: 30,
                            fontFamily: 'Pacifico'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                width: 1.5,
                              ),
                            ),
                            prefixIcon: Icon(Icons.email),
                            hintText: 'E-mail',
                            labelText: "E-mail",
                            errorText:
                                _emailvalidate ? "Please enter email" : null,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      child: Container(
                        child: TextField(
                          obscureText: _isobscure,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1.5),
                              ),
                              prefixIcon: IconButton(
                                icon: _isobscure
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isobscure = !_isobscure;
                                  });
                                },
                              ),
                              hintText: 'Password',
                              labelText: "Password",
                              errorText: _passwordvalidate
                                  ? "Please enter password"
                                  : null),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (emailController.text.isEmpty) {
                              _emailvalidate = true;
                            }
                            if (passwordController.text.isEmpty) {
                              _passwordvalidate = true;
                            } else if (!validateEmail(emailController.text)) {
                              // If email is not valid
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter a valid email.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (emailController.text.isEmpty &&
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Please Enter Data!"),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              // If both email and password are entered and email is valid
                              login(emailController.text.toString(),
                                  passwordController.text.toString());
                            }
                          });
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(400, 35),
                            backgroundColor: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


