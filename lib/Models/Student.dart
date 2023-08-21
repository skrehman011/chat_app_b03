class Student {
  String id, email, password, name;
  int age;
  String? token;

  factory Student.formMap(Map<String, dynamic> data){
    return Student(
      id: data['id'] as String,
      email:data ['email'] as String,
      password:data ['password'] as String,
      name:data ['name'] as String,
      age: data['age'] as int,
    );
  }

//<editor-fold desc="Data Methods">
  Student({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    this.token,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          password == other.password &&
          name == other.name &&
          age == other.age &&
          token == other.token);

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ password.hashCode ^ name.hashCode ^ age.hashCode ^ token.hashCode;

  @override
  String toString() {
    return 'Student{' + ' id: $id,' + ' email: $email,' + ' password: $password,' + ' name: $name,' + ' age: $age,' + ' token: $token,' + '}';
  }

  Student copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    int? age,
    String? token,
  }) {
    return Student(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      age: age ?? this.age,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'password': this.password,
      'name': this.name,
      'age': this.age,
      'token': this.token,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      token: map['token'] as String? ?? "",
    );
  }

//</editor-fold>
}
