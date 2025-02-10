// // import 'dart:io';

// import 'package:chat_app/models/chat.dart';
// import 'package:chat_app/models/message.dart';
// import 'package:chat_app/models/user_profile.dart';
// import 'package:chat_app/services/auth_service.dart';
// import 'package:chat_app/services/database_service.dart';
// import 'package:chat_app/services/media_service.dart';
// // import 'package:chat_app/services/storage_service.dart';
// // import 'package:chat_app/utils.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';

// class ChatPage extends StatefulWidget {
//   final UserProfile chatUser;

//   const ChatPage({
//     super.key,
//     required this.chatUser,
//   });

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final GetIt _getIt = GetIt.instance;
//   late AuthService _authService;
//   late DatabaseService _databaseService;
//   late MediaService _mediaService;
//   // late StorageService _storageService;

//   ChatUser? currentUser, otherUser;

//   @override
//   void initState() {
//     super.initState();
//     try {
//       _authService = _getIt.get<AuthService>();
//       _databaseService = _getIt.get<DatabaseService>();
//       _mediaService = _getIt.get<MediaService>();
//       // _storageService = _getIt.get<StorageService>();

//       if (_authService.user == null || widget.chatUser.uid == null) {
//         throw Exception("User data is missing");
//       }

//       currentUser = ChatUser(
//         id: _authService.user!.uid,
//         firstName: _authService.user!.displayName ?? "Unknown",
//       );
//       otherUser = ChatUser(
//         id: widget.chatUser.uid!,
//         firstName: widget.chatUser.name ?? "Unknown",
//         profileImage: widget.chatUser.pfpUrl,
//       );
//     } catch (e) {
//       debugPrint("Error initializing ChatPage: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.chatUser.name ?? "Chat"),
//       ),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     if (currentUser == null || otherUser == null) {
//       return Center(child: Text("Error loading chat"));
//     }

//     return StreamBuilder<DocumentSnapshot<Chat>>(
//       stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data?.data() == null) {
//           return Center(child: Text("No messages yet"));
//         }

//         Chat? chat = snapshot.data?.data();
//         List<ChatMessage> messages =
//             _generateChatMessagesList(chat?.messages ?? []);

//         return DashChat(
//           messageOptions: const MessageOptions(
//             showOtherUsersAvatar: true,
//             showTime: true,
//           ),
//           inputOptions: InputOptions(alwaysShowSend: true, trailing: [
//             _mediaMessageButton(),
//           ]),
//           currentUser: currentUser!,
//           onSend: _sendMessage,
//           messages: messages,
//         );
//       },
//     );
//   }

//   Future<void> _sendMessage(ChatMessage chatMessage) async {
//     try {
//       if (chatMessage.medias?.isNotEmpty ?? false) {
//         if (chatMessage.medias!.first.type == MediaType.image) {
//           Message message = Message(
//             senderID: chatMessage.user.id,
//             content: chatMessage.medias!.first.url,
//             messageType: MessageType.Image,
//             sentAt: Timestamp.fromDate(chatMessage.createdAt),
//           );
//           await _databaseService.sendChatMessage(
//               currentUser!.id, otherUser!.id, message);
//         }
//       } else {
//         Message message = Message(
//           senderID: currentUser!.id,
//           content: chatMessage.text,
//           messageType: MessageType.Text,
//           sentAt: Timestamp.fromDate(chatMessage.createdAt),
//         );
//         await _databaseService.sendChatMessage(
//             currentUser!.id, otherUser!.id, message);
//       }
//     } catch (e) {
//       debugPrint("Error sending message: $e");
//     }
//   }

//   List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
//     try {
//       List<ChatMessage> chatMessages = messages.map((m) {
//         if (m.messageType == MessageType.Image) {
//           return ChatMessage(
//             user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
//             createdAt: m.sentAt!.toDate(),
//             medias: [
//               ChatMedia(
//                 url: m.content!,
//                 fileName: "",
//                 type: MediaType.image,
//               )
//             ],
//           );
//         } else {
//           return ChatMessage(
//             user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
//             text: m.content!,
//             createdAt: m.sentAt!.toDate(),
//           );
//         }
//       }).toList();
//       chatMessages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//       return chatMessages;
//     } catch (e) {
//       debugPrint("Error generating chat messages: $e");
//       return [];
//     }
//   }

