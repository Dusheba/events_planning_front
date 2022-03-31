import 'package:events_planning/data/client.dart';
import 'package:events_planning/data/preference.dart';
import 'package:events_planning/presentation/pages/notification_setting.dart';
import 'package:events_planning/presentation/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:events_planning/presentation/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';




class PreferencesPage extends StatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final allowNotifications = NotificationSetting(title: 'Выбрать все предпочтения',id:0);
  List<Preference>? pref=[];
  List<Preference>? all=[];
  int? currentClientId;
  Client? cli;

  final List<NotificationSetting> notifications = [
  ];

  Future init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentClientId = preferences.getInt('currentId')!;
    pref = await Preference.fetchPref(currentClientId!);
    all = await Preference.fetchData();
    cli = await Client.fetchClient(preferences.getInt('currentId')!);
    setState(() {
      for (var o in all!) {
        notifications.add(NotificationSetting(title:o.title,value: false, id:o.id
        ));

      }
    });
  }
  @override
  void initState() {
    super.initState();
    init();
  }
  List<Preference>? select(){
    for (var o in notifications) {
      if (!o.value) {
        all!.removeWhere((element) => element.id==o.id);
      }

    }
    return all;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.deepPurple),
    home: Scaffold(
    appBar: AppBar(
      title: Text('Мои предпочтения'),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 400,
          child: ListView(
            children: [
              buildToggleCheckbox(allowNotifications),
              Divider(),
              ...notifications.map(buildSingleCheckbox).toList(),
            ],
          ),
        ),
        PinkButton(text: 'Добавить', onTap: ()=> {
          Preference.invite(select()!, cli!).then((value) => print(value.statusCode))
        })
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

