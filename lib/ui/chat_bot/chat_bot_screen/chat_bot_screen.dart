import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/chat_bot/chat_bot_screen/chat_bot_screen_one.dart';
import 'package:quicklai/ui/chat_bot/chat_bot_screen/chat_bot_screen_two.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const ChatBotScreenOne() : const ChatBotScreenTwo();
  }
}
