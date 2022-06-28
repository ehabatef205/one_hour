import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_management/helper/login_helper.dart';
import 'package:time_management/needier/login_needer.dart';
import 'package:time_management/arabicAndEnglish.dart';
import 'about_us.dart';
import 'dart:ui' as ui;

class Welcome extends StatefulWidget {
  final bool isArabic;

  const Welcome({this.isArabic});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  List language;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.isArabic) {
        language = ArabicAndEnglish.welcomeArabic;
      } else {
        language = ArabicAndEnglish.welcomeEnglish;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Directionality(
        textDirection:
            widget.isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(
                      language[0],
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffF37970)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/onehour.jpg',
                        width: 350,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
                    radius: 150,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Color(0xffF37970 /* 00A8A8 */),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: openNeedierLogin,
                      child: Center(
                        child: Text(
                          language[1],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Color(0xffF37970),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: openHelperLogin,
                      child: Center(
                        child: Text(
                          language[2],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        language[3],
                        style: TextStyle(
                            color: Color(0xffF37970) /* Colors.black */),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutUs()));
                        },
                        child: Text(
                          language[4],
                          style: TextStyle(
                              color: Color(0xffF37970) /* Colors.black */,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openNeedierLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreenNeeder(isArabic: widget.isArabic)));
  }

  void openHelperLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginHelperScreen(isArabic: widget.isArabic)));
  }
}
