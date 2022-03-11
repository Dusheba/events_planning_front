import 'dart:convert';
import 'package:events_planning/data/client.dart';
import 'package:events_planning/data/entities.dart';
import 'package:http/http.dart' as http;

Event eventFromJson(String str) {
  final jsonData = json.decode(str);
  return Event.fromJson(jsonData);
}

String eventToJson(Event event) {
  final dyn = event.toJson();
  return json.encode(dyn);
}

class Event {
  final int? id;
  final EventCategory category;
  final String title;
  final String description;
  final String address;
  final double? budget;
  final DateTime? startTime;
  final Client owner;

  Event(
      {this.id,
        required this.category,
        required this.title,
        required this.description,
        required this.address,
        this.budget,
        this.startTime,
        required this.owner}
        );

  factory Event.fromJson(Map<String, dynamic> json) => new Event(
      id: json["id"],
      category: EventCategory.fromJson(json["category"]),
      title: json["title"],
      description: json["description"],
      address: json["address"],
      budget: json["budget"],
      startTime: DateTime.fromMillisecondsSinceEpoch(json["startTime"]),
      owner: Client.fromJson(json["owner"])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "title": title,
    "description": description,
    "address": address,
    "budget": budget,
    "startTime": startTime,
    "owner": owner
  };

  static Future<List<Event>> fetchData(int id) async {
    List<Event> events = [];
    var url = "http://10.0.2.2:8080/api/events/owner?owner=$id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      for (var cl in res) {
        events.add(Event.fromJson(cl));
      }
    }
    return events;
  }

  static Future<List<Event>> fetchEventByCat(int id) async {
    List<Event> events = [];
    var url = "http://10.0.2.2:8080/api/events/categoty?category=$id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      for (var cl in res) {
        events.add(Event.fromJson(cl));
      }
    }
    return events;
  }

  static Future<int> fetchNumber(int id) async {
    List<Event> events = [];
    var url = "http://10.0.2.2:8080/api/events/categoty?category=$id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      for (var cl in res) {
        events.add(Event.fromJson(cl));
      }
    }
    return events.length;
  }
}
