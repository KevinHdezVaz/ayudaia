class Chat {
  String? msg;
  String? chat;
  bool? active;

  Chat({required this.msg, required this.chat, this.active});

  Chat.fromJson(Map<String, dynamic> json) {
    chat = json['chat'];
    msg = json['msg'];
    active = json['active'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat'] = chat;
    data['msg'] = msg;
    data['active'] = active ?? false;
    return data;
  }
}
