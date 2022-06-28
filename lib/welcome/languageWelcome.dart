import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/welcome/welcome.dart';
import 'about_us.dart';

class LanguageWelcome extends StatefulWidget {
  @override
  _LanguageWelcomeState createState() => _LanguageWelcomeState();
}

class _LanguageWelcomeState extends State<LanguageWelcome> {
  Future getArabic() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("isArabic", true);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Welcome(
                  isArabic: true,
                )));
  }

  Future getEnglish() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("isArabic", false);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Welcome(
                  isArabic: false,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        SystemNavigator.pop();
      },
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
                    "Welcome",
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
                    onTap: getEnglish,
                    child: Center(
                      child: Text(
                        "English",
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
                    onTap: getArabic,
                    child: Center(
                      child: Text(
                        "عربي",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
