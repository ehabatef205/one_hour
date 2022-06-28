import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../arabicAndEnglish.dart';
import 'login_helper.dart';
import 'dart:ui' as ui;

class forgetHelper extends StatefulWidget {
  @override
  _forgetHelperState createState() => _forgetHelperState();
}

class _forgetHelperState extends State<forgetHelper> {
  final formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();

  bool verifyButton = false;
  String verifyLink;


  Future checkUser() async {
    var response =
        await http.post(Uri.http("http://192.168.1.13/onehour/checkHelper.php", ""), body: {
      "email": email.text,
    });

    var link = json.decode(response.body);
    if (link == "INVALIDUSER") {
      Fluttertoast.showToast(
          msg: language[8],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        verifyLink = link;
        verifyButton = true;
      });
      Fluttertoast.showToast(
          msg: language[7],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    print(link);
  }

  int newPassword = 0;

  Future resetPassword() async {
    var response = await http.post(Uri.http(verifyLink, ""));
    var link = json.decode(response.body);
    print(link);
    setState(() {
      newPassword = link;
      verifyButton = false;
    });
    Fluttertoast.showToast(
        msg: "${language[9]} $newPassword",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginHelperScreen()));
  }

  List language;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ArabicAndEnglish.getValidationData().whenComplete(() async {
      setState(() {
        if (ArabicAndEnglish.isArabic) {
          language = ArabicAndEnglish.arabicForget;
          isLoading = true;
        } else {
          language = ArabicAndEnglish.englishForget;
          isLoading = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Directionality(
      textDirection: ArabicAndEnglish.isArabic
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                language[0],
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
              backgroundColor: Color(0xffF37970),
              centerTitle: true,
            ),
            body: Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: email,
                      onChanged: (value) {
                        value = email.text;
                      },
                      textDirection: ui.TextDirection.ltr,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  color: Colors.red,
                                  style: BorderStyle.solid,
                                  width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  color: Colors.red,
                                  style: BorderStyle.solid,
                                  width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  color: Colors.grey[500],
                                  style: BorderStyle.solid,
                                  width: 1)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1),
                          ),
                          prefixIcon: Icon(Icons.email,
                              color: Color(0xffF37970)),
                          labelText: language[1],
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: language[2]),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return  language[3];
                        }
                        if (!RegExp(
                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(value)) {
                          return language[4];
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: RaisedButton(
                        onPressed: () {
                          if (formkey.currentState.validate()) {
                            formkey.currentState.save();
                            checkUser();
                          }
                        },
                        child: Text(
                          language[5],
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Color(0xffF37970),
                      ),
                    ),
                    verifyButton
                        ? Padding(
                            padding: EdgeInsets.all(8),
                            child: RaisedButton(
                              onPressed: () {
                                resetPassword();
                              },
                              child: Text(
                                language[6],
                                style: TextStyle(color: Colors.white),
                              ),
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.teal,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
    ) : Center(child: CircularProgressIndicator());
  }
}
