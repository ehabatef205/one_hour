import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/const.dart';
import 'dart:ui' as ui;
import '../arabicAndEnglish.dart';
import 'home_page_needer.dart';

class SignUpNeeder extends StatefulWidget {
  final bool isArabic;

  const SignUpNeeder({this.isArabic});
  @override
  _SignUpNeederState createState() => _SignUpNeederState();
}

class _SignUpNeederState extends State<SignUpNeeder> {
  final form_key = GlobalKey<FormState>();
  String gender;
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController ssn = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  var data;
  List language;

  @override
  void initState() {
    _passwordVisible = false;
    setState(() {
      if (widget.isArabic) {
        language = ArabicAndEnglish.signUpHelperArabic;
      } else {
        language = ArabicAndEnglish.signUpHelperEnglish;
      }
    });
    super.initState();
  }

  Future register() async {
    try {
      var response =
      await http.post(Uri.http("$local", "/test/register.php"), body: {
        "first_name": firstName.text,
        "middle_name": middleName.text,
        "last_name": lastName.text,
        "ssn": ssn.text,
        "phone": phone.text,
        "email": email.text,
        "password": password.text,
        "gender": gender,
        "image": "start.png",
        "point1": "0",
        "user_type": "needer",
        "is_accept": "0"
      });

      data = await json.decode(response.body);

      print("Hi ${data[0]["id"]}");

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: language[56],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        keepLogIn();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePageForNeeder(
                  isArabic: widget.isArabic,
                  user_id: data[0]['id'].toString(),
                )));
      } else {
        Fluttertoast.showToast(
            msg: language[55],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  bool _passwordVisible;

  Future keepLogIn() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.setString("user_id", data[0]['id']);
    sharedPreferences.setBool("helper", false);
  }

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
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: form_key,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: firstName,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        value = firstName.text;
                      },
                      textDirection: ui.TextDirection.ltr,
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
                          prefixIcon: Icon(Icons.account_circle,
                              color: Color(0xffF37970)),
                          labelText: language[1],
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: language[2]),
                      validator: (value) {
                        if (value.isEmpty) {
                          return language[3];
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: middleName,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        value = middleName.text;
                      },
                      textDirection: ui.TextDirection.ltr,
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
                          prefixIcon: Icon(Icons.account_circle,
                              color: Color(0xffF37970)),
                          labelText: language[4],
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: language[5]),
                      validator: (value) {
                        if (value.isEmpty) {
                          return language[6];
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: lastName,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        value = lastName.text;
                      },
                      textDirection: ui.TextDirection.ltr,
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
                          prefixIcon: Icon(Icons.account_circle,
                              color: Color(0xffF37970)),
                          labelText: language[7],
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: language[8]),
                      validator: (value) {
                        if (value.isEmpty) {
                          return language[9];
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: ssn,
                      textDirection: ui.TextDirection.ltr,
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
                        prefixIcon: Icon(Icons.mark_chat_read_rounded,
                            color: Color(0xffF37970)),
                        labelText: language[13],
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: language[14],
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        value = ssn.text;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return language[15];
                        }
                        /*else if (value.length > 14) {
                                return language[16];
                              } else if (value.length < 14) {
                                return language[17];
                              }*/
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: phone,
                      onChanged: (value) {
                        value = phone.text;
                      },
                      textDirection: ui.TextDirection.ltr,
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
                        prefixIcon:
                        Icon(Icons.local_phone, color: Color(0xffF37970)),
                        labelText: language[18],
                        hintText: language[19],
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return language[20];
                        }
                        /*else if (value.length > 11) {
                                return language[21];
                              } else if (value.length < 11) {
                                return language[22];
                                // } else if (value.characters != [0 | 1 | 2 | 5]) {
                                //   return 'phone number must start with 0 or 1 or 2 or 5 characters long.';
                              }*/
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: ui.TextDirection.ltr,
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
                          labelText: language[28],
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon:
                          Icon(Icons.email, color: Color(0xffF37970)),
                          hintText: language[29]),
                      onChanged: (value) {
                        value = email.text;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return language[30];
                        }
                        if (!RegExp(
                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(value)) {
                          return language[31];
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: password,
                        obscureText: !_passwordVisible,
                        textDirection: ui.TextDirection.ltr,
                        //This will obscure text dynamically
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
                          prefixIcon:
                          Icon(Icons.lock, color: Color(0xffF37970)),
                          labelText: language[32],
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: language[33],
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
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          value = password.text;
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return language[34];
                          }
                          /*else if (value.length < 6) {
                                  return language[35];
                                  // } else if (value.Length > 15) {
                                  //  return 'Should not be more than 15 charcaters';
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(value)) {
                                  return language[36];
                                }*/
                          return null;
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: confirmPassword,
                        obscureText: !_passwordVisible,
                        textDirection: ui.TextDirection.ltr,
                        //This will obscure text dynamically
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
                          prefixIcon:
                          Icon(Icons.lock, color: Color(0xffF37970)),
                          labelText: language[37],
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: language[38],
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
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          value = confirmPassword.text;
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return language[39];
                          }
                          if (password.text != confirmPassword.text) {
                            return language[40];
                          }
                          return null;
                          //}
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          language[44],
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Expanded(
                          child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              value: "Female",
                              title: new Text(language[45]),
                              groupValue: gender,
                              onChanged: (newValue) {
                                setState(() {
                                  gender = newValue;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              value: "Male",
                              title: new Text(language[46]),
                              groupValue: gender,
                              onChanged: (newValue) {
                                setState(() {
                                  gender = newValue;
                                });
                              }),
                        ),
                      ],
                    ),
                    RaisedButton(
                      child: Text(
                        language[47],
                        style: TextStyle(color: Colors.white),
                      ),
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Color(0xffF37970),
                      onPressed: () {
                        if (form_key.currentState.validate()) {
                          form_key.currentState.save();
                          register();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
