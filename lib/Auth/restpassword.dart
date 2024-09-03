// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/Models/snackbar.dart';
import 'package:chatapp/Shared/textdecoration.dart';
import 'package:chatapp/Supabase/Authintication.dart';
import 'package:chatapp/provider/UserChat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class RestPassword extends StatefulWidget {
  RestPassword({super.key});

  @override
  State<RestPassword> createState() => _RestPasswordState();
}

class _RestPasswordState extends State<RestPassword> {
  final email = TextEditingController();

  final _key = GlobalKey<FormState>();

  Authintication user = Authintication();

  bool isRestPassword = true;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserChatHome>(context, listen: false);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.teal,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100),
                    margin: const EdgeInsets.only(top: 50.0),
                    height: MediaQuery.sizeOf(context).height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: provider.theme == ThemeData.dark()
                          ? Colors.black
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 60,
                          child: Text(
                            "Rest",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Form(
                            key: _key,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                      controller: email,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                            .hasMatch(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      decoration: userdecoration.copyWith(
                                          hintText: " Email",
                                          prefixIcon: const Icon(Icons.email))),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  MaterialButton(
                                      onPressed: () async {
                                        if (_key.currentState!.validate()) {
                                          try {
                                            setState(() {
                                              isRestPassword = false;
                                            });
                                            var response =
                                                await user.RestPassword(
                                                    email.text.trim());

                                            if (response != null) {
                                              setState(() {
                                                isRestPassword = true;
                                              });
                                              ShowSnackbar(
                                                  context,
                                                  "Link has rest successfuly",
                                                  Colors.green);
                                            } else {
                                              setState(() {
                                                isRestPassword = true;
                                              });

                                              ShowSnackbar(
                                                  context,
                                                  "emial or password does not exists",
                                                  Colors.red);
                                            }
                                          } on AuthException catch (e) {
                                            setState(() {
                                              isRestPassword = true;
                                            });
                                            if (e.message.contains(
                                                "ClientException with SocketException")) {
                                              ShowSnackbar(
                                                  context,
                                                  "Server Connection Error",
                                                  Colors.red);
                                            } else {
                                              ShowSnackbar(context, e.message,
                                                  Colors.red);
                                            }
                                          } catch (e) {
                                            setState(() {
                                              isRestPassword = true;
                                            });
                                            ShowSnackbar(
                                                context, "${e}", Colors.red);
                                          }
                                          clear();
                                        }
                                      },
                                      color: Colors.teal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0, vertical: 20.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: isRestPassword
                                          ? const Text("RestPassword",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20))
                                          : const CircularProgressIndicator(
                                              color: Colors.white,
                                            )),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 55,
                    left: 10,
                    child: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "auth", (route) => false);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                            weight: 20.0,
                          )),
                      decoration: BoxDecoration(
                        color: Colors.teal[600],
                        shape: BoxShape.circle,
                      ),
                    ))
              ],
            )));
  }

  clear() {
    email.clear();
    _key.currentState!.reset();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.clear();
  }
}
