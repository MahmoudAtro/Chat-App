import 'package:chatapp/Layouts/drawer.dart';
import 'package:chatapp/Layouts/get_user.dart';
import 'package:chatapp/Models/snackbar.dart';
import 'package:chatapp/Shared/user.dart';
import 'package:chatapp/Supabase/Authintication.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Pagelayout extends StatelessWidget {
  Authintication user = Authintication();
  Pagelayout({
    required this.title,
    super.key,
    required this.body,
    required this.isdrawer,
    required this.ischat,
    required this.ishome,
  });
  final String title;
  final Widget body;
  final bool isdrawer;
  final bool ischat;
  final bool ishome;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0.0,
        actions: [
          ischat
              ? Row(
                  children: [
                    IconButton(icon: Icon(Icons.call), onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.replay_outlined), onPressed: () {}),
                  ],
                )
              : IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      drawer: isdrawer ? MyDrawer() : null,
      body: Column(
        children: [
          user.client.auth.currentUser?.emailConfirmedAt == null
              ? MaterialBanner(
                  elevation: 1.0,
                  leading: Icon(
                    Icons.warning,
                    color: Colors.amber,
                  ),
                  content: Text(
                    "your email is not confirmed",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  actions: [
                      TextButton(
                        onPressed: () async {
                          try {
                            var response =
                                await user.RestEmail(UserChat.getUserEmail());
                            if (response != null) {
                              ShowSnackbar(
                                  context,
                                  "resend to your email successfuly",
                                  Colors.green);
                            }
                          } catch (e) {
                            ShowSnackbar(context, "${e}", Colors.red);
                          }
                        },
                        child: const Text("Confirm Email"),
                      )
                    ])
              : const SizedBox(),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: ishome
          ? FloatingActionButton(
              onPressed: () {
                get_user(context);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
              backgroundColor: Colors.teal,
              child: Icon(
                Icons.chat,
                color: Colors.white,
              ),
            )
          : null,
    ));
  }
}
