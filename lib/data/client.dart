import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

 static Future<List<Client>> fetchData() async {
    List<Client> clients = [];
    //var url = "http://localhost:8080/api/clients/all";
    var url = "http://10.0.2.2:8080/api/clients/all";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(response.body);
      for (var cl in res) {
        clients.add(Client.fromJson(cl));
      }
    }
    return clients;
  }

  static Future<Client?> fetchClient(int id) async {
   Client? c;
   //var url = "http://localhost:8080/api/clients/id?id=$id";
   var url = "http://10.0.2.2:8080/api/clients/id?id=$id";
   var response = await http.get(Uri.parse(url));
   if (response.statusCode==200) {
     var res = json.decode(utf8.decode(response.bodyBytes));
     c = Client.fromJson(res);
   }
   return c;
  }

  static Future<http.Response> addClient(Client client) async {
    return http.post(
        //Uri.parse("http://localhost:8080/api/client/add"),
        Uri.parse("http://10.0.2.2:8080/api/client/add"),
        headers: {"Content-Type": "application/json"},
        body: clientToJson(client)
    );
  }
 }