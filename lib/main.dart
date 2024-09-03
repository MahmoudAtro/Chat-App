import 'package:chatapp/Auth/home_auth.dart';
import 'package:chatapp/Auth/login.dart';
import 'package:chatapp/Auth/register.dart';
import 'package:chatapp/Auth/restpassword.dart';
import 'package:chatapp/Auth/updateuser.dart';
import 'package:chatapp/Widgets/HomePage.dart';
import 'package:chatapp/Widgets/profile.dart';
import 'package:chatapp/Widgets/setting.dart';
import 'package:chatapp/Widgets/start.dart';
import 'package:chatapp/provider/UserChat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  Supabase.initialize(
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhkd2VkYmF3cm9hZnphcWJjaW1vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ0MDIxNDUsImV4cCI6MjAzOTk3ODE0NX0.JX4FFHaw8OfaIDT7mtFhxQ8jSJfGVXRROVezVLPugng",
      url: "https://hdwedbawroafzaqbcimo.supabase.co");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserChatHome()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final user = Supabase.instance.client.auth.currentSession;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserChatHome>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: provider.theme,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        textTheme: TextTheme(
          bodyLarge:
              TextStyle(color: Colors.teal), // لون النصوص في الوضع المظلم
        ),
      ),
      title: "Chat App",
      initialRoute: "start",
      routes: {
        "home": (_) => const Homepage(),
        "login": (_) => Login(),
        "register": (_) => Register(),
        "auth": (_) => const HomeAuth(),
        "profile": (_) => Profile(),
        "setting": (_) => const Setting(),
        "updateuser": (_) => UpdateProfile(),
        "start" : (_) => const Start(),
        "rest" : (_) => RestPassword(),
      },
    );
  }
}
