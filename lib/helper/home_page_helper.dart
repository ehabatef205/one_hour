import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/const.dart';
import 'package:time_management/helper/awards.dart';
import 'package:time_management/helper/view_needer_details.dart';
import '../arabicAndEnglish.dart';
import 'history_work_helper.dart';
import 'profile_helper.dart';
import 'package:http/http.dart' as http;
import 'setting_helper.dart';
import 'package:time_management/welcome/welcome.dart';
import 'helper_form.dart';
import 'dart:ui' as ui;

class HomePageForHelper extends StatefulWidget {
  final bool isArabic;
  final String user_id;

  const HomePageForHelper({this.isArabic, this.user_id});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePageForHelper> {
  List language;
  int filter = 1;
  var data;
  var user_data;
  bool is_Loading = false;

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
    getData().whenComplete(() {
      setState(() {
        is_Loading = true;
      });
    });
  }

  Future getData() async {
    var response = await http.post(Uri.http("$local", "/test/profile.php"),
        body: {"id": widget.user_id});
    data = json.decode(response.body);
    user_data = data[0];
    return "Success";
  }

  Future getNeedersByCityServiceItem() async {
    var response = await http.post(
        Uri.http("$local", "/test/get_needers_by_city_service_item.php"),
        body: {
          "city_id": user_data["city_id"],
          "service_id": user_data["service_id"],
          "service_item_id": user_data["service_item_id"],
          "user_type": "needer",
        });
    var data = json.decode(response.body);
    return json.decode(response.body);
  }

  Future getNeedersByCityService() async {
    var response = await http.post(
        Uri.http("$local", "/test/get_needers_by_city_service.php"),
        body: {
          "city_id": user_data["city_id"],
          "service_id": user_data["service_id"],
          "user_type": "needer",
        });
    var data = json.decode(response.body);
    return json.decode(response.body);
  }

  Future getNeedersByCity() async {
    var response = await http
        .post(Uri.http("$local", "/test/get_needers_by_city.php"), body: {
      "city_id": user_data["city_id"],
      "user_type": "needer",
    });
    var data = json.decode(response.body);
    return json.decode(response.body);
  }

  Future getNeedersByService() async {
    var response = await http
        .post(Uri.http("$local", "/test/get_needers_by_service.php"), body: {
      "service_id": user_data["service_id"],
      "user_type": "needer",
    });
    var data = json.decode(response.body);
    return json.decode(response.body);
  }

  Future getAllNeeders() async {
    var response =
        await http.post(Uri.http("$local", "/test/get_all_needers.php"), body: {
      "user_type": "needer",
    });
    var data = json.decode(response.body);
    return json.decode(response.body);
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
          appBar: is_Loading
              ? user_data["city_id"] == null
                  ? AppBar(
                      iconTheme: IconThemeData(color: Colors.white),
                      title: Text(language[9],
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Color(0xffF37970),
                      centerTitle: true,
                    )
                  : AppBar(
                      iconTheme: IconThemeData(color: Colors.white),
                      title: Text(language[9],
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Color(0xffF37970),
                      centerTitle: true,
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HelperForm(
                                            isArabic: widget.isArabic,
                                            user_id: widget.user_id,
                                            is_update: true,
                                          )));
                            },
                            icon: Icon(Icons.edit)),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: Text(widget.isArabic
                                    ? "مدينة-نوع الخدمة-اسم الخدمة"
                                    : "City Service Item"),
                                value: 1,
                                onTap: () {
                                  setState(() {
                                    filter = 1;
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: Text(widget.isArabic
                                    ? "مدينة-نوع الخدمة"
                                    : "City Service"),
                                value: 2,
                                onTap: () {
                                  setState(() {
                                    filter = 2;
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: Text(widget.isArabic ? "مدينة" : "City"),
                                value: 3,
                                onTap: () {
                                  setState(() {
                                    filter = 3;
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: Text(
                                    widget.isArabic ? "نوع الخدمة" : "Service"),
                                value: 4,
                                onTap: () {
                                  setState(() {
                                    filter = 4;
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: Text(widget.isArabic ? "الكل" : "All"),
                                value: 5,
                                onTap: () {
                                  setState(() {
                                    filter = 5;
                                  });
                                },
                              ),
                            ];
                          },
                          icon: Icon(Icons.filter_list),
                        ),
                      ],
                    )
              : AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  title:
                      Text(language[9], style: TextStyle(color: Colors.white)),
                  backgroundColor: Color(0xffF37970),
                  centerTitle: true,
                ),
          drawer: Drawer(
            child:
                MainDrawer(isArabic: widget.isArabic, user_id: widget.user_id),
          ),
          body: is_Loading
              ? user_data["city_id"] == null
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: RaisedButton(
                                    elevation: 5,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HelperForm(
                                                    isArabic: widget.isArabic,
                                                    user_id: widget.user_id,
                                                    is_update: false,
                                                  )));
                                    },
                                    padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    color: Colors.white,
                                    child: Text(
                                      language[10],
                                      style: TextStyle(
                                          color: Color(0xffF37970),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder(
                          future: filter == 1
                              ? getNeedersByCityServiceItem()
                              : filter == 2
                                  ? getNeedersByCityService()
                                  : filter == 3
                                      ? getNeedersByCity()
                                      : filter == 4
                                          ? getNeedersByService()
                                          : getAllNeeders(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      List list = snapshot.data;

                                      return Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                                "${list[index]["first_name"]} ${list[index]["middle_name"]} ${list[index]["last_name"]}"),
                                            subtitle:
                                                Text("${list[index]["email"]}"),
                                            leading: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      "http://$local/test/uploads/needer/${list[index]['image']}"),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ViewNeederDetails(
                                                            isArabic:
                                                                widget.isArabic,
                                                            data: list[index],
                                                            user_id:
                                                                widget.user_id,
                                                          )));
                                            },
                                          ),
                                          Divider(
                                            height: 2,
                                            thickness: 1,
                                            indent: 20,
                                            endIndent: 20,
                                          ),
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
            builder: (context) => HomePageForHelper(
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
            builder: (context) => HomePageForHelper(
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
                              "http://$local/test/uploads/helper/${list[0]['image']}",
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
                                      builder: (context) => ProfilePageHelper(
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
                                      builder: (context) => HistoryWorkHelper(
                                            isArabic: widget.isArabic,
                                            user_id: widget.user_id,
                                          )));
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
                                      builder: (context) => Awards()));
                            },
                            leading: Icon(
                              Icons.dashboard,
                              color: Color(0xffF37970),
                            ),
                            title: Text(language[15]),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingHelper(
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
                              /*Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginScreen()));*/
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
