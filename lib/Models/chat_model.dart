import 'package:chatapp/Models/usermodel.dart';

class ChatModel {
  String id;
  List<User_Model> users =[];
  List userid = [];
  List chats = [];

  ChatModel({required this.chats , required this.users , required this.id ,required this.userid});
}