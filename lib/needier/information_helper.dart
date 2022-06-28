import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:time_management/const.dart';
import '../arabicAndEnglish.dart';
import 'home_page_needer.dart';

class InformationHelper extends StatefulWidget {
  final bool isArabic;
  final String user_id;
  final String id_helper;

  const InformationHelper({this.isArabic, this.user_id, this.id_helper});

  @override
  _InformationHelperState createState() => _InformationHelperState();
}

class _InformationHelperState extends State<InformationHelper> {
  List language;
  String my_city = "";
  String my_service = "";
  String my_service_item = "";
  var my_data;

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
  }

  Future get_city(String city_id) async {
    var response = await http.post(Uri.http("$local", "/test/city_by_id.php"),
        body: {"city_id": city_id});
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

  Future get_service(String service_id) async {
    var response = await http.post(
        Uri.http("$local", "/test/service_by_id.php"),
        body: {"service_id": service_id});
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

  Future get_service_item(String service_item_id) async {
    var response = await http.post(
        Uri.http("$local", "/test/service_item_by_id.php"),
        body: {"service_item_id": service_item_id});
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
        body: {"id": widget.id_helper});
    var data = json.decode(response.body);
    my_data = data[0];
    return json.decode(response.body);
  }

  disable_accept() async {
    var response =
        await http.post(Uri.http("$local", "/test/disable_accept.php"), body: {
      "id": widget.user_id,
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Not accept",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageForNeeder(
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

  accept() async {
    var response =
        await http.post(Uri.http("$local", "/test/accept_helper.php"), body: {
      "needer_id": widget.user_id,
      "helper_id": widget.id_helper,
      "service_id": my_data["service_id"],
      "service_item_id": my_data["service_item_id"],
      "city_id": my_data["city_id"],
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Accept",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageForNeeder(
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
            backgroundColor: Color(0xffF37970),
            //Theme.of(context).scaffoldBackgroundColor,
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
                        builder: (context) => HomePageForNeeder(
                              isArabic: widget.isArabic,
                              user_id: widget.user_id,
                            )));
              },
            ),
            title: Text(language[52], style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          body: Padding(
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
                          get_city(list[0]["city_id"]);
                          get_service(list[0]["service_id"]);
                          get_service_item(list[0]["service_item_id"]);
                          return Column(
                            children: [
                              Center(
                                child: Column(
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
                                              color: Colors.black
                                                  .withOpacity(0.1)),
                                        ],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "http://$local/test/uploads/helper/${list[0]['image']}"),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${list[0]["first_name"]} ${list[0]["middle_name"]} ${list[0]["last_name"]}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              newMethod("${language[28]}:", list[0]["email"]),
                              newMethod("${language[18]}:", list[0]["phone"]),
                              newMethod("${language[42]}", my_city),
                              newMethod("${language[48]}:", my_service),
                              newMethod("${language[49]}:", my_service_item),
                              newMethod("${language[44]}", list[0]["gender"]),
                              newMethod(language[51], list[0]["point1"]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    child: Text(
                                      language[60],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    color: Color(0xffF37970),
                                    onPressed: () {
                                      accept();
                                    },
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  RaisedButton(
                                    child: Text(
                                      language[61],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    color: Color(0xffF37970),
                                    onPressed: () {
                                      disable_accept();
                                    },
                                  ),
                                ],
                              )
                            ],
                          );
                        })
                    : Center(child: CircularProgressIndicator());
              },
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
