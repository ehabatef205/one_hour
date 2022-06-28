import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/const.dart';
import 'dart:ui' as ui;

import '../arabicAndEnglish.dart';
import 'my_work_needer.dart';

class ViewDataOfHistoryWorkNeeder extends StatefulWidget {
  final bool isArabic;
  final String user_id;
  final list;
  final data_history;

  const ViewDataOfHistoryWorkNeeder({this.isArabic, this.user_id, this.list, this.data_history});

  @override
  _ViewDataOfHistoryWorkNeederState createState() => _ViewDataOfHistoryWorkNeederState();
}

class _ViewDataOfHistoryWorkNeederState extends State<ViewDataOfHistoryWorkNeeder> {
  String needer_city = "";
  String needer_service = "";
  String needer_service_item = "";
  List language;

  bool isDone = false;

  bool isReview = false;

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

    get_city();
    get_service();
    get_service_item();
  }

  get_city() async {
    var response = await http.post(Uri.http("$local", "/test/city_by_id.php"),
        body: {"city_id": widget.data_history["city_id"]});
    var data = json.decode(response.body);
    setState(() {
      if (widget.isArabic) {
        needer_city = data[0]["city_name_ar"];
      } else {
        needer_city = data[0]["city_name_en"];
      }
    });
    return "Success";
  }

  get_service() async {
    var response = await http.post(
        Uri.http("$local", "/test/service_by_id.php"),
        body: {"service_id": widget.data_history["service_id"]});
    var data = json.decode(response.body);
    setState(() {
      if (widget.isArabic) {
        needer_service = data[0]["service_name_ar"];
      } else {
        needer_service = data[0]["service_name_en"];
      }
    });
    return "Success";
  }

  get_service_item() async {
    var response = await http.post(
        Uri.http("$local", "/test/service_item_by_id.php"),
        body: {"service_item_id": widget.data_history["service_item_id"]});
    var data = json.decode(response.body);
    setState(() {
      if (widget.isArabic) {
        needer_service_item = data[0]["service_item_ar"];
      } else {
        needer_service_item = data[0]["service_item_en"];
      }
    });
    return "Success";
  }

  var reviews = ["1", "2", "3", "4", "5"];

  String review;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
      widget.isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF37970),
          elevation: 3,
          title: Text(
              "${widget.list["first_name"]} ${widget.list["middle_name"]} ${widget.list["last_name"]}",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
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
                      builder: (context) => MyWorkNeeder(
                        isArabic: widget.isArabic,
                        user_id: widget.user_id,
                      )));
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "http://$local/test/uploads/needer/${widget.list['image']}"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${widget.list["first_name"]} ${widget.list["middle_name"]} ${widget.list["last_name"]}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                newMethod("${language[28]}:", widget.list["email"]),
                newMethod("${language[42]}", needer_city),
                newMethod("${language[48]}:", needer_service),
                newMethod("${language[49]}:", needer_service_item),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      language[57],
                      style:
                      new TextStyle(fontSize: 20.0),
                    ),
                    DropdownButton(
                      items: reviews.map((item) {
                        return DropdownMenuItem(
                          child: Text(item),
                          value: item,
                        );
                      }).toList(),
                      value: review == null
                          ? null
                          : review,
                      hint: Text(language[58]),
                      onChanged: (newValue) {
                        setState(() {
                          review = newValue;
                        });
                      },
                    ),
                  ],
                ),
                /*isReview
                                      ? newMethod("${language[68]}:",
                                          data1[0]["review"])
                                      : newMethod("${language[68]}:",
                                          "لم يتم تقييمك بعد"),
                                  isDone
                                      ? newMethod("${language[57]}:",
                                          data2[0]["review"])
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Text(
                                              language[57],
                                              style:
                                                  new TextStyle(fontSize: 20.0),
                                            ),
                                            DropdownButton(
                                              items: reviews.map((item) {
                                                return DropdownMenuItem(
                                                  child: Text(item),
                                                  value: item,
                                                );
                                              }).toList(),
                                              value: review == null
                                                  ? null
                                                  : review,
                                              hint: Text(language[58]),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  review = newValue;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                  review == null
                                      ? Container()
                                      : isDone
                                          ? Container()
                                          : RaisedButton(
                                              child: Text(
                                                language[57],
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
                                                updateReview();
                                                isDone = true;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HistoryWorkHelper(
                                                              isArabic: widget
                                                                  .isArabic,
                                                              user_id: widget
                                                                  .user_id,
                                                            )));
                                              },
                                            ),*/
              ],
            )),
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
          Text(
            "$placeholder",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
