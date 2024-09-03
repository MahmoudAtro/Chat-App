import 'package:chatapp/Layouts/chat_get_layout.dart';
import 'package:flutter/material.dart';

class ChatLayout extends StatelessWidget {
  const ChatLayout({super.key, required this.user});
  final Map user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chatlayout(
                      userchat: user,
                    )));
      },
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: user["img"] == null
                    ? Image.asset(
                        "images/userimage.jpeg",
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        user["img"],
                        fit: BoxFit.cover,
                      )),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.teal, width: 2.0),
                color: Colors.white),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                user["name"] ?? user["email"],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("hello world!"),
              trailing: Text("10:31 PM"),
            ),
          )
        ],
      ),
    );
  }
}
