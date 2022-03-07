import 'package:flutter/material.dart';
import '../database.dart';

class Preference {
  final int id;
  final String title;
  final String img;

  Preference(
      {required this.id, required this.title, required this.img});

  factory Preference.fromJson(Map<String, dynamic> json) => new Preference(
    id: json["id"],
    title: json["title"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
  };

}