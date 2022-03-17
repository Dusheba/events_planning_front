import 'package:auto_animated/auto_animated.dart';
import 'package:events_planning/data/entities.dart';
import 'package:events_planning/presentation/routes/routes.dart';
import 'package:events_planning/presentation/utils/utils.dart';
import 'package:events_planning/presentation/widgets/bottom_nav_bar.dart';
import 'package:events_planning/presentation/widgets/buttons.dart';
import 'package:events_planning/presentation/widgets/custom_calendar/src/calendar_timeline.dart';
import 'package:events_planning/presentation/widgets/wide_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:events_planning/presentation/widgets/task_item_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailCategoryTaskPage extends StatefulWidget {
  final ArgumentBundle bundle;

  const DetailCategoryTaskPage({Key? key, required this.bundle})
      : super(key: key);

  @override
  _DetailCategoryTaskPageState createState() => _DetailCategoryTaskPageState();
}

class _DetailCategoryTaskPageState extends State<DetailCategoryTaskPage> {
  late EventCategory _category = widget.bundle.extras[Keys.categoryItem];
  DateTime datePicked = DateTime.now();
  ValueNotifier<int> totalTasks = ValueNotifier(0);
  late int index = widget.bundle.extras[Keys.index];
  List<Event> _eventsWithCat = [];
  int? currentClientId;

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 3),
        () => 'Data Loaded',
  );

  Future<void> getCurrentClient() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currentClientId = preferences.getInt('currentId');
    });
  }

  void onChange(int i){
    //Заглушка для bottom_nav_bar
    print(i);
  }

  fetchData(int month, int cat) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentClientId = preferences.getInt('currentId');
    _eventsWithCat = await Event.fetchEventByMonth(month, currentClientId!, cat);
    _category = await EventCategory.fetchCatById(cat);
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    fetchData(DateTime.now().month, index);
    totalTasks = ValueNotifier(_eventsWithCat.length);
  }

  @override
  void dispose() {
    totalTasks.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _calculation,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if(snapshot.hasData) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  WideAppBar(
                  tag: index.toString(),
                  title: _category.title,
                  gradient: LinearGradient(colors: [AppTheme.pinkBright, AppTheme.purpleDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
            ),
                  // AppTheme.getGradientByName(_category!.color),
                  actions: [
                  IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                  ),
                  IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => {}
                  //todo: modal add event
                  ),
                  ],
                  child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                    height: MediaQuery.of(context).padding.top,
                    ),
                    SizedBox(
                    height: 36,
                    ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                        DateFormat('MMM, yyyy', 'ru').format(datePicked),
                        style: AppTheme.eventHeadline,
                        ),
                        SizedBox(height: 8),
                        ValueListenableBuilder<int>(
                        valueListenable: totalTasks,
                        builder: (context, value, child) => Text(
                        'Предстоящих событий ${_eventsWithCat.length}',
                        style: AppTheme.valueEventText,
                        ),
                        ),
                      ],
                      ),
                      ),
                    ],
                    ),
                    ),
                    CalendarTimeline(
                    initialDate: datePicked,
                    firstDate: DateTime(2019, 1, 1),
                    lastDate: DateTime(2025, 11, 20),
                    onDateSelected: (date) =>
                      setState(() {
                    datePicked = date!;
                    fetchData(datePicked.month, index);
                    })
                    ,
                    leftMargin: 20,
                    monthColor: Colors.blueGrey,
                    dayColor: AppTheme.borderPurple,
                    activeDayColor: AppTheme.white,
                    activeBackgroundDayColor: AppTheme.darkBorderPurple,
                    dotsColor: Color(0xFF333A47),
                    locale: 'ru',
                    ),
                    ],
                    ),
                    ),
                    SliverList(
                    delegate: SliverChildListDelegate([
                    _taskList(),
                    ]),
                    ),
                    ],
            );
          }
            else {
              return Center(
                  child:
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('img/icon_outlined.jpg'),
                      const SizedBox(height: 80),
                      Text('ИВЕНТ', style: AppTheme.mainPageHeadline),
                    ],
                  ));
            }
        }
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0, onItemTapped: onChange),
    );
  }

  _taskList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
        FutureBuilder<String>(
        future: _calculation,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return taskListView(_eventsWithCat);
          }
          else {
            return Center(
                child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset('assets/svg/on_baord_2.svg'),
                    const SizedBox(height: 80),
                    Text('ИВЕНТ', style: AppTheme.mainPageHeadline),
                  ],
                ));
          }
        }
    )
    );
  }

  Widget taskListView(List<Event> data) {
    return LiveList.options(
      options: Helper.options,
      itemCount: data.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) {
        final item = data[index];
        return EventItemWidget(
          event: item,
          category: _category,
          animation: animation,
        );
      },
    );
  }

}
