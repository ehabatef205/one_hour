import 'package:flutter/material.dart';
import 'package:time_management/helper/home_page_helper.dart';
import 'package:time_management/arabicAndEnglish.dart';
import 'dart:ui' as ui;

class Awards extends StatefulWidget {
  @override
  _AwardsState createState() => _AwardsState();
}

class _AwardsState extends State<Awards> {
  List language;

  bool isLoading = false;

  List arabic = ["الجوائز"];

  List english = ["Awards"];

  @override
  void initState() {
    ArabicAndEnglish.getValidationData().whenComplete(() async {
      setState(() {
        if(ArabicAndEnglish.isArabic){
          language = arabic;
          isLoading = true;
        }else{
          language = english;
          isLoading = true;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePageForHelper()));
      },
      child: isLoading
          ? Directionality(
        textDirection: ArabicAndEnglish.isArabic
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePageForHelper()));
              },
            ),
            backgroundColor: Color(0xffF37970),
          ),
          body: ListView(
            children: [
              ListTile(
                title: Text("تليفون"),
                trailing: Text("500"),
              ),
            ],
          )
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
