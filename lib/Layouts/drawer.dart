import 'package:chatapp/Shared/user.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Column(
                children: [
                  UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(color: Colors.teal),
                      currentAccountPicture: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "profile");
                        },
                        child: CircleAvatar(
                          backgroundImage: UserChat.getuserImage() == ""
                              ? AssetImage('images/userimage.jpeg')
                              : NetworkImage("${UserChat.getuserImage()}"),
                        ),
                      ),
                      accountName: Text(UserChat.getUserUsername()),
                      accountEmail: Text(UserChat.getUserEmail())),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "home", (route) => false);
                    },
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                  ),
                  ListTile(
                    onTap: () async {
                      const url =
                          "https://wa.me/qr/ZXCYJHYBD7EKJ1";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    leading: Icon(Icons.support_agent),
                    title: Text("Support Team"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, "profile");
                    },
                    leading: Icon(Icons.person),
                    title: Text("Profile"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, "setting");
                    },
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Deployed By: Mahmoud Atro © 2024",
              style: TextStyle(fontSize: 12.0),
            ),
          )
        ],
      ),
    );
  }
}
