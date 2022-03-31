import 'package:meta/meta.dart';

class NotificationSetting {
  String title;
  bool value;
  int id;

  NotificationSetting({
    required this.title,
    this.value = false, required this.id
  });
}