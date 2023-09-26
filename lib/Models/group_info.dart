import 'dart:convert';

import 'message_model.dart';

class RoomInfo {
  String id, name;
  MessageModel? lastMessage;
  List<String> participants;
  String groupAdmin;
  String roomType;

//<editor-fold desc="Data Methods">

  RoomInfo({
    required this.id,
    required this.name,
    this.lastMessage,
    required this.participants,
    required this.groupAdmin,
    required this.roomType,
  });

//gro@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is RoomInfo &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              lastMessage == other.lastMessage &&
              participants == other.participants &&
              groupAdmin == other.groupAdmin &&
              roomType == other.roomType
          );


  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      lastMessage.hashCode ^
      participants.hashCode ^
      groupAdmin.hashCode ^
      roomType.hashCode;


  @override
  String toString() {
    return 'RoomInfo{' +
        ' id: $id,' +
        ' name: $name,' +
        ' lastMessage: $lastMessage,' +
        ' participants: $participants,' +
        ' groupAdmin: $groupAdmin,' +
        ' roomType: $roomType,' +
        '}';
  }


  RoomInfo copyWith({
    String? id,
    String? name,
    MessageModel? lastMessage,
    List<String>? participants,
    String? groupAdmin,
    String? roomType,
  }) {
    return RoomInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      participants: participants ?? this.participants,
      groupAdmin: groupAdmin ?? this.groupAdmin,
      roomType: roomType ?? this.roomType,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'lastMessage': this.lastMessage,
      'participants': this.participants,
      'groupAdmin': this.groupAdmin,
      'roomType': this.roomType,
    };
  }

  factory RoomInfo.fromMap(Map<String, dynamic> map) {
    return RoomInfo(
      id: map['id'] as String,
      name: map['name'] as String,
      lastMessage: map['lastMessage'] as MessageModel,
      participants: map['participants'] as List<String>,
      groupAdmin: map['groupAdmin'] as String,
      roomType: map['roomType'] as String,
    );
  }


  //</editor-fold>


//<editor-fold desc="Data Methods">

}