import 'package:events_planning/presentation/routes/routes.dart';
import 'package:events_planning/presentation/utils/utils.dart';
import 'package:events_planning/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _dark;

  int _currentBody = 1;
  _onItemTapped(int index) {
    setState(() {
      _currentBody = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _dark = false;
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }
  void onChange(int i) {
    //Заглушка для bottom_nav_bar
    print(i);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavBar( selectedIndex: _currentBody,
          onItemTapped: _onItemTapped,),
        backgroundColor: _dark ? null : Colors.grey.shade200,
        // appBar: AppBar(
        //   elevation: 0,
        //   brightness: _getBrightness(),
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.transparent,
        //   title: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 10),
        //     child: const Text(
        //       '',
        //       style: AppTheme.mainPageHeadline,
        //     ),
        //   ),
        // ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    height:80,
                    child: Card(
                      elevation:8.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.birthdayGradient,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          onTap: () {
                            //open edit profile
                          },
                          leading: Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 110, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Абобус",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  "abobus@mail.ru",
                                  style: TextStyle(
                                    color: AppTheme.valueEventColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(Resources.on_board_2),
                          // ),
                          trailing: Text(
                            "Выйти",
                            style: AppTheme.valueEventText,
                          ),
                        ),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,20,0,0),
                    child: const Text(
                        "Настройки",
                        style: AppTheme.mainPageHeadline
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    elevation: 4.0,
                    // margin: const EdgeInsets.fromLTRB(5.0, 0.0, 20.0, 0.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.edit,
                            color: AppTheme.boldColorFont,
                          ),
                          title: Text("Редактировать профиль"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {Navigator.pushReplacementNamed(context, PagePath.editProfile);},
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.favorite,
                            color: AppTheme.boldColorFont,
                          ),
                          title: Text("Мои предпочтения"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change language
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.info_outline_rounded,
                            color: AppTheme.boldColorFont,
                          ),
                          title: Text("О приложении"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.pushNamed(context, PagePath.about_app);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: Text(
                      "Уведомления",
                      style: AppTheme.mainPageHeadline
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: SwitchListTile(
                      activeColor: AppTheme.boldColorFont,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Push-уведомления"),
                      onChanged: (val) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: SwitchListTile(
                      activeColor: AppTheme.boldColorFont,
                      contentPadding: const EdgeInsets.all(0),
                      value: false,
                      title: Text("Уведомления на почту"),
                      onChanged: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: SwitchListTile(
                      activeColor: AppTheme.boldColorFont,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Приглашения от друзей"),
                      onChanged: (val) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: SwitchListTile(
                      activeColor: AppTheme.boldColorFont,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Обновление приложения"),
                      onChanged: null,
                    ),
                  ),
                  const SizedBox(height: 60.0),
                ],
              ),
            ),
            // Positioned(
            //   bottom: -20,
            //   left: -20,
            //   child: Container(
            //     width: 80,
            //     height: 80,
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //       color: AppTheme.boldColorFont,
            //       shape: BoxShape.circle,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   bottom: 00,
            //   left: 00,
            //   child: IconButton(
            //     icon: Icon(
            //       Icons.settings_outlined,
            //       color: Colors.white,
            //     ),
            //     onPressed: () {
            //       //log out
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}