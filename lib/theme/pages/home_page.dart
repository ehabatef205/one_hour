import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_management/theme/models_providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  bool _switch = true;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  // function to toggle circle animation
  changeThemeMode(bool theme) async {
    if (!theme) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Now we have access to the theme properties
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isLightTheme) {
      setState(() {
        _switch = false;
      });
    } else {
      _switch = true;
    }
    Future theme() async {
      await themeProvider.toggleThemeData();
    }

    return Switch(
        activeColor: Color(0xffF37970),
        value: _switch,
        onChanged: (bool s3) {
          setState(() {
            _switch = s3;
          });
          theme().whenComplete((){
              changeThemeMode(themeProvider.isLightTheme);
            });
        });
  }
}
