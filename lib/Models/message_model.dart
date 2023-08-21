class MessageModel {
  String id, text, sender_id, receiver_id;
  int timestamp;

//<editor-fold desc="Data Methods">
  MessageModel({
    required this.id,
    required this.text,
    required this.sender_id,
    required this.receiver_id,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          sender_id == other.sender_id &&
          receiver_id == other.receiver_id &&
          timestamp == other.timestamp);

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ sender_id.hashCode ^ receiver_id.hashCode ^ timestamp.hashCode;

  @override
  String toString() {
    return 'MessageModel{' +
        ' id: $id,' +
        ' text: $text,' +
        ' sender_id: $sender_id,' +
        ' receiver_id: $receiver_id,' +
        ' timestamp: $timestamp,' +
        '}';
  }

  MessageModel copyWith({
    String? id,
    String? text,
    String? sender_id,
    String? receiver_id,
    int? timestamp,
  }) {
    return MessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sender_id: sender_id ?? this.sender_id,
      receiver_id: receiver_id ?? this.receiver_id,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'text': this.text,
      'sender_id': this.sender_id,
      'receiver_id': this.receiver_id,
      'timestamp': this.timestamp,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      text: map['text'] as String,
      sender_id: map['sender_id'] as String,
      receiver_id: map['receiver_id'] as String? ?? "",
      timestamp: map['timestamp'] as int,
    );
  }

//</editor-fold>
}