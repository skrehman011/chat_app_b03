import 'dart:convert';

import 'message_model.dart';

class RoomInfo {
  String id, name;
  MessageModel? lastMessage;
  List<String> participants;
  String roomType; //group, chat

//<editor-fold desc="Data Methods">
  RoomInfo({
    required this.id,
    required this.name,
    this.lastMessage,
    required this.participants,
    required this.roomType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomInfo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          lastMessage == other.lastMessage &&
          participants == other.participants &&
          roomType == other.roomType);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      lastMessage.hashCode ^
      participants.hashCode ^
      roomType.hashCode;

  @override
  String toString() {
    return 'RoomInfo{' +
        ' id: $id,' +
        ' name: $name,' +
        ' lastMessage: $lastMessage,' +
        ' participants: $participants,' +
        ' roomType: $roomType,' +
        '}';
  }

  RoomInfo copyWith({
    String? id,
    String? name,
    MessageModel? lastMessage,
    List<String>? participants,
    String? roomType,
  }) {
    return RoomInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      participants: participants ?? this.participants,
      roomType: roomType ?? this.roomType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'lastMessage': jsonEncode(this.lastMessage?.toMap()),
      'participants': this.participants,
      'roomType': this.roomType,
    };
  }

  factory RoomInfo.fromMap(Map<String, dynamic> map) {
    return RoomInfo(
      id: map['id'] as String,
      name: map['name'] as String,
      lastMessage: getMessageModel(map['lastMessage'] as String?),
      participants: (map['participants'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      roomType: map['roomType'] as String
    );
  }

//</editor-fold>
}

MessageModel? getMessageModel(String? data) {
  if (data == null) {
    return null;
  }

  return MessageModel.fromMap(jsonDecode(data) as Map<String, dynamic>);
}
