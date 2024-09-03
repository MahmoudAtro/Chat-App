import 'package:chatapp/Layouts/pagewidget.dart';
import 'package:chatapp/Models/snackbar.dart';
import 'package:chatapp/Shared/user.dart';
import 'package:chatapp/provider/UserChat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final user = Supabase.instance.client;

Future<List<Map<String, dynamic>>> getuser(context) async {
  try {
    var provider = Provider.of<UserChatHome>(context);
    final userId = List<String>.from(
        (provider.usersId as List<dynamic>).map((item) => item));
    if (userId.isEmpty) {
      List<Map<String, dynamic>> users = await user
          .from("users")
          .select()
          .neq("id", UserChat.getUserId())
          .not("id", "in", userId);
      return users;
    } else {
      List<Map<String, dynamic>> users = await user
          .from("users")
          .select()
          .neq("id", UserChat.getUserId())
          .not("id", "in", userId);
      return users;
    }
  } catch (e) {
    ShowSnackbar(context, "${e}", Colors.red);
    return [];
  }
}

Future<List<Map<String, dynamic>>> getchats(context) async {
  try {
    final chats = await user
        .from("chat_user")
        .select("chat_id")
        .eq("user_id", UserChat.getUserId());
    if (chats.isEmpty) {
      return [];
    }
    final chatIds =
        List<int>.from((chats as List<dynamic>).map((item) => item['chat_id']));

    final userResponse = await user
        .from("chat_user")
        .select("user_id")
        .inFilter("chat_id", chatIds)
        .neq("user_id", UserChat.getUserId());
    final userIds = List<String>.from(
        (userResponse as List<dynamic>).map((item) => item['user_id']));
    if (userIds.isEmpty) {
      return [];
    }
    List<Map<String, dynamic>> users = await user
        .from("users")
        .select()
        .inFilter("id", userIds)
        .neq("id", UserChat.getUserId());
    return users;
  } on AuthException catch (e) {
    if (e.message.contains("ClientException with SocketException")) {
      ShowSnackbar(context, "Server Connection Error", Colors.red);
    } else {
      ShowSnackbar(context, e.message, Colors.red);
    }
    return [];
  } on PostgrestException catch (e) {
    ShowSnackbar(context, e.message, Colors.red);
    return [];
  }catch(e){
    ShowSnackbar(context, "${e}", Colors.red);
    return [];
  }
}

get_user(context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
          padding: EdgeInsets.all(15),
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              ListTile(
                onTap: () {},
                leading: CircleAvatar(
                  backgroundColor: Colors.green[900],
                  child: Icon(
                    Icons.group_add,
                    color: Colors.white,
                  ),
                ),
                title: Text('New group'),
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                onTap: () {},
                leading: CircleAvatar(
                  backgroundColor: Colors.green[900],
                  child: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                ),
                title: Text('New contact'),
              ),
              Divider(),
              Expanded(
                child: Container(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: getuser(context),
                      builder: (context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "${snapshot.hasError}",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 15.0),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return Padding(
                            padding: EdgeInsets.all(10.0),
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3 / 0.6,
                                  crossAxisSpacing: 10,
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Pagewidget(
                                      user: snapshot.data![index]);
                                }),
                          );
                        }
                        return Text("Error in show product , try again.");
                      }),
                ),
              ),
            ],
          ));
    },
  );
}
