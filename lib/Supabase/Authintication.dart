import 'package:supabase_flutter/supabase_flutter.dart';

class Authintication {
  SupabaseClient client = Supabase.instance.client;

  SignUp(final String email, final String password, final String name) async {
    var response = client.auth
        .signUp(email: email, password: password, data: {"name": name});
    return response;
  }

  SignIn(String email, String password) async {
    var response =
        client.auth.signInWithPassword(email: email, password: password);
    return response;
  }

  Logout() async {
    var response = await client.auth.signOut();
    return response;
  }

  UpdateUser(final String email, final String name, final String img,
      final String bio) async {
    var response =
        await client.auth.updateUser(UserAttributes(email: email, data: {
      "name": name,
      "img": img,
      "bio": bio,
    }));
    return response;
  }

  RestEmail(String email) async {
    var response = await client.auth.resend(type: OtpType.signup, email: email);

    return response;
  }

  RestPassword(String email) async{
    var response = await client.auth.resetPasswordForEmail(email);

    return response;
  }
}
