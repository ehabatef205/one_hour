 import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsstate createState() => _AboutUsstate();
}

class _AboutUsstate extends State<AboutUs> {
  String text = "Our software will be filling this gap and the lake of attention of those elderly people, basically it will help you to reach those people and help them in your free time that you specified.\nIt’s a form of time management software that uses and manages your free time based on the free time’s duration itself and the prober service that you can offer.\nOur software will be in the form of Web/Mobile applications, which makes it accessible to all.\nThe applications will act as a hub for volunteers or helpers who want to offer charity services, the other targeted group of this hub are the elderly people or the help needers generally.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF37970),
        title: Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 3,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$text',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
