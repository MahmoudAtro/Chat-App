import 'package:chatapp/Layouts/pagelayout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/UserChat.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Pagelayout(
      title: "Setting",
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
                title: Text(
                  "Dark mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("enable dark mode for Chat"),
                trailing: Consumer<UserChatHome>(
                  builder: (context, chathome, child) {
                    return Switch(
                      value: chathome.isDark,
                      onChanged: (value) {
                        chathome.Themetoggle();
                        setState(() {});
                      },
                      activeColor: Colors.green,
                    );
                  },
                ))
          ],
        ),
      ),
      isdrawer: false,
      ischat: false,
      ishome: false,
    );
  }
}
