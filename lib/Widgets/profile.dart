import 'package:chatapp/Layouts/pagelayout.dart';
import 'package:chatapp/Shared/user.dart';
import 'package:chatapp/Supabase/Authintication.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  Profile({super.key});
  Authintication user = Authintication();

  @override
  Widget build(BuildContext context) {
    return Pagelayout(
      ishome: false,
      title: "Profile",
      body: Padding(
        padding: const EdgeInsets.only(top: 13.0, left: 22.0, right: 22.0),
        child: Column(children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(125, 78, 91, 110),
              ),
              child: Stack(
                children: [
                  UserChat.getuserImage() == ""
                      ? CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 225, 225, 225),
                          radius: 71,
                          backgroundImage: UserChat.getuserImage() == ""
                              ? const AssetImage("images/userimage.jpeg")
                              : NetworkImage("${UserChat.getuserImage()}"),
                        )
                      : CircleAvatar(
                          radius: 71,
                          backgroundImage:
                              NetworkImage("${UserChat.getuserImage()}")),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 17,
          ),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
            child: const Text(
              "User Informations",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 20.0),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 76, 141, 95),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Name: ${UserChat.getUserUsername()} ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Email: ${UserChat.getUserEmail()} ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  const Text(
                    //
                    "Last Signed In: now ",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "updateuser");
                      },
                      child: const Text(
                        "Update User",
                        style: TextStyle(fontSize: 18.0),
                      )),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Center(
                      child: MaterialButton(
                    onPressed: () async {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "login", (route) => false);
                      await user.Logout();
                      await UserChat.logout();
                    },
                    color: Colors.red[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ]),
      ),
      isdrawer: false,
      ischat: false,
    );
  }
}
