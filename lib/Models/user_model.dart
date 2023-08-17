class UserModel {
  String id;
  String token;

//<editor-fold desc="Data Methods">
  UserModel({
    required this.id,
    required this.token,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          token == other.token);

  @override
  int get hashCode => id.hashCode ^ token.hashCode;

  @override
  String toString() {
    return 'UserModel{' + ' id: $id,' + ' token: $token,' + '}';
  }

  UserModel copyWith({
    String? id,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'token': this.token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      token: map['token'] as String,
    );
  }

//</editor-fold>
}