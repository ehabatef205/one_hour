import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:time_management/const.dart';
import '../arabicAndEnglish.dart';
import 'home_page_needer.dart';
import 'dart:ui' as ui;

class NeederForm extends StatefulWidget {
  final bool isArabic;
  final String user_id;
  final bool is_update;

  NeederForm({this.isArabic, this.user_id, this.is_update});

  @override
  _NeederForm createState() => _NeederForm();
}

class _NeederForm extends State<NeederForm> {
  TextEditingController address = TextEditingController();
  TextEditingController comment = TextEditingController();
  final form_key = GlobalKey<FormState>();
  String user_city;
  String user_service;
  String user_service_item;
  List cities = List();
  String city_id;
  List services = List();
  String service_id;
  List service_items = List();
  String service_item_id;
  var user_data;
  List language;
  bool is_loading = false;

  @override
  void initState() {
    setState(() {
      if (widget.isArabic) {
        language = ArabicAndEnglish.formArabic;
      } else {
        language = ArabicAndEnglish.formEnglish;
      }
    });
    super.initState();
    getCities();
    getServices();
    if (widget.is_update) {
      getData().whenComplete(() {
        setState(() {
          is_loading = true;
        });
      });
    }
  }

  Future getData() async {
    var response = await http.post(Uri.http("$local", "/test/profile.php"),
        body: {"id": widget.user_id});
    var data = json.decode(response.body);
    setState(() {
      user_data = data[0];
      user_city = user_data["city_id"];
      user_service = user_data["service_id"];
      user_service_item = user_data["service_item_id"];
      address.text = user_data["address"];
      comment.text = user_data["comment"];
    });
    getServiceItems(user_service);
    return "Success";
  }

  Future getCities() async {
    var response = await http.get(Uri.http("$local", "/test/cities.php"));
    setState(() {
      cities = json.decode(response.body);
    });
    return "Success";
  }

  Future getServices() async {
    var response = await http.get(Uri.http("$local", "/test/services.php"));
    setState(() {
      services = json.decode(response.body);
    });
    return "Success";
  }

  Future getServiceItems(String service_id2) async {
    var response =
        await http.post(Uri.http("$local", "/test/service_items.php"), body: {
      "service_id": service_id2,
    });
    setState(() {
      service_items = json.decode(response.body);
    });
    return "Success";
  }

