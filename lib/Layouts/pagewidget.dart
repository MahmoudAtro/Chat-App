import 'package:chatapp/Layouts/chat_get_layout.dart';
import 'package:chatapp/Shared/user.dart';
import 'package:chatapp/Supabase/Chats.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Pagewidget extends StatelessWidget {
  Pagewidget({super.key, required this.user});
  final Map user;
  final user1_id = UserChat.getUserId();
  Chats chat = Chats();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => Chatlayout(userchat: user)));
        await chat.create_chat(user1_id, user['id']);
      },
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
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
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user["bio"] ?? "hey there"),
              trailing: Text(
                "Online",
                style: TextStyle(color: Colors.teal),
              ),
            ),
          )
        ],
      ),
    );
  }
}
