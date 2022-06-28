// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/const.dart';
import 'package:time_management/welcome/welcome.dart';
import '../arabicAndEnglish.dart';
import 'edit_password_helper.dart';
import 'home_page_helper.dart';
import 'package:http/http.dart' as http;
import 'package:time_management/theme/pages/home_page.dart';
import 'dart:ui' as ui;

class SettingHelper extends StatefulWidget {
  final String user_id;
  final bool isArabic;
  final String image;

  SettingHelper({this.user_id, this.isArabic, this.image});

  @override
  _SettingHelperState createState() => _SettingHelperState();
}

class _SettingHelperState extends State<SettingHelper> {
  bool state1 = true;
  bool state2 = true;
  bool state3 = true;

  deleteAccount() async {
    await http.post(Uri.http("$local", "/test/delete_account.php"), body: {
      "id": widget.user_id,
      "image": widget.image == "start.png" ? "" : widget.image
    });

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove("user_id");
    sharedPreferences.remove("helper");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Welcome(
                  isArabic: widget.isArabic,
                )));
  }

  List language;

  @override
  void initState() {
    setState(() {
      if (widget.isArabic) {
        language = ArabicAndEnglish.settingsArabic;
      } else {
        language = ArabicAndEnglish.settingsEnglish;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePageForHelper(
                      isArabic: widget.isArabic,
                      user_id: widget.user_id,
                    )));
      },
      child: Directionality(
        textDirection:
            widget.isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text(language[0], style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Color(0xffF37970),
            //Theme.of(context).scaffoldBackgroundColor,
            elevation: 1,
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePageForHelper(
                              isArabic: widget.isArabic,
                              user_id: widget.user_id,
                            )));
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 20, top: 30, right: 20),
            child: ListView(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xffF37970),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Text(
                      language[1],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    )
                  ],
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPasswordHelper(
                                  isArabic: widget.isArabic,
                                  user_id: widget.user_id,
                                )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        language[2],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xffF37970),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              language[3],
                              textDirection: widget.isArabic
                                  ? ui.TextDirection.rtl
                                  : ui.TextDirection.ltr,
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text(language[4]),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              RaisedButton(
                                child: Text(language[5]),
                                onPressed: () async {
                                  deleteAccount();
                                },
                              )
                            ],
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        language[10],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xffF37970),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.volume_up_outlined,
                      color: Color(0xffF37970),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Text(
                      language[6],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    )
                  ],
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language[11],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Switch(
                        activeColor: Color(0xffF37970),
                        value: state1,
                        onChanged: (bool s1) {
                          setState(() {
                            state1 = s1;
                            print(state1);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language[12],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Switch(
                        activeColor: Color(0xffF37970),
                        value: state2,
                        onChanged: (bool s2) {
                          setState(() {
                            state2 = s2;
                            print(state2);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language[13],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Switch(
                        activeColor: Color(0xffF37970),
                        value: state3,
                        onChanged: (bool s3) {
                          setState(() {
                            state3 = s3;
                            print(state3);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      language[9],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    HomePage()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
