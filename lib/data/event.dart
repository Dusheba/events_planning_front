import 'dart:convert';
import '../database.dart';

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
  final int categoryId;
  final String title;
  final String description;
  final String address;
  final double? budget;
  final String? startTime;
  final int ownerId;

  Event(
      {this.id,
        required this.categoryId,
        required this.title,
        required this.description,
        required this.address,
        this.budget,
        this.startTime,
        required this.ownerId}
        );

  factory Event.fromJson(Map<String, dynamic> json) => new Event(
      id: json["id"],
      categoryId: json["categoryId"],
      title: json["title"],
      description: json["description"],
      address: json["address"],
      budget: json["budget"],
      startTime: json["startTime"],
      ownerId: json["ownerId"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryId": categoryId,
    "title": title,
    "description": description,
    "address": address,
    "budget": budget,
    "startTime": startTime,
    "ownerId": ownerId
  };

}
