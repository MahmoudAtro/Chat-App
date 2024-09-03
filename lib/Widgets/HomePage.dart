import 'package:chatapp/Layouts/chat_layout.dart';
import 'package:chatapp/Layouts/get_user.dart';
import 'package:chatapp/Layouts/pagelayout.dart';
import 'package:chatapp/Shared/user.dart';
import 'package:chatapp/provider/UserChat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserChat.init();
    getchats(context);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserChatHome>(context);
    return Pagelayout(
        ishome: true,
        ischat: false,
        isdrawer: true,
        title: "Chat App",
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getchats(context),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Column(
                        children: [
                          const Text("Something went wrong"),
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.blue,
                            child: const Text(
                              "try again",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Something went wrong"),
                          MaterialButton(
                            onPressed: () {
                              setState(() {});
                            },
                            color: Colors.blue,
                            child: const Text(
                              "try again",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    getchats(context).then((value) {
                      setState(() {});
                    });
                    return const Center(
                      child: Text("No messages"),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 1,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, index) {
                          provider.adduserid(snapshot.data![index]["id"]);
                          return ChatLayout(user: snapshot.data![index]);
                        });
                  }
                  return const Text(
                    "No Users in your Chat",
                    style: TextStyle(fontSize: 18, color: Colors.teal),
                  );
                })));
  }
}
