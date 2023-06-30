import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String idFrom;
  String idTo;
  String timestamp;
  String content;

  ChatMessage(
      {required this.idFrom,
        required this.idTo,
        required this.timestamp,
        required this.content,
      }
      );

  Map<String, dynamic> toJson() {
    return {
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'content': content,
    };
  }

  factory ChatMessage.fromDocument(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    String idFrom = data['idFrom'];
    String idTo = data['idTo'];
    String timestamp = data['timestamp'];
    String content = data['content'];

    return ChatMessage(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
    );
  }
}

class ChatProvider{

  final firestore = FirebaseFirestore.instance;

  void initialize(String groupChatId, String currentUserId, Map<String, dynamic> data){
    sendChatMessage("Sent Notification\nWaiting on " + data["name"] + "...", groupChatId, currentUserId, 'system');
    print("Initializing chat");
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return firestore
        .collection('chats')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendChatMessage(String content, String groupChatId,
      String currentUserId, String peerId) {
    DocumentReference documentReference = firestore
        .collection('chats')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessage chatMessage = ChatMessage(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content);

    firestore.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessage.toJson());
    });
  }
}