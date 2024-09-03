import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chatapp/Layouts/get_user.dart';
import 'package:chatapp/Shared/user.dart';
import 'package:chatapp/Widgets/chat_details.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path/path.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chatapp/Shared/textdecoration.dart';
import 'package:chatapp/Supabase/Chats.dart';
import 'package:chatapp/provider/UserChat.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class Chatlayout extends StatefulWidget {
  Chatlayout({super.key, required this.userchat});
  final Map userchat;
  final user_send = UserChat.getUserId();

  @override
  State<Chatlayout> createState() => _ChatlayoutState();
}

class _ChatlayoutState extends State<Chatlayout> {
  var image;
  String url = "";
  String path = "";
  final record = AudioRecorder();
  String urlrecord = "";
  String pathrecord = "";
  late AudioPlayer audioPlayer;
  final _key = GlobalKey<FormState>();

  start_record() async {
    try {
      final location = await getApplicationCacheDirectory();
      String name = const Uuid().v1();
      if (await record.hasPermission()) {
        await record.start(const RecordConfig(),
            path: location.path + name + '.m4a');
      }
    } catch (e) {
      print(e);
    }
  }

  stoprecord() async {
    String? fianlpath = await record.stop();
    setState(() {
      pathrecord = fianlpath.toString();
    });
    uploadrecord();
  }

  uploadrecord() async {
    try {
      var voice = File(pathrecord);
      String pathr = basename(pathrecord);
      await supabase.storage.from("voice").upload(pathr, voice);
      urlrecord = supabase.storage.from("voice").getPublicUrl(pathr);
      await chat.send_message(
          widget.user_send, chatid.toString(), urlrecord, "voice");
    } catch (e) {
      print(e);
    }
  }

  play(urlvoice) async {
    try {
      audioPlayer.play(UrlSource(urlvoice));
    } catch (e) {
      print(e);
    }
  }

