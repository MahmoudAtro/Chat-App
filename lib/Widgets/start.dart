import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatapp/Shared/user.dart';
import 'package:flutter/material.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  void initState() {
    UserChat.init();
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      UserChat.getIsLogin()
          ? Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false)
          : Navigator.pushNamedAndRemoveUntil(
              context, "auth", (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        padding: EdgeInsets.all(40),
        color: Colors.teal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                "images/chat.jpeg",
                width: 120,
                height: 120,
              ),
            ),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Wellcome in My Chat App!',
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  speed: Duration(milliseconds: 50),
                ),
              ],
              totalRepeatCount: 1,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    ));
  }
}
