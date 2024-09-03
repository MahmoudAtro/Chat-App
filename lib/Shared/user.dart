import 'package:shared_preferences/shared_preferences.dart';

class UserChat {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static setup(Map user , String id) async {
    await init();
    setIsLogin(true);
    await userUsername(user["name"] ?? "");
    await userEmail(user["email"] ?? "");
    await userImage(user["img"] ?? "");
    await UserBio(user["bio"] ?? "");
    await UserId(id);
  }

  static setIsLogin(bool islogin) async {
    await prefs.setBool('islogin', islogin);
  }

  static UserId(String id)
  async{
    await prefs.setString('id', id);
  }

  static userEmail(String email) async {
    await prefs.setString('email', email);
  }

  static userUsername(String username) async {
    await prefs.setString('username', username);
  }

  static String getUserEmail() {
    return prefs.getString('email') ?? "User@email.com";
  }

  static String getUserUsername() {
    return prefs.getString('username') ?? "User";
  }

  static bool getIsLogin() {
    return prefs.getBool('islogin') ?? false;
  }

  static UserBio(String bio)async{
    await prefs.setString('bio', bio);
  }

  static userImage(String img) async{
    await prefs.setString("img", img);
  }

  static String? getuserImage(){
    return prefs.getString("img") ?? "";
  }

  static String getUserbio(){
    return prefs.getString('bio') ?? "Chat User";
  }

  static String getUserId(){
    return prefs.getString("id") ?? "";
  }

  static logout() async{
    await prefs.clear();
  }
}
