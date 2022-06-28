import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/const.dart';
import 'package:time_management/needier/setting_needer.dart';
import '../arabicAndEnglish.dart';
import 'information_helper.dart';
import 'my_work_needer.dart';
import 'profile_needer.dart';
import 'package:time_management/welcome/welcome.dart';
import 'package:http/http.dart' as http;
import 'needer_form.dart';
import 'dart:ui' as ui;

class HomePageForNeeder extends StatefulWidget {
  final bool isArabic;
  final String user_id;

  const HomePageForNeeder({this.isArabic, this.user_id});

  @override
  _HomePageForNeederState createState() => _HomePageForNeederState();
}

class _HomePageForNeederState extends State<HomePageForNeeder> {
  List language;
  var data;
  var user_data;
  bool is_Loading = false;
  var form_key = GlobalKey<FormState>();
  String my_city = "";
  String my_service = "";
  String my_service_item = "";

  @override
  void initState() {
    setState(() {
      if (widget.isArabic) {
        language = ArabicAndEnglish.signUpHelperArabic;
      } else {
        language = ArabicAndEnglish.signUpHelperEnglish;
      }
    });
    super.initState();
    getData().whenComplete(() {
      if(user_data["city_id"] != null) {
        get_city().whenComplete(() {
          get_service().whenComplete(() {
            get_service_item().whenComplete(() {
              setState(() {
                is_Loading = true;
              });
            });
          });
        });
      }else{
        setState(() {
          is_Loading = true;
        });
      }
    });
  }

  Future get_city() async {
    var response = await http.post(Uri.http("$local", "/test/city_by_id.php"),
        body: {"city_id": user_data["city_id"]});
    var data = json.decode(response.body);
    setState(() {
      if (widget.isArabic) {
        my_city = data[0]["city_name_ar"];
      } else {
        my_city = data[0]["city_name_en"];
      }
    });
    return "Success";
  }

  Future get_service() async {
    var response = await http.post(
        Uri.http("$local", "/test/service_by_id.php"),
        body: {"service_id": user_data["service_id"]});
    var data = json.decode(response.body);
    setState(() {
      if (widget.isArabic) {
        my_service = data[0]["service_name_ar"];
      } else {
        my_service = data[0]["service_name_en"];
      }
    });
    return "Success";
  }

  Future get_service_item() async {
    var response = await http.post(
        Uri.http("$local", "/test/service_item_by_id.php"),
        body: {"service_item_id": user_data["service_item_id"]});
    var data = json.decode(response.body);
    setState(() {
      if (widget.isArabic) {
        my_service_item = data[0]["service_item_ar"];
      } else {
        my_service_item = data[0]["service_item_en"];
      }
    });
    return "Success";
  }

  Future getData() async {
    var response = await http.post(Uri.http("$local", "/test/profile.php"),
        body: {"id": widget.user_id});
    data = json.decode(response.body);
    user_data = data[0];
    return data;
  }

