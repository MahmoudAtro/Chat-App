import 'package:flutter/material.dart';

class UserChatHome with ChangeNotifier {
  List usersId = [];

  ThemeData theme = ThemeData.light();
  bool isDark = false;

  adduserid(String id) {
    bool userexist = usersId.any((item) => item == id);
    if (!userexist) {
      usersId.add(id);
    }
  }

  removeuserId(String id) {
    usersId.remove(id);
    notifyListeners();
  }

  void Themetoggle() {
    if (theme == ThemeData.dark()) {
      theme = ThemeData.light();
      isDark = false;
    } else {
      theme = ThemeData.dark();
      isDark = true;
    }
    notifyListeners();
  }
}

class MessageProvider extends ChangeNotifier {
  bool write = false;
  bool isrecord = false;
  Map isPlayer = {};

  changewrite(String password) {
    if (password.length > 0 && password.length < 2) {
      setwrite(true);
    }
    if (password.length == 0) {
      setwrite(false);
    }
  }

  setwrite(bool check) {
    write = check;
    notifyListeners();
  }

  changerecord(bool event) {
    isrecord = event;
    notifyListeners();
  }

  changeplayer(bool event , index) {
    isPlayer[index] = event;
    notifyListeners();
  }
}
