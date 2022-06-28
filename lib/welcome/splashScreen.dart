import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/helper/home_page_helper.dart';
import 'package:time_management/needier/home_page_needer.dart';
import 'package:time_management/theme/models_providers/theme_provider.dart';
import 'package:time_management/welcome/languageWelcome.dart';
import 'welcome.dart';

class splashScreen extends StatefulWidget {
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  String user_id;
  bool helper;
  bool isArabic;

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() {
      Timer(Duration(seconds: 5), () {
        isArabic == null
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => LanguageWelcome()))
            : user_id == null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Welcome(isArabic: isArabic)))
                : helper
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePageForHelper(isArabic: isArabic, user_id: user_id,)))
                    : Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePageForNeeder(isArabic: isArabic, user_id: user_id,)));
      });
    });
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedId = sharedPreferences.getString("user_id");
    var isHelper = sharedPreferences.getBool("helper");
    var arabic = sharedPreferences.getBool("isArabic");
    user_id = obtainedId;
    helper = isHelper;
    isArabic = arabic;
    print(obtainedId.toString());
    print(helper);
    print(isArabic);
  }

  bool _switch = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isLightTheme) {
      setState(() {
        _switch = false;
      });
    } else {
      _switch = true;
    }
    return Scaffold(
        body: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: _switch
                  ? AssetImage("assets/start2.gif")
                  : AssetImage("assets/start.gif"),
              fit: BoxFit.fill)),
    ));
  }
}
