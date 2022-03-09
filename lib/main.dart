import 'package:auto_animated/auto_animated.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:events_planning/data/entities.dart';
import 'package:events_planning/presentation/routes/argument_bundle.dart';
import 'package:events_planning/presentation/routes/page_path.dart';
import 'package:events_planning/presentation/utils/app_theme.dart';
import 'package:events_planning/presentation/utils/constants.dart';
import 'package:events_planning/presentation/utils/utils.dart';
import 'package:events_planning/presentation/widgets/task_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'database.dart';
import 'package:events_planning/data/client.dart';
import 'dart:math' as math;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.db.initDB();
  // Client cl = Client(id:6,name: "hhh", username: "mm", pass: "1",
  //     phone: "99999", email: "test", social: "aahgag");
  EventCategory cat = EventCategory(id: 1, title: 'Свадьба', color: 'weddingGradient');
  EventCategory cat2 = EventCategory(id: 2, title: 'День Рождения', color: 'birthdayGradient');
  EventCategory cat3 = EventCategory(id: 3, title: 'Вечеринка', color: 'partyGradient');
  // DBProvider.db.newCategory(cat);
  // DBProvider.db.newCategory(cat2);
  // DBProvider.db.newCategory(cat3);
  Event ev = Event(id:1, categoryId: 2, title: 'ДР', description: 'описание', address: 'адрес', budget:10000, startTime: '2022-03-10', ownerId: 1);
  Event ev2 = Event(id:2, categoryId: 1, title: 'Свадьба', description: 'описание', address: 'адрес', budget:10000, startTime: '2022-03-13', ownerId: 1);
  // DBProvider.db.newEvent(ev);
  // DBProvider.db.newEvent(ev2);
 runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // data for testing
  List<Client> testClients = [
    Client(name: "Raouf", username: "Rahiche", pass: "1", phone: "99999", email: "test", social: "fh"),
    Client(name: "ete", username: "Rahiche", pass: "1", phone: "99999", email: "test", social: "jf"),
    Client(name: "Shl", username: "Rahiche", pass: "1", phone: "99999", email: "test", social: "jf"),
  ];
  final Future<List<Client>> _clients = DBProvider.db.getAllClients();
  final Future<List<Event>> _events = DBProvider.db.getAllEvent();
  final Future<List<EventCategory>> _categories = DBProvider.db.getAllCat();
  late List<EventCategory> cats;
  int? totalNum;

  convertToModels(Future<List<EventCategory>> list) async{
    cats = await list;
  }
  convertNumbers(Future<int> number) async {
    totalNum = await number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                _topBar(),
                _myTasks(),
                _onGoing()
                // _complete(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _topBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateTime.now().format(FormatDate.monthDayYear),
            style: AppTheme.dateEventPanelText,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Hero(
              tag: Keys.heroSearch,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.boldColorFont),
                ),
                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Search Tasks here',
                        style: AppTheme.eventPanelHeadline,
                      ),
                    ),
                    Icon(
                      Icons.search_rounded,
                      color: AppTheme.borderPurple,
                    ),
                  ],
                ),
              ).addRipple(onTap: () => Navigator.pushNamed(context, PagePath.search),),
            ),
          ),
        ],
      ),
    );
  }

  _myTasks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Tasks',
                style: AppTheme.eventPanelHeadline,
                textAlign: TextAlign.start,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: AppTheme.eventPanelHeadline.withPink,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          FutureBuilder<List<EventCategory>>(
          future: _categories,
          builder: (BuildContext context, AsyncSnapshot<List<EventCategory>> snapshot) {
            if (snapshot.hasData) {
              return taskCategoryGridView(snapshot.data!);
            }
            else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: LottieBuilder.asset(Resources.empty,
                      height: MediaQuery.of(context).size.height * 0.3),
                ),
              );
            }
          })
          ],
      ),
    );
  }

  _onGoing() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: Keys.heroStatus + StatusType.ON_GOING.toString(),
                child: Text(
                  'On Going',
                  style: AppTheme.eventHeadline,
                  textAlign: TextAlign.start,
                ),
              ),
              TextButton(
                onPressed: () => {},
                child: Text(
                  'See all',
                  style: AppTheme.eventPanelHeadline.withPink,
                ),
              ),
            ],
          ),
          FutureBuilder<List<Event>>(
          future: _events,
          builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.hasData) {
          return taskListView(snapshot.data!);
          }
          else {
          return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Center(
          child: LottieBuilder.asset(Resources.empty,
          height: MediaQuery.of(context).size.height * 0.3),
          ),
          );
          }
          }
          )
        ],
      ),
    );
  }

  Widget taskCategoryGridView(List<EventCategory> data) {
    List<EventCategory> dataList = data;
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        final taskItem = dataList[index];
        return taskCategoryItemWidget(taskItem);
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 2.4 : 1.8),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
    );
  }

  Widget taskCategoryItemWidget(EventCategory category) {
    convertNumbers(DBProvider.db.getEventNumberByCat(category.id));
    print(totalNum);
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.getGradientByName(category.color),
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppTheme.getShadow(AppTheme.getGradientByName(category.color).colors[0]),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: AutoSizeText(
                  (category.id).toString(),
                  style: AppTheme.eventPanelHeadline,
                  minFontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 12),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Hero(
                      tag: Keys.heroTitleCategory + category.id.toString(),
                      child: Text(
                        category.title,
                        style: AppTheme.eventPanelHeadline.withWhite,
                        maxLines: category.id.isEven ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_right, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              '$totalNum Events',
              style: AppTheme.eventPanelHeadline.withWhite,
            ),
          ],
        ),
      ).addRipple(onTap: () {
        Navigator.pushNamed(
          context,
          PagePath.detailCategory,
          arguments: ArgumentBundle(extras: {
            Keys.categoryItem: category,
            Keys.index: category.id,
          }, identifier: 'detail Category'),
        );
      }),
    );
  }

  Widget taskListView(List<Event> data) {
    convertToModels(DBProvider.db.getAllCat());
    return LiveList.options(
      options: Helper.options,
      itemCount: data.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) {
        final item = data[index];
        return EventItemWidget(
          event: item,
          category: cats[item.categoryId], animation: animation,
        );
      },
    );
  }
}