import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../arabicAndEnglish.dart';
import '../const.dart';
import 'home_page_helper.dart';
import 'dart:ui' as ui;

class EditPasswordHelper extends StatefulWidget {
  final String user_id;
  final bool isArabic;

  EditPasswordHelper({this.user_id, this.isArabic});

  @override
  _EditPasswordHelperState createState() => _EditPasswordHelperState();
}

class _EditPasswordHelperState extends State<EditPasswordHelper> {
  final form_key = GlobalKey<FormState>();
  TextEditingController old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController confirm_new_password = TextEditingController();

  updatePassword() {
    http.post(Uri.http("$local", "/test/edit_password.php"), body: {
      "id": widget.user_id,
      "password": new_password.text,
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePageForHelper(
                  isArabic: widget.isArabic,
                  user_id: widget.user_id,
                )));
  }

  Future getData() async {
    var response = await http.post(Uri.http("$local", "/test/profile.php"),
        body: {"id": widget.user_id});
    var data = json.decode(response.body);
    print(data);
    return json.decode(response.body);
  }

  List language;

  @override
  void initState() {
    setState(() {
      if (widget.isArabic) {
        language = ArabicAndEnglish.editPasswordArabic;
      } else {
        language = ArabicAndEnglish.editPasswordEnglish;
      }
    });
    super.initState();
  }

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          widget.isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffF37970),
            title: Text(
              language[0],
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          List list = snapshot.data;

                          var data = list[0];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: form_key,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: old_password,
                                      obscureText: !_passwordVisible,
                                      textDirection: ui.TextDirection.ltr,
                                      //This will obscure text dynamically
                                      decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                                color: Colors.red,
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                                color: Colors.red,
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                                color: Colors.grey[500],
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Color(0xffF37970)),
                                        labelText: language[1],
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        hintText: language[2],
                                        // Here is key idea
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Color(0xffF37970),
                                            // color: Theme.of(context).primaryColorDark,
                                          ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      onChanged: (value) {
                                        value = old_password.text;
                                      },
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return language[3];
                                        } else if (value.length < 6) {
                                          return language[4];
                                        } else if (value !=
                                            "${data["password"]}") {
                                          return language[6];
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: new_password,
                                      obscureText: !_passwordVisible,
                                      textDirection: ui.TextDirection.ltr,
                                      //This will obscure text dynamically
                                      decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                                color: Colors.red,
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                                color: Colors.red,
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                                color: Colors.grey[500],
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Color(0xffF37970)),
                                        labelText: language[7],
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        hintText: language[8],
                                        // Here is key idea
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Color(0xffF37970),
                                            // color: Theme.of(context).primaryColorDark,
                                          ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      onChanged: (value) {
                                        value = new_password.text;
                                      },
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return language[3];
                                        } else if (value.length < 6) {
                                          return language[4];
                                          // } else if (value.Length > 15) {
                                          //  return 'Should not be more than 15 charcaters';
                                        }
                                        /*else if (!RegExp(
                                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                          .hasMatch(value)) {
                                        return language[5];
                                      }*/
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: confirm_new_password,
                                      obscureText: !_passwordVisible,
                                      textDirection: ui.TextDirection.ltr,
                                      //This will obscure text dynamically
                                      decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                                color: Colors.red,
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                                color: Colors.red,
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                                color: Colors.grey[500],
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Color(0xffF37970)),
                                        labelText: language[9],
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        hintText: language[10],
                                        // Here is key idea
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Color(0xffF37970),
                                            // color: Theme.of(context).primaryColorDark,
                                          ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      onChanged: (value) {
                                        value = confirm_new_password.text;
                                      },
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return language[11];
                                        }
                                        if (new_password.text !=
                                            confirm_new_password.text) {
                                          return language[12];
                                        }
                                        return null;
                                        //}
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RaisedButton(
                                    child: Text(
                                      language[13],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    color: Color(0xffF37970),
                                    onPressed: () {
                                      if (form_key.currentState.validate()) {
                                        form_key.currentState.save();
                                        updatePassword();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    : Center(child: CircularProgressIndicator());
              })),
    );
  }
}