  stop() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      print(e);
    }
  }

  SupabaseClient supabase = Supabase.instance.client;
  Stream get_chat(String chat_id) async* {
    yield* Supabase.instance.client
        .from("message")
        .stream(primaryKey: ['id'])
        .eq("chat_id", chat_id)
        .order("created_at", ascending: false)
        .limit(20);
  }

  chooseimage(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: ((context) {
          return Container(
            alignment: Alignment.center,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    uploadfromgallery(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.grey[850],
                        size: 25,
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(color: Colors.grey[850], fontSize: 22),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 60,
                ),
                InkWell(
                  onTap: () {
                    uploadfromcamera(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.grey[850],
                        size: 25,
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(color: Colors.grey[850], fontSize: 22),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }));
  }

  showimage(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 400,
              padding: const EdgeInsets.all(20.0),
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  Image(
                    image: FileImage(image),
                    width: 500,
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 200,
                    child: MaterialButton(
                      onPressed: () {
                        upload();
                        Navigator.pop(context);
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Send",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  uploadfromgallery(context) async {
    final pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (pickedImg != null) {
        image = File(pickedImg.path);
        Navigator.pop(context);
        showimage(context);
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  uploadfromcamera(context) async {
    final pickedImg = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      if (pickedImg != null) {
        image = File(pickedImg.path);
        Navigator.pop(context);
        showimage(context);
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  upload() async {
    if (image != null) {
      try {
        path = generateUniqueFileName(basename(image.path));
        await supabase.storage.from("image_chat").upload(path, image);
        url = supabase.storage.from("image_chat").getPublicUrl(path);
        await chat.send_message(
            widget.user_send, chatid.toString(), url, "img");
      } catch (e) {
        print(e);
      }
    }
  }

  String generateUniqueFileName(String originalFileName) {
    var uuid = const Uuid();
    var fileExtension = originalFileName.split('.').last;
    return '${uuid.v4()}.$fileExtension';
  }

  Chats chat = Chats();
  int? chatid;
  getChatId() async {
    try {
      final chat1 = await Supabase.instance.client
          .from("chat_user")
          .select("chat_id")
          .eq("user_id", widget.user_send);

      if (chat1.isEmpty) {
        return [];
      }
      final chatIds1 = List<int>.from(
          (chat1 as List<dynamic>).map((item) => item['chat_id'] as int));

      final chat2 = await Supabase.instance.client
          .from("chat_user")
          .select("chat_id")
          .eq("user_id", widget.userchat["id"]);
      if (chat2.isEmpty) {
        return [];
      }
      final chatIds2 = List<int>.from(
          (chat2 as List<dynamic>).map((item) => item['chat_id'] as int));

      List<int> chatid =
          chatIds1.toSet().intersection(chatIds2.toSet()).toList();
      return chatid[0];
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadchatid();
    get_chat(chatid.toString());
    audioPlayer = AudioPlayer();
  }

  Future<void> loadchatid() async {
    try {
      int id = await getChatId();
      chatid = id;
    } catch (e) {
      print(e);
    }
  }

  final message = TextEditingController();
  bool iswrite = false;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserChatHome>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatDetails(
                          user: widget.userchat,
                          chatid: chatid.toString(),
                        )));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: widget.userchat["img"] == null
                      ? Image.asset(
                          "images/userimage.jpeg",
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        )
                      : Image.network(
                          widget.userchat["img"],
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        )),
              const SizedBox(
                width: 2,
              ),
              Text(
                widget.userchat["name"] ?? "User Chat",
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0.0,
        actions: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.call), onPressed: () {}),
              PopupMenuButton<String>(
                onSelected: (String value) {},
                itemBuilder: (BuildContext context) {
                  return ['refresh', 'delete'].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: provider.isDark
                    ? const AssetImage("images/chat-dark.jpeg")
                    : const AssetImage("images/chat-white.jpeg"),
                fit: BoxFit.cover,
                opacity: 0.2),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: StreamBuilder(
                      stream: get_chat(chatid.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          return ListView.builder(
                              reverse: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (contaxt, index) {
                                if (snapshot.data![index]["is_read"] == false) {
                                  if (widget.user_send !=
                                      snapshot.data![index]["sender_id"]) {
                                    try {
                                      chat.updatemessage(snapshot.data![index]
                                              ["id"]
                                          .toString());
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                }
                                return snapshot.data![index]["kind"] == "text"
                                    ? Slidable(
                                        endActionPane: ActionPane(
                                          motion: StretchMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) async {
                                                await chat.DeleteMessage(
                                                    snapshot.data![index]["id"]
                                                        .toString());
                                              },
                                              icon: Icons.delete,
                                              backgroundColor: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ],
                                        ),
                                        child: BubbleSpecialThree(
                                          text:
                                              '${snapshot.data![index]["content"]}',
                                          color: snapshot.data![index]
                                                      ["sender_id"] ==
                                                  widget.user_send
                                              ? const Color(0xFF1B97F3)
                                              : Colors.green,
                                          tail: false,
                                          sent: true,
                                          seen: snapshot.data![index]["is_read"]
                                              ? true
                                              : false,
                                          isSender: snapshot.data![index]
                                                      ["sender_id"] ==
                                                  widget.user_send
                                              ? true
                                              : false,
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      )
                                    : snapshot.data![index]["kind"] == "img"
                                        ? Slidable(
                                            endActionPane: ActionPane(
                                              motion: StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (context) async {
                                                    await chat.DeleteImage(
                                                        snapshot.data![index]
                                                            ["content"]);
                                                    await chat.DeleteMessage(
                                                        snapshot.data![index]
                                                                ["id"]
                                                            .toString());
                                                  },
                                                  icon: Icons.delete,
                                                  backgroundColor: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ],
                                            ),
                                            child: BubbleNormalImage(
                                              id: index.toString(),
                                              image: Image(
                                                  image: NetworkImage(
                                                      "${snapshot.data![index]["content"]}")),
                                              color: snapshot.data![index]
                                                          ["sender_id"] ==
                                                      widget.user_send
                                                  ? const Color(0xFF1B97F3)
                                                  : Colors.green,
                                              tail: false,
                                              sent: true,
                                              seen: snapshot.data![index]
                                                      ["is_read"]
                                                  ? true
                                                  : false,
                                              isSender: snapshot.data![index]
                                                          ["sender_id"] ==
                                                      widget.user_send
                                                  ? true
                                                  : false,
                                            ),
                                          )
                                        : Consumer<MessageProvider>(builder:
                                            (context, chatlayout, child) {
                                            if (chatlayout.isPlayer[snapshot
                                                    .data![index]["id"]] ==
                                                null) {
                                              chatlayout.isPlayer[snapshot
                                                  .data![index]["id"]] = false;
                                            }

                                            print(chatlayout.isPlayer[
                                                snapshot.data![index]["id"]]);

                                            return Slidable(
                                              endActionPane: ActionPane(
                                                motion: StretchMotion(),
                                                children: [
                                                  SlidableAction(
                                                    onPressed: (context) async {
                                                      await chat.DeleteVoice(
                                                          snapshot.data![index]
                                                              ["content"]);
                                                      await chat.DeleteMessage(
                                                          snapshot.data![index]
                                                                  ["id"]
                                                              .toString());
                                                    },
                                                    icon: Icons.delete,
                                                    backgroundColor: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ],
                                              ),
                                              child: BubbleNormalAudio(
                                                isPlaying: chatlayout.isPlayer[
                                                        snapshot.data![index]
                                                            ["id"]] ??
                                                    false,
                                                onSeekChanged: (e) {},
                                                onPlayPauseButtonClick:
                                                    () async {
                                                  if (!chatlayout.isPlayer[
                                                      snapshot.data![index]
                                                          ["id"]]) {
                                                    await play(
                                                        snapshot.data![index]
                                                            ["content"]);
                                                    chatlayout.changeplayer(
                                                        true,
                                                        snapshot.data![index]
                                                            ["id"]);
                                                  } else {
                                                    await stop();
                                                    chatlayout.changeplayer(
                                                        false,
                                                        snapshot.data![index]
                                                            ["id"]);
                                                  }
                                                },
                                                color: snapshot.data![index]
                                                            ["sender_id"] ==
                                                        widget.user_send
                                                    ? const Color(0xFF1B97F3)
                                                    : Colors.green,
                                                tail: false,
                                                sent: true,
                                                seen: snapshot.data![index]
                                                        ["is_read"]
                                                    ? true
                                                    : false,
                                                isSender: snapshot.data![index]
                                                            ["sender_id"] ==
                                                        widget.user_send
                                                    ? true
                                                    : false,
                                              ),
                                            );
                                          });
                              });
                        }
                        if (snapshot.connectionState == ConnectionState.none) {
                          return Center(
                            child: Text("Check your internet"),
                          );
                        }

                        if (!snapshot.hasData) {
                          getchats(context).then((vlaue) {
                            setState(() {});
                          });
                          return const Center(
                            child: Text("No messages"),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "${snapshot.error}",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 15.0),
                            ),
                          );
                        }

                        return Text("data");
                      },
                    ),
                  ),
                ),
                ConsumerChange(),
              ])),
    ));
  }

  Widget ConsumerChange() {
    return Consumer<MessageProvider>(
      builder: (context, chatlayout, child) {
        return Row(children: [
          Expanded(
              child: Form(
                  key: _key,
                  child: TextFormField(
                    autofocus: true,
                    controller: message,
                    onChanged: chatlayout.changewrite,
                    decoration: userdecoration.copyWith(
                      hintText: "Type a message",
                      prefixIcon: IconButton(
                          onPressed: () {
                            chooseimage(context);
                          },
                          icon: const Icon(Icons.add)),
                    ),
                  ))),
          chatlayout.write
              ? IconButton(
                  onPressed: () async {
                    await chat.send_message(widget.user_send, chatid.toString(),
                        message.text, "text");
                    _key.currentState!.reset();
                    message.clear();
                    chatlayout.changewrite("");
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.teal[600],
                  ))
              : IconButton(
                  onPressed: () async {
                    if (!chatlayout.isrecord) {
                      chatlayout.changerecord(true);
                      await start_record();
                    } else {
                      chatlayout.changerecord(false);
                      await stoprecord();
                    }
                  },
                  icon: Icon(
                    chatlayout.isrecord ? Icons.stop : Icons.mic,
                    color: Colors.teal[600],
                  ),
                )
        ]);
      },
    );
  }
}
