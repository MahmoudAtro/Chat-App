import 'package:chatapp/Supabase/Chats.dart';
import 'package:chatapp/provider/UserChat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatDetails extends StatelessWidget {
  ChatDetails({super.key, required this.user, required this.chatid});
  final Map user;
  final String chatid;
  Chats chat = Chats();

  @override
  Widget build(BuildContext context) {
    var chathome = Provider.of<UserChatHome>(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
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
              const SizedBox(
                height: 12,
              ),
              Text(
                user["name"] ?? "User Chat",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                user["email"],
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Text(user["bio"] ?? "I am using Chat"),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              Container(
                width: 150,
                height: 40,
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'حذف المحادثة !',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.green[900], fontSize: 20.0),
                            ),
                            elevation: 1.0,
                            shadowColor: Colors.black,
                            icon: Icon(Icons.delete),
                            iconColor: Colors.red,
                            content: const Text(
                              'هل أنت متأكد أنك تريد حذف المحادثة؟',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: <Widget>[
                              TextButton(
                                child: const Text('إلغاء'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('موافق'),
                                onPressed: () async {
                                  await chat.delete_chat(chatid);
                                  chathome.removeuserId(user["id"]);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "home", (route) => false);
                                },
                              ),
                            ],
                          );
                        });
                  },
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
