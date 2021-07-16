/// Author : Sujith S A
/// Created on : 28th Apr 2021
/// Last Edited : 23 June 2021
/// This class is the controller responsible for text to speech conversion and speak out
/// The FlutterTts engines are invoked and the default language is set to en-US. A built
/// in method speak, accepts string as input and speaks out based on the pre-set
/// language, volume, pitch and rate

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TextToSpeechController extends GetxController {
  FlutterTts _flutterTts = new FlutterTts();

  bool get isAndroid => Platform.isAndroid;

  double _volume = 1.0;
  double _pitch = 1.0;
  double _rate;

  TextToSpeechController() {
    _initTts();
  }

  // Future _getDefaultEngine() async {
  //   var engine = await _flutterTts.getDefaultEngine;
  // }
  //
  // Future _getEngines() async {
  //   var engines = await _flutterTts.getEngines;
  // }

  Future _initTts() async {
    if (isAndroid) {
      //await _getDefaultEngine();
      print('initTTS loop start************');
      await _flutterTts.isLanguageInstalled('en-US');
      await _flutterTts.getEngines;
      print(await _flutterTts.setLanguage('en-US'));
    }
    //await _getEngines();
    await _flutterTts.setLanguage('en-US');
  }

  Future speak(String text) async {
    _rate = isAndroid ? 0.7 : 0.5;
    // await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setSpeechRate(_rate);
    await _flutterTts.setPitch(_pitch);
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.speak(text);
  }
}
