import 'package:flutter/material.dart';
import 'package:loginusingsharedpref/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigation_drawer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String token = " ";

  void initState() {
    // TODO: implement initState
    super.initState();
    getCred();
  }

  Future<void> getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth=MediaQuery.of(context).size.width;
    var screenHeight=MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.appBarColor,
        ),
        body: SafeArea(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome User'),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Your Token : ${token}"),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
