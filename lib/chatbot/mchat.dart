class Mchat {
  final String msg;
  final int chatIndex;

  Mchat({required this.msg, required this.chatIndex});

  factory  Mchat.fromJson(Map<String, dynamic> json) =>  Mchat(
    msg: json["msg"],
    chatIndex: json["chatIndex"],
  );
}
