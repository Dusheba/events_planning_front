import 'package:events_planning/presentation/routes/page_path.dart';
import 'package:events_planning/presentation/utils/constants.dart';
import 'package:events_planning/presentation/widgets/buttom.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';


class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Планируй свои события',
          body: '',
          image: buildImage('assets/icons/learning1.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Приглашай своих друзей',
          body: '',
          image: Image.asset(Resources.secondIcon),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Отслеживай посещаемость событий',
          body: '',
          footer: ButtonWidget(
            text: 'Начать планировать',
            onClicked: () => goToHome(context),
          ),
          image: Image.asset(Resources.thirdIcon),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text('Далее', style: TextStyle(fontWeight: FontWeight.w600,
          color: Colors.white)),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: Text('Пропустить', style: TextStyle(color: Colors.white),),
      onSkip: () => goToHome(context),
      next: Icon(Icons.arrow_forward, color: Colors.white),
      dotsDecorator: getDotDecoration(),
      globalBackgroundColor: Color.fromARGB(176, 86, 80, 222),
      nextFlex: 0,
    ),
  );

  void goToHome(context) => Navigator.pushReplacementNamed(context, PagePath.base);

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFBDBDBD),
    activeColor: Color(0xFFBDBDBD),
    //activeColor: Colors.orange,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    //imagePadding: Padding(padding:  EdgeInsets.all(40)),
    //titlePadding: Padding(padding:  EdgeInsets.all(40)),
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(fontSize: 20),
    //descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(34),
    pageColor: Colors.white,
  );
}