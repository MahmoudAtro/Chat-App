// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/Models/snackbar.dart';
import 'package:chatapp/Shared/textdecoration.dart';
import 'package:chatapp/Shared/user.dart';
import 'package:chatapp/Supabase/Authintication.dart';
import 'package:chatapp/provider/UserChat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();

  final password = TextEditingController();

  final _key = GlobalKey<FormState>();

  Authintication user = Authintication();

  bool isshow = true;

  bool islogin = true;

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
                            "LOGIN",
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
                                  TextFormField(
                                    controller: password,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters long';
                                      }
                                      return null;
                                    },
                                    obscureText: isshow,
                                    decoration: userdecoration.copyWith(
                                        hintText: "Password",
                                        prefixIcon: const Icon(Icons.key),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isshow = !isshow;
                                              });
                                            },
                                            icon: isshow
                                                ? const Icon(Icons.visibility)
                                                : const Icon(
                                                    Icons.visibility_off))),
                                  ),
                                  const SizedBox(height: 5,),
                                  TextButton(onPressed: (){
                                    Navigator.pushNamed(context, "rest");
                                  },
                                  
                                   child: Text("forget you password?")),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  MaterialButton(
                                      onPressed: () async {
                                        if (_key.currentState!.validate()) {
                                          try {
                                            setState(() {
                                              islogin = false;
                                            });
                                            await user.SignIn(email.text.trim(),
                                                password.text.trim());

                                            if (user.client.auth.currentUser !=
                                                null) {
                                              setState(() {
                                                islogin = true;
                                              });
                                              final data = user
                                                  .client
                                                  .auth
                                                  .currentUser!
                                                  .userMetadata as Map;
                                              final userId = user.client.auth
                                                  .currentUser!.id as String;
                                              Navigator.pushReplacementNamed(
                                                  context, 'home');
                                              UserChat.setup(data, userId);
                                            } else {
                                              setState(() {
                                                islogin = true;
                                              });

                                              ShowSnackbar(
                                                  context,
                                                  "emial or password does not exists",
                                                  Colors.red);
                                            }
                                          } on AuthException catch (e) {
                                            setState(() {
                                              islogin = true;
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
                                              islogin = true;
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
                                      child: islogin
                                          ? const Text("Login",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20))
                                          : const CircularProgressIndicator(
                                              color: Colors.white,
                                            )),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "you dont have account?",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            color: Colors.blue[600]),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, "register");
                                          },
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                color: Colors.teal[600]),
                                          )),
                                    ],
                                  )
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
    password.clear();
    _key.currentState!.reset();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.clear();
    password.clear();
  }
}
