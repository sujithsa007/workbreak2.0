/// Author : Sujith S A
/// Created on : 28th Apr 2021

/// This class creates a clock,which shows current device time with seconds shown in clockwise rotational animation.
/// It will be integrated into the main home screen

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:work_break/controllers/work_break_controller.dart';

class AnimatedClockScreen extends StatelessWidget {
  final WorkBreakController _workBreakController =
      Get.put(WorkBreakController());

  @override
  Widget build(BuildContext context) {
    double _mediaQueryHeight = MediaQuery.of(context).size.height;
    double _mediaQueryWidth = MediaQuery.of(context).size.width;
    double _lineWidth = _mediaQueryWidth * .03;

    Center _displayTime(clockController) => Center(
          child: Container(
              padding: const EdgeInsets.all(36.0),
              width: _mediaQueryWidth * .45,
              height: _mediaQueryWidth * .4,
              child: Center(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: clockController.currentTimeToDisplay,
                      style: TextStyle(
                        fontSize: _mediaQueryHeight > 550 ? 25 : 20,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' ' + clockController.amPmToDisplay,
                      style: TextStyle(
                          fontSize: _mediaQueryHeight > 550 ? 15 : 9,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              )),
        );

    Center _clockRing(double radiusMultiplier, bg1, bg2, pc1, pc2) => Center(
          child: CircularPercentIndicator(
            radius: _mediaQueryWidth * radiusMultiplier,
            lineWidth: _lineWidth,
            animation: true,
            percent: _workBreakController.buttonChange == false
                ? _workBreakController.secondsForAnimation
                : 1.0,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: _workBreakController.clockThemeTrigger ? bg1 : bg2,
            progressColor: _workBreakController.clockThemeTrigger ? pc1 : pc2,
          ),
        );

    Center _remainingTime(remainingTime, message) => Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: new TextSpan(
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: '$message\n',
                    style: new TextStyle(
                      fontSize: _mediaQueryHeight > 600 ? 16 : 12,
                      fontWeight: FontWeight.w700,
                      color: message == 'Start working in'
                          ? Colors.red
                          : Colors.black,
                    )),
                TextSpan(
                    text: remainingTime.length == 0
                        ? ''
                        : remainingTime.split('.')[0],
                    style: new TextStyle(
                        color: message == 'Start working in'
                            ? Colors.red
                            : Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text: remainingTime.length == 0
                        ? ''
                        : remainingTime.split('.')[1].split('&')[0],
                    style: new TextStyle(
                        color: message == 'Start working in'
                            ? Colors.red
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text: ' ',
                    style: new TextStyle(
                      fontSize: 12,
                    )),
                TextSpan(
                    text: remainingTime.length == 0
                        ? ''
                        : remainingTime.split('&')[1].split(',')[0],
                    style: new TextStyle(
                        color: message == 'Start working in'
                            ? Colors.red
                            : Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text: remainingTime.length == 0
                        ? ''
                        : remainingTime.split(',')[1],
                    style: new TextStyle(
                        color: message == 'Start working in'
                            ? Colors.red
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() => Container(
              child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.transparent,
                  ),
                ),
              ),
              _workBreakController.buttonChange == false
                  ? _displayTime(_workBreakController)
                  : _workBreakController.remainingTime == '0.min&0,sec'
                      ? _remainingTime(_workBreakController.remainingInterval,
                          'Start working in')
                      : _remainingTime(_workBreakController.remainingTime,
                          'Take a break in'),
              _clockRing(0.42, Colors.transparent, Colors.transparent,
                  Colors.blue, Colors.green),
              _clockRing(0.48, Colors.transparent, Colors.transparent,
                  Colors.white, Colors.white),
              _clockRing(0.54, Colors.transparent, Colors.transparent,
                  Colors.blue, Colors.green),
              Opacity(
                opacity: .25,
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => RadialGradient(
                      center: Alignment.center,
                      radius: .1,
                      colors: _workBreakController.clockThemeTrigger
                          ? [Colors.blue, Colors.blueAccent]
                          : [Colors.green, Colors.greenAccent],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds),
                    child: Icon(
                      Icons.ac_unit,
                      color: _workBreakController.clockThemeTrigger
                          ? Colors.blue
                          : Colors.amber,
                      size: _mediaQueryWidth * .44,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
              ),
            ],
          ))),
    );
  }
}
