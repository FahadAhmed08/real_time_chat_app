// import 'package:cloud_firestore/cloud_firestore.dart';

// enum MessageType { Text, Image }

// class Message {
//   String? senderID;
//   String? content;
//   MessageType? messageType;
//   Timestamp? sentAt;

//   Message({
//     required this.senderID,
//     required this.content,
//     required this.messageType,
//     required this.sentAt,
//   });

//   Message.fromJson(Map<String, dynamic> json) {
//     senderID = json['senderID'];
//     content = json['content'];
//     sentAt = json['sentAt'];
//     messageType = MessageType.values.byName(json['messageType']);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['senderID'] = senderID;
//     data['content'] = content;
//     data['sentAt'] = sentAt;
//     data['messageType'] = messageType!.name;
//     return data;
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, video } // ✅ Define enum values properly

enum MessageStatus { sent, delivered, seen }

class Message {
  String senderID;
  String content;
  MessageType messageType;
  Timestamp? sentAt;
  MessageStatus status;
  bool isSeen;

  Message({
    required this.senderID,
    required this.content,
    required this.messageType,
    required this.sentAt,
    this.status = MessageStatus.sent,
    this.isSeen = false, // Default status is "sent"
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderID: json["senderID"] ?? "",
      content: json["content"] ?? "",
      messageType: _parseMessageType(json["messageType"]),
      sentAt: json["sentAt"] ?? Timestamp.now(),
      status: _parseMessageStatus(json["status"]),
      isSeen: false,
    );
  }

  // get isSeen => null;

  Map<String, dynamic> toJson() {
    return {
      "senderID": senderID,
      "content": content,
      "messageType": messageType.index, // Store enum as index
      "sentAt": sentAt,
      "status": status.index, // Store status as index
    };
  }

  /// ✅ Safely parse `MessageType` from JSON
  static MessageType _parseMessageType(dynamic value) {
    if (value is int && value >= 0 && value < MessageType.values.length) {
      return MessageType.values[value];
    }
    return MessageType.text; // Default type
  }

  /// ✅ Safely parse `MessageStatus` from JSON
  static MessageStatus _parseMessageStatus(dynamic value) {
    if (value is int && value >= 0 && value < MessageStatus.values.length) {
      return MessageStatus.values[value];
    }
    return MessageStatus.sent; // Default status
  }
}
