class Student {
  String id, email, password, name;
  int age;

  Student({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.age,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'age': age,
    };
  }

  factory Student.formMap(Map<String, dynamic> data){
    return Student(
      id: data['id'] as String,
      email:data ['email'] as String,
      password:data ['password'] as String,
      name:data ['name'] as String,
      age: data['age'] as int,
    );
  }
}
