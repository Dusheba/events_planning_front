import 'dart:convert';
import 'package:flutter/material.dart';
import '../database.dart';

EventCategory categoryFromJson(String str) {
  final jsonData = json.decode(str);
  return EventCategory.fromJson(jsonData);
}

String categoryToJson(EventCategory data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class EventCategory {
  final int id;
  final String title;
  final String color;

  EventCategory(
      {
        required this.id, required this.title, required this.color
      }
        );
  factory EventCategory.fromJson(Map<String, dynamic> json) => new EventCategory(
      id: json["id"],
      title: json["title"],
      color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "color": color,
  };

}