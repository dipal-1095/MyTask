import 'package:flutter/material.dart';
import 'package:loginusingsharedpref/loginpage.dart';
import 'package:loginusingsharedpref/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final UserEmail = Provider.of<UserEmailProvider>(context).email;
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 200,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.amber),
                accountEmail: Text(UserEmail,
                  style: TextStyle(fontFamily: 'poppins', fontSize: 15),
                ),
                currentAccountPictureSize: Size.square(70),
                currentAccountPicture: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/person.png'),
                ), accountName: null,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.login_outlined),
            title: Text('Logout'),
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              await pref.clear();
              Navigator.pop(context,true);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
            },
          ),
        ],
      ),
    );
  }
}
