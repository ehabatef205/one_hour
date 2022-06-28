import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management/const.dart';
import 'package:time_management/helper/home_page_helper.dart';
import 'package:time_management/welcome/welcome.dart';
import '../arabicAndEnglish.dart';
import 'forgetHelper.dart';
import 'signup_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class LoginHelperScreen extends StatefulWidget {
  final bool isArabic;

  const LoginHelperScreen({this.isArabic});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginHelperScreen> {
  final form_key = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var data;
  bool _passwordVisible;
  bool is_remember_me = false;

  Future remember() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("remember", true);
    sharedPreferences.setString("remember_email", email.text);
    sharedPreferences.setString("remember_password", password.text);
  }

  String remember_email = "";

  Future get_remember_email() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtained_email = sharedPreferences.getString("remember_email");

    setState(() {
      remember_email = obtained_email;
    });
  }

  String remember_password = "";

  Future get_remember_password() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtained_email = sharedPreferences.getString("remember_password");

    setState(() {
      remember_password = obtained_email;
    });
  }

  bool rememberMe = false;

  Future getRemember() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtained_email = sharedPreferences.getBool("remember");

    setState(() {
      rememberMe = obtained_email;
    });
  }

  List language;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    ArabicAndEnglish.getValidationData().whenComplete(() async {
      setState(() {
        if (ArabicAndEnglish.isArabic) {
          language = ArabicAndEnglish.arabicLogIn;
          isLoading = true;
        } else {
          language = ArabicAndEnglish.englishLogIn;
          isLoading = true;
        }
      });
    });
    getRemember().whenComplete(() {
      if (rememberMe != null) {
        if (rememberMe) {
          is_remember_me = true;
          get_remember_email().whenComplete(() {
            email.text = remember_email;
          });
          get_remember_password().whenComplete(() {
            password.text = remember_password;
          });
        } else {
          is_remember_me = false;
        }
      }
    });
  }

  Future logIn() async {
    var response =
        await http.post(Uri.http("$local", "/test/login.php"), body: {
      "email": email.text,
      "password": password.text,
    });

    data = json.decode(response.body);

    print("Hello $data");

    if (data == "There is an error in the login data") {
      Fluttertoast.showToast(
          msg: language[15],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: language[16],
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
              builder: (context) => HomePageForHelper(
                  isArabic: widget.isArabic,
                  user_id: data[0]['id'])));
    }
  }

  Future keepLogIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("user_id", data[0]['id']);
    sharedPreferences.setBool("helper", true);
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          language[1],
          style: TextStyle(
              color: Color(0xffF37970),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextFormField(
          textDirection: ui.TextDirection.ltr,
          keyboardType: TextInputType.emailAddress,
          controller: email,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 1)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Colors.grey[500],
                      style: BorderStyle.solid,
                      width: 1)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.grey, style: BorderStyle.solid, width: 1),
              ),
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.email, color: Color(0xffF37970)),
              hintText: language[2]),
          onChanged: (value) {
            value = email.text;
          },
          validator: (String value) {
            if (value.isEmpty) {
              return language[3];
            }
            if (!RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
              return language[4];
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          language[5],
          style: TextStyle(
              color: Color(0xffF37970),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextFormField(
            textDirection: ui.TextDirection.ltr,
            keyboardType: TextInputType.visiblePassword,
            controller: password,
            style: TextStyle(color: Colors.black),
            obscureText: !_passwordVisible,
            //This will obscure text dynamically
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 1)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Colors.grey[500],
                      style: BorderStyle.solid,
                      width: 1)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.grey, style: BorderStyle.solid, width: 1),
              ),
              prefixIcon: Icon(Icons.lock, color: Color(0xffF37970)),
              hintStyle: TextStyle(color: Colors.grey),
              hintText: language[6],
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Color(0xffF37970),
                ),
                onPressed: () {
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
                return language[7];
              } else if (value.length < 6) {
                return language[8];
                // } else if (value.Length > 15) {
                //  return 'Should not be more than 15 charcaters';
              }
              return null;
            })
      ],
    );
  }

  Widget buildForGetPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          // ignore: deprecated_member_use
          child: FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => forgetHelper()));
              },
              padding: EdgeInsets.only(right: 0.0),
              child: Text(
                language[10],
                style: TextStyle(
                    color: Color(0xffF37970), fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }

  Widget buildRememberMe() {
    return Container(
      height: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Color(0xffF37970)),
            child: Checkbox(
                value: is_remember_me,
                checkColor: Color(0xffF37970),
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    is_remember_me = value;
                  });
                }),
          ),
          Text(
            language[11],
            style: TextStyle(
                color: Color(0xffF37970), fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: RaisedButton(
        elevation: 5,
        onPressed: () async {
          if (form_key.currentState.validate()) {
            form_key.currentState.save();
            if (is_remember_me) {
              remember();
            } else {
              final SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.setBool("remember", false);
            }
            logIn();
          }
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: Text(
          language[12],
          style: TextStyle(
              color: Color(0xffF37970),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildSignUpBtn() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(language[13],
          style: TextStyle(
              color: Color(0xffF37970),
              fontSize: 18,
              fontWeight: FontWeight.w500)),
      TextButton(
        child: Text(language[14],
            style: TextStyle(
                color: Color(0xffF37970),
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpHelper(isArabic: widget.isArabic)));
        },
      ),
    ]);
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
                  iconTheme: IconThemeData(color: Color(0xffF37970)),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Welcome()));
                    },
                  ),
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                    child: Form(
                      key: form_key,
                      child: Column(
                        children: <Widget>[
                          Text(
                            language[0],
                            style: TextStyle(
                                color: Color(0xffF37970),
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          buildEmail(),
                          SizedBox(height: 10),
                          buildPassword(),
                          buildForGetPassword(),
                          buildRememberMe(),
                          buildLoginBtn(),
                          buildSignUpBtn(),
                        ],
                      ),
                    ),
                  ),
                )),
          )
        : Center(child: CircularProgressIndicator());
  }
}
