import 'package:supabase_flutter/supabase_flutter.dart';

class Chats {
  final client = Supabase.instance.client;

  create_chat(String user1_id, String user2_id) async {
    var chat =
        await client.from("chats").insert({"name": null}).select().single();
    await client.from("chat_user").insert([
      {"user_id": user1_id, "chat_id": chat['id']},
      {"user_id": user2_id, "chat_id": chat['id']},
    ]);
    final response = chat['id'];
    return response;
  }

  send_message(
      String user1_id, String chat_id, String content, String kind) async {
    try{
      await client.from("message").insert({
      "chat_id": chat_id,
      "sender_id": user1_id,
      "content": content,
      "kind": kind
    });
    }catch(e){
      print(e);
    }
  }

  Stream get_message(String chat_id) {
    return client
        .from("message")
        .stream(primaryKey: ['id'])
        .eq("chat_id", chat_id)
        .order("created_at", ascending: false)
        .limit(20);
  }

  delete_chat(String chatid) async {
    await client.from("chats").delete().eq("id", chatid);
  }

  Future updatemessage(String id) async {
    await client.from("message").update({"is_read": true}).eq("id", id);
  }

  Future DeleteMessage(String id) async {
    await client.from("message").delete().eq("id", id);
  }

  Future DeleteImage(String url) async {
    print("message_delete");
    final Uri urlobject = Uri.parse(url);
    final filepath = urlobject.pathSegments.last;
    client.storage.from("image_chat").remove([filepath]);
  }

  Future DeleteVoice(String url) async {
    final Uri urlobject = Uri.parse(url);
    final filepath = urlobject.pathSegments.last;
    client.storage.from("voice").remove([filepath]);
  }

//   Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
//   final stream = Supabase.instance.client
//       .from('message')
//       .stream(primaryKey: ['id'])
//       .eq('chat_id', chatId)
//       .order('created_at', ascending: false)
//       .limit(20);

//   return stream.asyncMap((data) {
//     // تصفية البيانات الفارغة
//     final nonEmptyData = (data as List<dynamic>)
//         .where((item) => item != null)
//         .cast<Map<String, dynamic>>()
//         .toList();

//     // إرجاع بيانات فارغة إذا لم تكن هناك بيانات
//     return nonEmptyData.isNotEmpty ? nonEmptyData : [];
//   });
// }
}
