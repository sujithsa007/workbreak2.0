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
import 'package:shared_preferences/shared_preferences.dart';

class TextToSpeechController extends GetxController {
  FlutterTts _flutterTts = new FlutterTts();

  bool get isAndroid => Platform.isAndroid;

  TextToSpeechController() {
    _initTts();
  }

  Future _initTts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getDouble('volume') == null) {
      prefs.setDouble('volume', 1.0);
    }
    if (prefs.getDouble('pitch') == null) {
      prefs.setDouble('pitch', 1.0);
    }
    if (prefs.getDouble('rate') == null) {
      prefs.setDouble('rate', 0.7);
    }

    if (isAndroid) {
      print('initTTS loop start************');
      await _flutterTts.isLanguageInstalled('en-US');
      await _flutterTts.getEngines;
      print(await _flutterTts.setLanguage('en-US'));
    }
    await _flutterTts.setLanguage('en-US');
  }

  Future speak(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await _flutterTts.setVolume(prefs.getDouble('volume'));
    await _flutterTts.setSpeechRate(prefs.getDouble('rate'));
    await _flutterTts.setPitch(prefs.getDouble('pitch'));
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.speak(text);
  }
}
