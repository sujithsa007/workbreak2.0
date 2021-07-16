/// Author : Sujith S A
/// Created on : 27th Apr 2021

/// This is the main screen of the application. It show the clock from clock.dart
/// and also displays options to users to set the work timing and breaks taken in
/// between. The clock theme is also triggered to a new scheme once the user starts working

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:work_break/controllers/clock_controller.dart';
// import 'package:work_break/controllers/text_to_speech_controller.dart';
import 'package:work_break/views/clock.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClockController _clockController = Get.put(ClockController());
  /* final TextToSpeechController _textToSpeechController =
      Get.put(TextToSpeechController());*/
  Widget build(BuildContext context) {
    var _mediaQueryHeight = MediaQuery.of(context).size.height;
    var _mediaQueryWidth = MediaQuery.of(context).size.width;
    double _fontSizeTitle = _mediaQueryHeight > 550 ? 22 : 18;
    // double _fontSizeSubtitle = _mediaQueryHeight > 550 ? 16 : 12;
    double _fontSizeBullet = _mediaQueryHeight > 550 ? 12 : 8;
    double _fontButton = _mediaQueryHeight > 550 ? 22 : 16;
    double _topMargin = _mediaQueryHeight > 550
        ? _mediaQueryHeight * .01
        : _mediaQueryHeight * .01;

    double _opacity = 0.8;

    Color _textColor = Colors.black;

    print(_mediaQueryHeight);

    var _workOptions = <String>[
      "30 mins    ",
      "45 mins    ",
      "60 mins    ",
      "75 mins    ",
      "90 mins    ",
      "105 mins    ",
      "120 mins    ",
      "135 mins    ",
      "150 mins    ",
      "165 mins    ",
      "180 mins    ",
    ];

    var _intervalOptions = <String>[
      "5 mins    ",
      "10 mins    ",
      "15 mins    ",
      "20 mins    ",
      "25 mins    ",
      "30 mins    ",
      "35 mins    ",
      "40 mins    ",
      "45 mins    ",
      "50 mins    ",
      "55 mins    ",
      "60 mins    ",
    ];

    _onSelectedWorkInterval(selected) {
      _clockController.setIntervalTime = selected;
    }

    _onSelectedWorkTime(String selected) {
      _clockController.setWorkTime = selected;
    }

    // ignore: slash_for_doc_comments
    /**
     * Widgets Used
     */

    TextSpan _headerSpanText(String name, Color color, double fontSize) =>
        TextSpan(
          text: name,
          style: TextStyle(
              fontSize: fontSize,
              color: color,
              // fontWeight: FontWeight.bold,
              fontFamily: 'Future'),
        );

    Container _backgroundImage = Container(
      height: _mediaQueryHeight,
      width: _mediaQueryWidth,
      child: Opacity(
        opacity: 0.9,
        child: FittedBox(
            fit: BoxFit.fill,
            child: Image.asset('assets/bgImg.jpg',
                color: Color.fromRGBO(255, 255, 255, 0.9),
                colorBlendMode: BlendMode.modulate)),
      ),
    );

    Container _drawer = Container(
        color: Colors.grey,
        width: MediaQuery.of(context).size.height * .2,
        // height: MediaQuery.of(context).size.height * .5,
        child: SafeArea(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.green,
                        ),
                        margin: EdgeInsets.only(left: 10, right: 10),
                      ),
                      Text(
                        'Info',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    size: 20,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ));

    RichText _appBarTitle = RichText(
      text: TextSpan(children: [
        _headerSpanText('W', Colors.black, 35),
        _headerSpanText('O', Colors.black, 32),
        _headerSpanText('R', Colors.black, 30),
        _headerSpanText('K  ', Colors.black, 27),
        _headerSpanText('B', Colors.black, 23),
        _headerSpanText('R', Colors.black, 27),
        _headerSpanText('E', Colors.black, 30),
        _headerSpanText('A', Colors.black, 32),
        _headerSpanText('K', Colors.black, 35),
      ]),
    );

    Container _optionsContainer(String title, var options, int selector) =>
        Container(
          margin: EdgeInsets.only(left: 8, right: 8),
          width: _mediaQueryWidth * .98,
          padding: EdgeInsets.only(bottom: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
                colors: _clockController.buttonChange == false
                    ? [
                        Colors.greenAccent.withOpacity(_opacity),
                        Colors.white.withOpacity(_opacity),
                        Colors.greenAccent.withOpacity(_opacity)
                      ]
                    : [
                        Colors.blue.withOpacity(_opacity),
                        Colors.white.withOpacity(_opacity),
                        Colors.blue.withOpacity(_opacity)
                      ]),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.5, 2.0)),
            ],
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: _mediaQueryWidth,
                margin: EdgeInsets.only(left: 10, bottom: 10, top: 5),
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _fontSizeTitle,
                      color: _textColor,
                      fontFamily: 'Future'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: RadioButtonGroup(
                      labels: options,
                      orientation: GroupedButtonsOrientation.HORIZONTAL,
                      labelStyle: TextStyle(
                          fontSize: _fontSizeBullet,
                          color: _textColor,
                          fontWeight: FontWeight.w700),
                      activeColor: _textColor,
                      onSelected: (String selected) {
                        selector == 1
                            ? _onSelectedWorkTime(selected)
                            : _onSelectedWorkInterval(selected);
                      }),
                ),
              ),
            ],
          ),
        );

    Container _confirmButton = Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      width: _mediaQueryWidth * .2,
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: _clockController.buttonChange == false
                    ? [Colors.greenAccent, Colors.white, Colors.greenAccent]
                    : [Colors.blue, Colors.white, Colors.blue]),
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
        child: ElevatedButton(
          child: Text(
            _clockController.buttonChange == false
                ? 'S t a r t   W o r k i n g'
                : 'C h a n g e   T i m i n g s',
            style: TextStyle(color: _textColor, fontFamily: 'Future'),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.black,
            splashFactory: InkRipple.splashFactory,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            elevation: 5,
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: _fontButton,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            await _clockController.onClickStartWork(
                _clockController.selectedWorkTime,
                _clockController.selectedWorkInterval);
            setState(() {});
          },
        ),
      ),
    );

    Container _bannerArea = Container(
      width: _mediaQueryWidth,
      height: _mediaQueryHeight * 0.08,
      color: Colors.transparent,
      child: Center(
        child: AdWidget(
          ad: _clockController.ad,
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _backgroundImage,
          Column(
            children: [
              Container(
                height: _mediaQueryHeight * 0.92,
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    // drawer: _drawer,
                    appBar: AppBar(
                      title: _appBarTitle,
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                    ),
                    body: ListView(
                      children: [
                        Align(
                          child: Container(
                              margin: EdgeInsets.only(bottom: _topMargin),
                              width: _mediaQueryWidth * .6,
                              height: _mediaQueryWidth * .6,
                              child: ClockScreen()),
                          alignment: Alignment.topCenter,
                        ),
                        _optionsContainer(
                            'W O R K    T I M E', _workOptions, 1),
                        SizedBox(
                          height: 15,
                        ),
                        _optionsContainer(
                            'B R E A K   T I M E ', _intervalOptions, 2),
                        Platform.isIOS
                            ? SizedBox(
                                height: 35,
                              )
                            : SizedBox(
                                height: 15,
                              ),
                        _confirmButton,
                        SizedBox(height: 15),
                      ],
                    )),
              ),
              Container(
                child: _bannerArea,
              )
            ],
          ),
        ],
      ),
    );
  }
}
