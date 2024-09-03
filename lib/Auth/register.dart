import 'package:chatapp/Models/snackbar.dart';
import 'package:chatapp/Shared/textdecoration.dart';
import 'package:chatapp/Shared/user.dart';
import 'package:chatapp/Supabase/Authintication.dart';
import 'package:chatapp/provider/UserChat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final email = TextEditingController();

  final password = TextEditingController();

  final name = TextEditingController();

  bool isregister = true;
  final _key = GlobalKey<FormState>();

  bool isshow = true;

  Authintication user = Authintication();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserChatHome>(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.teal,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: 75.0),
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
                            "REGISTER",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0),
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
                                      controller: name,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                      decoration: userdecoration.copyWith(
                                          hintText: "Name",
                                          prefixIcon:
                                              const Icon(Icons.person))),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
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
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  MaterialButton(
                                      onPressed: () async {
                                        if (_key.currentState!.validate()) {
                                          setState(() {
                                            isregister = false;
                                          });
                                          try {
                                            var response = await user.SignUp(
                                                email.text.trim(),
                                                password.text.trim(),
                                                name.text.trim());
                                            if (response.user != null) {
                                              print(
                                                  "response.user is ${response.user}");
                                              setState(() {
                                                isregister = true;
                                              });
                                              final userdata = response.user;
                                              final data =
                                                  userdata!.userMetadata as Map;
                                              final userId =
                                                  userdata.id as String;
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  "home",
                                                  (route) => false);
                                              UserChat.setup(data, userId);
                                            } else {
                                              ShowSnackbar(
                                                  context,
                                                  "valid email or password",
                                                  Colors.amber);
                                              setState(() {
                                                isregister = true;
                                              });
                                            }
                                          } on AuthException catch (e) {
                                            setState(() {
                                              isregister = true;
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
                                              isregister = true;
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
                                      child: isregister
                                          ? const Text("Register",
                                              style: const TextStyle(
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
                                        "you have been account?",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            color: Colors.blue[600]),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, "login");
                                          },
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
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
    name.clear();
    password.clear();
  }
}