  delete_form() async {
    var response =
    await http.post(Uri.http("$local", "/test/delete_form.php"), body: {
      "id": widget.user_id,
    });

    if (response.statusCode == 200) {
      print('Form is updated');
    } else {
      print('Form is not updated');
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
            super.widget));
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
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text("One Hour", style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xffF37970),
            centerTitle: true,
          ),
          drawer: Drawer(
            child: MainDrawer(
              isArabic: widget.isArabic,
              user_id: widget.user_id,
            ),
          ),
          body: is_Loading
              ? RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(
                      Duration(seconds: 1),
                      () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    super.widget));
                      },
                    );
                  },
                  child: user_data["city_id"] == null
                      ? ListView(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: <Widget>[
                              RaisedButton(
                                elevation: 5,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NeederForm(
                                                isArabic: widget.isArabic,
                                                user_id: widget.user_id,
                                                is_update: false,
                                              )));
                                },
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.white,
                                child: Text(
                                  language[64],
                                  style: TextStyle(
                                      color: Color(0xffF37970),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                          ),
                        ])
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder(
                            future: getData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              return snapshot.hasData
                                  ? ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        List list = snapshot.data;

                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 25,
                                            ),
                                            newMethod("${language[67]}:",
                                                "${list[0]["first_name"]} ${list[0]["middle_name"]} ${list[0]["last_name"]}"),
                                            newMethod("${language[28]}:",
                                                list[0]["email"]),
                                            newMethod("${language[42]}",
                                                my_city),
                                            newMethod("${language[10]}:",
                                                list[0]["address"]),
                                            newMethod("${language[48]}:",
                                                my_service),
                                            newMethod("${language[49]}:",
                                                my_service_item),
                                            list[0]["comment"] == ""
                                                ? Container()
                                                : newMethod("Comment:",
                                                    list[0]["comment"]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                RaisedButton(
                                                  child: Text(
                                                    language[66],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  color: Color(0xffF37970),
                                                  onPressed: () {
                                                    showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "Are you sure you want to delete your form",
                                                              textDirection: widget.isArabic
                                                                  ? ui.TextDirection.rtl
                                                                  : ui.TextDirection.ltr,
                                                            ),
                                                            actions: <Widget>[
                                                              RaisedButton(
                                                                child: Text("No"),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              RaisedButton(
                                                                child: Text("Yes"),
                                                                onPressed: () async {
                                                                  delete_form();
                                                                },
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                RaisedButton(
                                                  child: Text(
                                                    language[53],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  color: Color(0xffF37970),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => NeederForm(
                                                              isArabic: widget.isArabic,
                                                              user_id: widget.user_id,
                                                              is_update: true,
                                                            )));
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            list[0]["is_accept"] == "1"
                                                ? RaisedButton(
                                                    child: Text(
                                                      language[69],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    padding: EdgeInsets.all(15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    color: Color(0xffF37970),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  InformationHelper(
                                                                    isArabic: widget.isArabic,
                                                                    user_id: widget.user_id,
                                                                    id_helper: list[0]["id_helper"],
                                                                  )));
                                                    },
                                                  )
                                                : Container()
                                          ],
                                        );
                                      })
                                  : Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Widget newMethod(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Text(
            "$labelText ",
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: Text(
              "$placeholder",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class MainDrawer extends StatefulWidget {
  final String user_id;
  final bool isArabic;

  const MainDrawer({this.user_id, this.isArabic});

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List language;

  @override
  void initState() {
    setState(() {
      if (widget.isArabic) {
        language = ArabicAndEnglish.arabicDrawer;
      } else {
        language = ArabicAndEnglish.englishDrawer;
      }
    });
    super.initState();
  }

  Future getData() async {
    var response = await http.post(Uri.http("$local", "/test/profile.php"),
        body: {"id": widget.user_id});
    var data = json.decode(response.body);
    return json.decode(response.body);
  }

  Future getArabic() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("isArabic", true);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePageForNeeder(
                  isArabic: true,
                  user_id: widget.user_id,
                )));
  }

  Future getEnglish() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("isArabic", false);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePageForNeeder(
                  isArabic: false,
                  user_id: widget.user_id,
                )));
  }

  List listofData;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          widget.isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data;

                    listofData = list;
                    return Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(
                              "http://$local/test/uploads/needer/${list[0]['image']}",
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${list[0]["first_name"]} ${list[0]["middle_name"]} ${list[0]["last_name"]}",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePageNeeder(
                                          isArabic: widget.isArabic,
                                          user_id: list[0]["id"])));
                            },
                            leading: Icon(
                              Icons.person,
                              color: Color(0xffF37970),
                            ),
                            title: Text(language[0]),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyWorkNeeder(isArabic: widget.isArabic, user_id: widget.user_id,)));
                            },
                            leading: Icon(
                              Icons.work,
                              color: Color(0xffF37970),
                            ),
                            title: Text(language[1]),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingNeeder(
                                          user_id: widget.user_id,
                                          isArabic: widget.isArabic,
                                          image: list[0]['image'])));
                            },
                            leading: Icon(
                              Icons.settings,
                              color: Color(0xffF37970),
                            ),
                            title: Text(language[2]),
                          ),
                          ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Column(
                                        children: [
                                          FlatButton(
                                              padding: EdgeInsets.only(
                                                  left: 70,
                                                  right: 70,
                                                  top: 10,
                                                  bottom: 10),
                                              onPressed: getArabic,
                                              child: Text(language[13],
                                                  style:
                                                      TextStyle(fontSize: 20))),
                                          SizedBox(height: 10),
                                          FlatButton(
                                              padding: EdgeInsets.only(
                                                  left: 70,
                                                  right: 70,
                                                  top: 10,
                                                  bottom: 10),
                                              onPressed: getEnglish,
                                              child: Text(language[14],
                                                  style:
                                                      TextStyle(fontSize: 20))),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            leading: Icon(
                              Icons.language,
                              color: Color(0xffF37970),
                            ),
                            title: Text(language[3]),
                          ),
                          ListTile(
                            onTap: send,
                            leading: Icon(
                              Icons.help_center,
                              color: Color(0xffF37970),
                            ),
                            title: Text(language[4]),
                          ),
                          ListTile(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        language[6],
                                        textDirection: widget.isArabic
                                            ? ui.TextDirection.rtl
                                            : ui.TextDirection.ltr,
                                      ),
                                      actions: <Widget>[
                                        RaisedButton(
                                          child: Text(language[8]),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text(language[7]),
                                          onPressed: () async {
                                            final SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            sharedPreferences.remove("user_id");
                                            sharedPreferences.remove("helper");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Welcome(
                                                          isArabic:
                                                              widget.isArabic,
                                                        )));
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                            leading: Icon(
                              Icons.logout,
                              color: Color(0xffF37970),
                            ),
                            title: Text(language[5]),
                          ),
                        ],
                      ),
                    );
                  })
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> send() async {
    final Email email = Email(
      subject: "",
      body: "",
      recipients: ["ehabmahmoud205@gmail.com"],
      isHTML: true,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;
  }
}
