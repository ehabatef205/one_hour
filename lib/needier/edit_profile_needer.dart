import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_management/const.dart';
import '../arabicAndEnglish.dart';
import 'profile_needer.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class SettingNeederNeeder extends StatefulWidget {
  final bool isArabic;
  final list;

  SettingNeederNeeder({this.isArabic, this.list});

  @override
  _SettingNeederNeederState createState() => _SettingNeederNeederState();
}

class _SettingNeederNeederState extends State<SettingNeederNeeder> {
  File _image;
  final picker = ImagePicker();

  String gender;

  final form_key = GlobalKey<FormState>();

  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();

  Future choiceImage() async {
    var pickerImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickerImage.path);
    });

    print("old ${_image.path.split('/').last}");

    _image = await change_file_name_only(_image, widget.list["id"]);

    print("new ${_image.path.split('/').last}");
  }

  Future<File> change_file_name_only(File file, String new_file_name) async {
    var image_path = file.path;
    var last_separator = image_path.lastIndexOf(Platform.pathSeparator);
    var new_path = image_path.substring(0, last_separator + 1) +
        new_file_name +
        '.' +
        _image.path.split('.').last;
    return file.rename(new_path);
  }

  List language;

  @override
  void initState() {
    setState(() {
      firstName.text = widget.list["first_name"];
      middleName.text = widget.list["middle_name"];
      lastName.text = widget.list["last_name"];
      phone.text = widget.list["phone"];
      gender = widget.list["gender"];
      if (widget.isArabic) {
        language = ArabicAndEnglish.signUpHelperArabic;
      } else {
        language = ArabicAndEnglish.signUpHelperEnglish;
      }
    });
    super.initState();
  }

  Future editProfile() async {
    var response =
        await http.post(Uri.http("$local", "/test/update_profile.php"), body: {
      "id": widget.list["id"],
      "first_name": firstName.text,
      "middle_name": middleName.text,
      "last_name": lastName.text,
      "phone": phone.text,
      "gender": gender,
      "image":
          _image == null ? widget.list["image"] : _image.path.split('/').last,
    });

    if (response.statusCode == 200) {
      print('Account is updated');
    } else {
      print('Account is not updated');
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePageNeeder(
                isArabic: widget.isArabic, user_id: widget.list["id"])));
  }

  Future uploadImage() async {
    final uri = Uri.parse("http://$local/test/upload_image_needer.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = widget.list["id"];
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    print(widget.list["id"]);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploded');
    } else {
      print('Image Not Uploded');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePageNeeder(
                        isArabic: widget.isArabic,
                        user_id: widget.list["id"],
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
                          builder: (context) => ProfilePageNeeder(
                                isArabic: widget.isArabic,
                                user_id: widget.list["id"],
                              )));
                },
              ),
              title: Text(language[54], style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: form_key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              child: Container(
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
                                        color: Colors.black.withOpacity(0.1)),
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _image == null
                                        ? NetworkImage(
                                            "http://$local/test/uploads/needer/${widget.list['image']}")
                                        : FileImage(_image),
                                  ),
                                ),
                              ),
                              onTap: () {
                                choiceImage();
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Color(0xffF37970)),
                                /*Colors.purple*/
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: firstName,
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
                          } else if (value.length > 11) {
                            return language[21];
                          } else if (value.length < 11) {
                            return language[22];
                          }
                          return null;
                        },
                      ),
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
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                          child: Text(
                            language[53],
                            style: TextStyle(color: Colors.white),
                          ),
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Color(0xffF37970),
                          onPressed: () {
                            if (form_key.currentState.validate()) {
                              form_key.currentState.save();
                              _image == null ? () {} : uploadImage();
                              // ignore: unnecessary_statements
                              editProfile();
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
