import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromJson(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Client {
  int? id;
  String name;
  String username;
  String pass;
  String phone;
  String email;
  String social;

  Client({
    this.id,
    required this.name,
    required this.username,
    required this.pass,
    required this.phone,
    required this.email,
    required this.social
  });

  factory Client.fromJson(Map<String, dynamic> json) => new Client(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    pass: json["pass"],
    phone: json["phone"],
    email: json["email"],
    social: json["social"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "pass": pass,
    "phone": phone,
    "email": email,
    "social": social
  };

}