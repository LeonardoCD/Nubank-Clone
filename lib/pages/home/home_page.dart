import 'package:flutter/material.dart';
import 'package:nubanckClone/pages/home/widgets/bottom_menu/botton_menu.dart';
import 'package:nubanckClone/pages/home/widgets/menu/menu_app.dart';
import 'package:nubanckClone/pages/home/widgets/my_app_bar.dart';
import 'package:nubanckClone/pages/home/widgets/page_view/my_dots_app.dart';
import 'package:nubanckClone/pages/home/widgets/page_view/page_view_app.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showMenu;
  int _currentIndex;
  double _yPosition;

  @override
  void initState() {
    super.initState();
    _showMenu = false;
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    if (_yPosition == null) {
      _yPosition = _screenHeight * .24;
    }
    return Scaffold(
      backgroundColor: Colors.purple[800],
      body: Stack(
        children: <Widget>[
          MyAppBar(
            showMenu: _showMenu,
            onTap: () {
              setState(() {
                _showMenu = !_showMenu;
                _yPosition =
                    _showMenu ? _screenHeight * .75 : _screenHeight * .24;
              });
            },
          ),
          MenuApp(
            top: _screenHeight * .18,
            showMenu: _showMenu,
          ),
          BottonMenu(
            showMenu: _showMenu,
          ),
          MyDotsApp(
            showMenu: _showMenu,
            top: _screenHeight * .75,
            currentIndex: _currentIndex,
          ),
          PageViewApp(
            showMenu: _showMenu,
            top: _yPosition,
            onChanged: (index) {
              setState(() => _currentIndex = index);
            },
            onPanUpdate: (details) {
              double positionBottonLimit = _screenHeight * .75;
              double positionTopLimit = _screenHeight * .24;
              double middlePosition = positionBottonLimit - positionTopLimit;
              middlePosition = middlePosition / 2;
              setState(() {
                _yPosition += details.delta.dy;

                _yPosition = _yPosition < positionTopLimit
                    ? positionTopLimit
                    : _yPosition;

                _yPosition = _yPosition > positionBottonLimit
                    ? positionBottonLimit
                    : _yPosition;

                if (_yPosition != positionBottonLimit && details.delta.dy > 0) {
                  _yPosition =
                      _yPosition > positionTopLimit + middlePosition - 50
                          ? positionBottonLimit
                          : _yPosition;
                }

                if (_yPosition != positionTopLimit && details.delta.dy < 0) {
                  _yPosition = _yPosition < positionBottonLimit - middlePosition
                      ? positionTopLimit
                      : _yPosition;
                }

                if (_yPosition == positionBottonLimit) {
                  _showMenu = true;
                } else if (_yPosition == positionTopLimit) {
                  _showMenu = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
