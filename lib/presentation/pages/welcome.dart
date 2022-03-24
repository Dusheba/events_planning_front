import 'package:events_planning/presentation/pages/login.dart';
import 'package:events_planning/presentation/pages/reg.dart';
import 'package:events_planning/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

import '../routes/page_path.dart';
//import 'package:encrypt/encrypt.dart';

class WelcomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:Container(
        height: size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height*0.05,),
            Image.asset(
              Resources.icon_outlined,
              height: size.height * 0.50,
            ),
            // Image.asset(
            //   "/icons/app_icon.png",
            //   height: size.height * 0.50,
            // ),
            Container(
              height: size.height*0.25,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 100, ),
                      color: Color.fromARGB(222, 151, 94, 186),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, PagePath.auth);
                      },
                      child: Text(
                        "Авторизация", style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 15),),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 100,),
                      color: Color.fromARGB(89, 151, 94, 186),
                      onPressed: () {Navigator.pushReplacementNamed(context, PagePath.registration);},
                      child: const Text(
                        "Регистрация",
                        style: TextStyle(
                            color: Color.fromARGB(255, 151, 94, 186),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height*0.10,),
          ],
        ),
      ),
    );
  }
}

void code(){
  //final key = Key.fromSecureRandom(32);
}