//   Widget _mediaMessageButton() {
//     return IconButton(
//       onPressed: () async {
//         try {
//           await _mediaService.getImageFromGallery();
//           /* File? file = await _mediaService.getImageFromGallery();
//           if (file != null) {
//             String chatID = generateChatID(
//               uid1: currentUser!.id,
//               uid2: otherUser!.id,
//             );
//             String? downloadURl = await _storageService.uploadImageToChat(
//                 file: file, chatId: chatID);
//             if (downloadURl != null) {
//               ChatMessage chatMessage = ChatMessage(
//                   user: currentUser!,
//                   createdAt: DateTime.now(),
//                   medias: [
//                     ChatMedia(
//                         url: downloadURl, fileName: "", type: MediaType.image)
//                   ]);
//               _sendMessage(chatMessage);
//             }
//           } */
//         } catch (e) {
//           debugPrint("Error selecting media: $e");
//         }
//       },
//       icon: Icon(
//         Icons.image,
//         color: Theme.of(context).colorScheme.primary,
//       ),
//     );
//   }
// }

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/media_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;
  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseService _databaseService;
  late MediaService _mediaService;

  ChatUser? currentUser, otherUser;
  bool isTyping = false;
  Timer? typingTimer;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _mediaService = _getIt.get<MediaService>();

    if (_authService.user == null || widget.chatUser.uid == null) {
      throw Exception("User data is missing");
    }

    currentUser = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.displayName ?? "Unknown",
    );
    otherUser = ChatUser(
      id: widget.chatUser.uid!,
      firstName: widget.chatUser.name ?? "Unknown",
      profileImage: widget.chatUser.pfpUrl,
    );

    _databaseService
        .getTypingStatus(otherUser!.id, currentUser!.id)
        .listen((bool typingStatus) {
      setState(() {
        isTyping = typingStatus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatUser.name ?? "Chat"),
            if (isTyping)
              const Text(
                "Typing...",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder<DocumentSnapshot<Chat>>(
      stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return Center(child: Text("No messages yet"));
        }

        Chat? chat = snapshot.data?.data();
        List<ChatMessage> messages =
            _generateChatMessagesList(chat?.messages ?? []);

        _markMessagesAsSeen(chat?.messages ?? [], chat!.id);

        return DashChat(
          messageOptions: MessageOptions(
            showOtherUsersAvatar: true,
            showTime: true,
          ),
          inputOptions: InputOptions(
            alwaysShowSend: true,
            onTextChange: _handleTyping,
            trailing: [_mediaMessageButton()],
          ),
          currentUser: currentUser!,
          onSend: _sendMessage,
          messages: messages,
        );
      },
    );
  }

  void _handleTyping(String text) {
    if (text.isNotEmpty) {
      _databaseService.updateTypingStatus(currentUser!.id, otherUser!.id, true);
      typingTimer?.cancel();
      typingTimer = Timer(const Duration(seconds: 2), () {
        _databaseService.updateTypingStatus(
            currentUser!.id, otherUser!.id, false);
      });
    } else {
      _databaseService.updateTypingStatus(
          currentUser!.id, otherUser!.id, false);
    }
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    try {
      Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
        isSeen: false,
      );
      await _databaseService.sendChatMessage(
          currentUser!.id, otherUser!.id, message);
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  void _markMessagesAsSeen(List<Message> messages, String chatID) {
    for (var message in messages) {
      if ((message.isSeen ?? false) == false &&
          message.senderID != currentUser!.id) {
        _databaseService.updateMessageStatusToSeen(chatID, currentUser!.id);
      }
    }
  }

  List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
    return messages.map((m) {
      return ChatMessage(
        user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
        text: m.content!,
        createdAt: m.sentAt!.toDate(),
        customProperties: {
          "isSeen": m.isSeen,
        },
      );
    }).toList();
  }

  Widget _mediaMessageButton() {
    return IconButton(
      onPressed: () async {
        await _mediaService.getImageFromGallery();
      },
      icon: Icon(Icons.image, color: Theme.of(context).colorScheme.primary),
    );
  }
}
