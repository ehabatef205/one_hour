import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/const.dart';
import '../arabicAndEnglish.dart';
import 'home_page_helper.dart';
import 'dart:ui' as ui;

class ViewNeederDetails extends StatefulWidget {
  final bool isArabic;
  final String user_id;
  final data;

  ViewNeederDetails({this.isArabic, this.data, this.user_id});

  @override
  _ViewNeederDetailsState createState() => _ViewNeederDetailsState();
}

class _ViewNeederDetailsState extends State<ViewNeederDetails> {
  String needer_city = "";
  String needer_service = "";
  String needer_service_item = "";
  List language;

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
        body: {"city_id": widget.data["city_id"]});
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
        body: {"service_id": widget.data["service_id"]});
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
        body: {"service_item_id": widget.data["service_item_id"]});
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

  accept_needer() async {
    var response = await http
        .post(Uri.http("$local", "/test/accept_needer.php"), body: {
      "id": widget.data["id"],
      "is_accept": "1",
      "id_helper": widget.user_id
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Accept needer_email ${widget.data["email"]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageForHelper(
                    isArabic: widget.isArabic,
                    user_id: widget.user_id,
                  )));
    } else {
      Fluttertoast.showToast(
          msg: "Error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
            backgroundColor: Color(0xffF37970),
            elevation: 3,
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
                        builder: (context) => HomePageForHelper(
                              isArabic: widget.isArabic,
                              user_id: widget.user_id,
                            )));
              },
            ),
            title: Text(
                "${widget.data["first_name"]} ${widget.data["middle_name"]} ${widget.data["last_name"]}",
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
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
                                    "http://$local/test/uploads/needer/${widget.data['image']}"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${widget.data["first_name"]} ${widget.data["middle_name"]} ${widget.data["last_name"]}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                newMethod("${language[28]}:", widget.data["email"]),
                newMethod("${language[18]}:", widget.data["phone"]),
                newMethod("${language[42]}", needer_city),
                newMethod("${language[48]}:", needer_service),
                newMethod("${language[49]}:", needer_service_item),
                widget.data["comment"] == null
                    ? Container()
                    : newMethod("Comment: ", widget.data["comment"]),
                RaisedButton(
                  child: Text(
                    language[50],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Color(0xffF37970),
                  onPressed: () {
                    accept_needer();
                  },
                )
              ],
            ),
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
          Text(
            "$placeholder",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
