import 'package:events_planning/presentation/pages/notification_setting.dart';
import 'package:flutter/material.dart';
import 'package:events_planning/presentation/routes/routes.dart';




class PreferencesPage extends StatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final allowNotifications = NotificationSetting(title: 'Выбрать все предпочтения');

  final notifications = [
    NotificationSetting(title: 'Вегетарианское меню'),
    NotificationSetting(title: 'Алкоголь'),
    NotificationSetting(title: 'Музыка'),
  ];

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.deepPurple),
    home: Scaffold(
    appBar: AppBar(
      title: Text('Мои предпочтения'),
    ),
    body: ListView(
      children: [
        buildToggleCheckbox(allowNotifications),
        Divider(),
        ...notifications.map(buildSingleCheckbox).toList(),
      ],
    ),
    ),
  );

  Widget buildToggleCheckbox(NotificationSetting notification) => buildCheckbox(
      notification: notification,
      onClicked: () {
        final newValue = !notification.value;

        setState(() {
          allowNotifications.value = newValue;
          notifications.forEach((notification) {
            notification.value = newValue;
          });
        });
      });

  Widget buildSingleCheckbox(NotificationSetting notification) => buildCheckbox(
    notification: notification,
    onClicked: () {
      setState(() {
        final newValue = !notification.value;
        notification.value = newValue;

        if (!newValue) {
          allowNotifications.value = false;
        } else {
          final allow =
          notifications.every((notification) => notification.value);
          allowNotifications.value = allow;
        }
      });
    },
  );

  Widget buildCheckbox({
    required NotificationSetting notification,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(
          value: notification.value,
          onChanged: (value) => onClicked(),
        ),
        title: Text(
          notification.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}