import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_management/const.dart';
import '../arabicAndEnglish.dart';
import 'edit_profile_helper.dart';
import 'home_page_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class ProfilePageHelper extends StatefulWidget {
  final bool isArabic;
  final String user_id;

  ProfilePageHelper({this.isArabic, this.user_id});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageHelper> {
  List language;
  var data;

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

  Future getData() async {
    var response = await http.post(Uri.http("$local", "/test/profile.php"),
        body: {"id": widget.user_id});
    var data = json.decode(response.body);
    print(data);
    return json.decode(response.body);
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
            title: Text(language[52], style: TextStyle(color: Colors.white)),
            centerTitle: true,
            actions: [
              TextButton(
                child: Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePageHelper(
                                isArabic: widget.isArabic,
                                list: data,
                              )));
                },
              ),
            ],
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

                              data = list[0];
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
                                                  "http://$local/test/uploads/helper/${data['image']}"),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${data["first_name"]} ${data["middle_name"]} ${data["last_name"]}",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  newMethod("${language[13]}:", data["ssn"]),
                                  newMethod("${language[28]}:", data["email"]),
                                  newMethod("${language[18]}:", data["phone"]),
                                  newMethod("${language[44]}", widget.isArabic? data["gender"] == "Male"? "ذكر" : "أنثى" : data["gender"]),
                                  newMethod(language[51], data["point1"]),
                                ],
                              );
                            })
                        : Center(child: CircularProgressIndicator());
                  })),
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
