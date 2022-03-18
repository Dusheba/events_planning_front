import 'dart:async';
import 'package:auto_animated/auto_animated.dart';
import 'package:events_planning/data/entities.dart';
import 'package:events_planning/presentation/utils/utils.dart';
import 'package:events_planning/presentation/widgets/search_widget.dart';
import 'package:events_planning/presentation/widgets/task_item_widget.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Event> events = [];
  String query = '';
  Timer? debouncer;
  int? currentClientId = 1; //как айдюк передавать??

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  // Future<void> getCurrentClient() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     currentClientId = preferences.getInt('currentId');
  //   });
  // }

  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final events = await Event.fetchData(currentClientId!);
    setState(() => this.events = events);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: <Widget>[
        buildSearch(),
        Expanded(
          child: LiveList.options(
            options: Helper.options,
            itemCount: events.length,
            itemBuilder: (context, index, animation) {
              final event = events[index];
              return EventItemWidget(event: event, category: event.category, animation: animation);
            },
          ),
        ),
      ],
    ),
  );

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Поиск событий',
    onChanged: searchEvent,
  );

  Future searchEvent(String query) async => debounce(() async {
    final events = await Event.fetchData(currentClientId!);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.events = events;
    });
  });

  Widget buildEvent(Event event) => ListTile(
    title: Text(event.title),
    subtitle: Text(event.category.title),
  );
}