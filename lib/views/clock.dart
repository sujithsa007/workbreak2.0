/// Author : Sujith S A
/// Created on : 28th Apr 2021

/// This class creates a clock,which shows current device time with seconds shown in clockwise rotational animation.
/// It will be integrated into the main home screen

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:work_break/controllers/clock_controller.dart';

class ClockScreen extends StatelessWidget {
  final ClockController _clockController = Get.put(ClockController());

  @override
  Widget build(BuildContext context) {
    var _mediaQueryHeight = MediaQuery.of(context).size.height;
    var _mediaQueryWidth = MediaQuery.of(context).size.width;
    var _lineWidth = _mediaQueryWidth * .03;
    // var _imageWidth = _mediaQueryHeight > 550
    //     ? _mediaQueryWidth * .35
    //     : _mediaQueryWidth * .35;

    Center _displayTime(clockController) => Center(
          child: Container(
              // color: Colors.yellow,
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
            percent: _clockController.buttonChange == false
                ? _clockController.secondsForAnimation
                : 1.0,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: _clockController.clockThemeTrigger ? bg1 : bg2,
            progressColor: _clockController.clockThemeTrigger ? pc1 : pc2,
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
              _clockController.buttonChange == false
                  ? _displayTime(_clockController)
                  : _clockController.remainingTime == '0.min&0,sec'
                      ? _remainingTime(_clockController.remainingInterval,
                          'Start working in')
                      : _remainingTime(
                          _clockController.remainingTime, 'Take a break in'),
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
                      colors: _clockController.clockThemeTrigger
                          ? [Colors.blue, Colors.blueAccent]
                          : [Colors.green, Colors.greenAccent],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds),
                    child: Icon(
                      Icons.ac_unit,
                      color: _clockController.clockThemeTrigger
                          ? Colors.blue
                          : Colors.amber,
                      size: _mediaQueryWidth * .44,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
              ),
              // _clockController.clockThemeTrigger
              //     ? Opacity(
              //         opacity: .25,
              //         child: Center(
              //           child: Icon(
              //             Icons.work_outlined,
              //             color: Colors.black54,
              //             size: _mediaQueryWidth * .30,
              //             semanticLabel:
              //                 'Text to announce in accessibility modes',
              //           ),
              //         ),
              //       )
              //     : Opacity(
              //         opacity: .3,
              //         child: Center(
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(100),
              //             child: Container(
              //                 width: _imageWidth,
              //                 child: Image.asset('assets/IM.png')),
              //           ),
              //         ),
              //       ),
            ],
          ))),
    );
  }
}
