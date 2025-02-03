import 'package:chat_app/models/user_profile.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;
  const ChatTile({super.key, required this.userProfile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      dense: false,
      leading: CircleAvatar(
        // backgroundImage: NetworkImage(userProfile.pfpUrl!),jb register screen se image firebase me store hogi jb hi ye bhi ai  gi
        backgroundImage: NetworkImage(
            "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6H0K0x0gDQEELOtuERO4SswW.jpg"),
      ),
      title: Text(userProfile.name!),
    );
  }
}
