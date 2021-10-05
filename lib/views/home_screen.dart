/// Author : Sujith S A
/// Created on : 27th Apr 2021

/// This is the main screen of the application. It show the clock from animated_clock.dart
/// and also displays options to users to set the work timing and breaks taken in
/// between. The clock theme is also triggered to a new scheme once the user starts working

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:work_break/controllers/work_break_controller.dart';
import 'package:work_break/utilities/tts_settings_screen.dart';
import 'package:work_break/views/animated_clock.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkBreakController _workBreakController =
      Get.put(WorkBreakController());

  Widget build(BuildContext context) {
    double _mediaQueryHeight = MediaQuery.of(context).size.height;
    double _mediaQueryWidth = MediaQuery.of(context).size.width;
    double _fontSizeTitle = _mediaQueryHeight > 550 ? 22 : 18;
    double _fontSizeBullet = _mediaQueryHeight > 550 ? 12 : 8;
    double _fontButton = _mediaQueryHeight > 550 ? 22 : 16;
    double _opacity = 0.8;
    Color _textColor = Colors.black;
    print(_mediaQueryHeight);

    TextSpan _headerSpanText(String name, Color color, double fontSize) =>
        TextSpan(
          text: name,
          style: TextStyle(fontSize: fontSize, color: color, fontFamily: ''),
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
                colors: _workBreakController.buttonChange == false
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
                      fontFamily: ''),
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
                            ? _workBreakController.onSelectedWorkTime(selected)
                            : _workBreakController
                                .onSelectedWorkInterval(selected);
                      }),
                ),
              ),
            ],
          ),
        );

    Container _customInputContainer(controller, onChangeFunction, hintText) =>
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          height: MediaQuery.of(context).size.height * .075,
          padding: EdgeInsets.only(
              left: 10, top: MediaQuery.of(context).size.height * .004),
          decoration: BoxDecoration(
            color: _workBreakController.buttonChange == false
                ? Colors.green.withOpacity(.3)
                : Colors.blue.withOpacity(.3),
            border: Border.all(
                color: Colors.grey, // set border color
                width: 2.0), // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)), // set rounded corner radius
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            maxLength: 3,
            controller: controller,
            onChanged: (value) {
              print(controller);
              if (controller == false) {
                _workBreakController.setWorkTimeInput('');
                _workBreakController.setBreakTimeInput('');
              }
              onChangeFunction(value);
            },
            decoration: InputDecoration(
              fillColor: Colors.grey,
              counterText: "",
              contentPadding: EdgeInsets.only(bottom: 5),
              hintText: hintText,
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black),
          ),
        );

    Container _confirmButton = Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      width: _mediaQueryWidth * .2,
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: _workBreakController.buttonChange == false
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
            _workBreakController.buttonChange == false
                ? 'S t a r t   W o r k i n g'
                : 'C h a n g e   T i m i n g s',
            style: TextStyle(color: _textColor, fontFamily: ''),
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
            if (_workBreakController.checkBoxValue == true) {
              await _workBreakController.setCustomTime();
            } else {
              print('in this loop');
              await _workBreakController.onClickStartWork(
                  _workBreakController.selectedWorkTime,
                  _workBreakController.selectedWorkInterval);
            }
            setState(() {});
          },
        ),
      ),
    );

    Container _bannerArea = Platform.isAndroid
        ? Container(
            width: _mediaQueryWidth,
            height: _mediaQueryHeight * 0.08,
            color: Colors.transparent,
            child: Center(
              child: AdWidget(
                ad: _workBreakController.ad,
              ),
            ),
          )
        : Container();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Obx(() => Stack(
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
                              actions: [
                                IconButton(
                                  icon: new Icon(Icons.settings),
                                  tooltip: 'Settings',
                                  onPressed: () => Get.to(
                                      TTSSettingsScreen()), // null disables the button
                                ),
                              ],
                              title: _appBarTitle,
                              centerTitle: true,
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                            ),
                            body: ListView(
                              children: [
                                Align(
                                  child: Container(
                                      width: _mediaQueryWidth * .6,
                                      height: _mediaQueryWidth * .6,
                                      child: AnimatedClockScreen()),
                                  alignment: Alignment.topCenter,
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      new Checkbox(
                                          value: _workBreakController
                                              .checkBoxValue,
                                          activeColor: _workBreakController
                                                      .buttonChange ==
                                                  false
                                              ? Colors.green
                                              : Colors.blue,
                                          onChanged: (bool newValue) {
                                            print(newValue);
                                            _workBreakController
                                                .setCheckBoxValue = newValue;
                                          }),
                                      Text(
                                        'Set Custom Time',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                _workBreakController.checkBoxValue == true
                                    ? _customInputContainer(
                                        _workBreakController
                                            .workTimeInputController,
                                        _workBreakController.setWorkTimeInput,
                                        'Enter Work time in minutes > 5')
                                    : Container(),
                                _workBreakController.checkBoxValue == true
                                    ? _customInputContainer(
                                        _workBreakController
                                            .breakTimeInputController,
                                        _workBreakController.setBreakTimeInput,
                                        'Enter Break time in minutes > 1')
                                    : Container(),
                                _workBreakController.checkBoxValue == false
                                    ? _optionsContainer('W O R K    T I M E',
                                        _workBreakController.workOptions, 1)
                                    : Container(),
                                SizedBox(
                                  height: 15,
                                ),
                                _workBreakController.checkBoxValue == false
                                    ? _optionsContainer('B R E A K   T I M E ',
                                        _workBreakController.intervalOptions, 2)
                                    : Container(),
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
              ))),
    );
  }
}
