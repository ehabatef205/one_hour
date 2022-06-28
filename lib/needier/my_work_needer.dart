import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/const.dart';
import 'package:time_management/needier/view_data_of_history_work_needer.dart';
import 'dart:ui' as ui;
import '../arabicAndEnglish.dart';
import 'home_page_needer.dart';

class MyWorkNeeder extends StatefulWidget {
  final bool isArabic;
  final String user_id;

  const MyWorkNeeder({this.isArabic, this.user_id});

  @override
  _MyWorkNeederState createState() => _MyWorkNeederState();
}

class _MyWorkNeederState extends State<MyWorkNeeder> {
  List language;

  List arabic = ["السجل"];

  List english = ["History"];

  bool isDone = false;

  @override
  void initState() {
    setState(() {
      isDone = false;
    });
    setState(() {
      if (widget.isArabic) {
        language = arabic;
      } else {
        language = english;
      }
    });
    super.initState();
  }

  var my_data;

  getHistory() async {
    var response = await http.get(Uri.http("$local", "/test/get_history.php"));
    var data = json.decode(response.body);
    my_data = data[0];
    return json.decode(response.body);
  }

  getData(String id) async {
    var response = await http
        .post(Uri.http("$local", "/test/profile.php"), body: {"id": id});
    var data = json.decode(response.body);
    return data[0];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePageForNeeder(
                  isArabic: widget.isArabic,
                  user_id: widget.user_id,
                )));
      },
      child: Directionality(
        textDirection:
        widget.isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(language[0], style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePageForNeeder(
                          isArabic: widget.isArabic,
                          user_id: widget.user_id,
                        )));
              },
            ),
            backgroundColor: Color(0xffF37970),
          ),
          body: FutureBuilder(
            future: getHistory(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list2 = snapshot.data;

                    return FutureBuilder(
                        future: getData(list2[index]["helper_id"]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var list = snapshot.data;
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      "${list["first_name"]} ${list["middle_name"]} ${list["last_name"]}"),
                                  subtitle: Text("${list["email"]}"),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "http://$local/test/uploads/needer/${list['image']}"),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewDataOfHistoryWorkNeeder(
                                              isArabic: widget.isArabic,
                                              user_id: widget.user_id,
                                              list: list,
                                              data_history: list2[index],
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
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                  })
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