  update_form() async {
    var response =
        await http.post(Uri.http("$local", "/test/update_form.php"), body: {
      "id": widget.user_id,
      "service_id": service_id == null ? user_service : service_id,
      "service_item_id":
          service_item_id == null ? user_service_item : service_item_id,
      "city_id": city_id == null ? user_city : city_id,
      "address": address.text,
      "comment": comment.text,
    });

    if (response.statusCode == 200) {
      print('Form is updated');
    } else {
      print('Form is not updated');
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePageForNeeder(
                isArabic: widget.isArabic, user_id: widget.user_id)));
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
            title: Text(language[0], style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
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
          body: widget.is_update
              ? is_loading
                  ? ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: form_key,
                            child: Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Text(
                                        language[3],
                                        style: new TextStyle(fontSize: 20.0),
                                      ),
                                      DropdownButton(
                                        value: service_id == null
                                            ? user_service
                                            : service_id,
                                        hint: Text(language[7]),
                                        items: services.map((service) {
                                          return DropdownMenuItem(
                                            child: Text(service[widget.isArabic
                                                ? "service_name_ar"
                                                : "service_name_en"]),
                                            value: service["service_id"],
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            service_id = newValue;
                                            getServiceItems(service_id);
                                            user_service_item = null;
                                          });

                                          print(service_id);
                                        },
                                      )
                                    ]),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      language[4],
                                      style: new TextStyle(fontSize: 20.0),
                                    ),
                                    DropdownButton(
                                      value: service_item_id == null
                                          ? user_service_item
                                          : service_item_id,
                                      hint: Text(language[8]),
                                      items: service_items.map((service_item) {
                                        return DropdownMenuItem(
                                          child: Text(service_item[
                                              widget.isArabic
                                                  ? "service_item_ar"
                                                  : "service_item_en"]),
                                          value:
                                              service_item["service_item_id"],
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          service_item_id = newValue;
                                        });

                                        print(service_item_id);
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      language[5],
                                      style: new TextStyle(fontSize: 20.0),
                                    ),
                                    DropdownButton(
                                      value:
                                          city_id == null ? user_city : city_id,
                                      hint: Text(language[9]),
                                      items: cities.map((city) {
                                        return DropdownMenuItem(
                                          child: Text(city[widget.isArabic
                                              ? "city_name_ar"
                                              : "city_name_en"]),
                                          value: city["city_id"],
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          city_id = newValue;
                                        });

                                        print(city_id);
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: address,
                                  onChanged: (value) {
                                    value = address.text;
                                  },
                                  textDirection: ui.TextDirection.ltr,
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
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: BorderSide(
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                            width: 1),
                                      ),
                                      prefixIcon: Icon(Icons.account_circle,
                                          color: Color(0xffF37970)),
                                      labelText: language[11],
                                      labelStyle: TextStyle(color: Colors.grey),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: language[12]),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return language[13];
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: comment,
                                  onChanged: (value) {
                                    value = comment.text;
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
                                      labelText: language[16],
                                      labelStyle: TextStyle(color: Colors.grey),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: language[15]),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return language[17];
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RaisedButton(
                                  child: Text(
                                    language[6],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  color: Color(0xffF37970),
                                  onPressed: () {
                                    if (form_key.currentState.validate()) {
                                      form_key.currentState.save();
                                      update_form();
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    )
              : ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: form_key,
                        child: Column(
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    language[3],
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                  DropdownButton(
                                    value: service_id,
                                    hint: Text(language[7]),
                                    items: services.map((service) {
                                      return DropdownMenuItem(
                                        child: Text(service[widget.isArabic
                                            ? "service_name_ar"
                                            : "service_name_en"]),
                                        value: service["service_id"],
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        service_id = newValue;
                                        getServiceItems(service_id);
                                      });

                                      print(service_id);
                                    },
                                  )
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  language[4],
                                  style: new TextStyle(fontSize: 20.0),
                                ),
                                DropdownButton(
                                  value: service_item_id,
                                  hint: Text(language[8]),
                                  items: service_items.map((service_item) {
                                    return DropdownMenuItem(
                                      child: Text(service_item[widget.isArabic
                                          ? "service_item_ar"
                                          : "service_item_en"]),
                                      value: service_item["service_item_id"],
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      service_item_id = newValue;
                                    });

                                    print(service_item_id);
                                  },
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  language[5],
                                  style: new TextStyle(fontSize: 20.0),
                                ),
                                DropdownButton(
                                  value: city_id,
                                  hint: Text(language[9]),
                                  items: cities.map((city) {
                                    return DropdownMenuItem(
                                      child: Text(city[widget.isArabic
                                          ? "city_name_at"
                                          : "city_name_en"]),
                                      value: city["city_id"],
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      city_id = newValue;
                                    });

                                    print(city_id);
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: address,
                              onChanged: (value) {
                                value = address.text;
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
                                  labelText: language[11],
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: language[12]),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return language[13];
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: comment,
                              onChanged: (value) {
                                value = comment.text;
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
                                  labelText: language[16],
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: language[15]),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return language[17];
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              child: Text(
                                language[10],
                                style: TextStyle(color: Colors.white),
                              ),
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: Color(0xffF37970),
                              onPressed: () {
                                if (form_key.currentState.validate()) {
                                  form_key.currentState.save();
                                  update_form();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
/*
TextFormField(
                                                        controller: address,
                                                        onChanged: (value) {
                                                          value = address.text;
                                                        },
                                                        textDirection: ui
                                                            .TextDirection.ltr,
                                                        decoration:
                                                            InputDecoration(
                                                                focusedErrorBorder: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .red,
                                                                        style: BorderStyle
                                                                            .solid,
                                                                        width:
                                                                            1)),
                                                                errorBorder: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .red,
                                                                        style: BorderStyle
                                                                            .solid,
                                                                        width:
                                                                            1)),
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                    borderSide: BorderSide(
                                                                        color: Colors.grey[500],
                                                                        style: BorderStyle.solid,
                                                                        width: 1)),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      style: BorderStyle
                                                                          .solid,
                                                                      width: 1),
                                                                ),
                                                                prefixIcon: Icon(Icons.account_circle, color: Color(0xffF37970)),
                                                                labelText: language[11],
                                                                labelStyle: TextStyle(color: Colors.grey),
                                                                hintStyle: TextStyle(color: Colors.grey),
                                                                hintText: language[12]),
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return language[13];
                                                          }
                                                          return null;
                                                        },
                                                      ),
 */
