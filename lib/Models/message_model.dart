class MessageModel {
  String id;
  String text;
  String sender_id;
  DateTime time;

  MessageModel({required this.id , required this.text, required this.sender_id, required this.time});
}