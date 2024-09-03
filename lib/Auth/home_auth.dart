import 'package:flutter/material.dart';

class HomeAuth extends StatelessWidget {
  const HomeAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Positioned(
              child: Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
                color: Colors.tealAccent[400],
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(250))),
          )),
          Positioned(
              top: 50,
              left: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset("images/chat.jpeg" , width: 120, height: 120,),
              )),
          Positioned(
            top: 178,
            left: 190,
            child: Container(
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
          Positioned(
            top: 230,
            left: 180,
            child: Container(
              width: 30,
              height: 30,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
          Positioned(
              top: 320,
              left: -10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                width: 400,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "login");
                  },
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[600]),
                  ),
                ),
              )),

          Positioned(
              top: 400,
              left: -10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                width: 400,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "register");
                  },
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    ));
  }
}
