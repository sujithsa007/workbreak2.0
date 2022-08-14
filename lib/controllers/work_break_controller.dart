/// Author : Sujith S A
/// Created on : 27th Apr 2021

/// This class acts as the controller class for both clock widget and the Home screen
/// It contains both Static and Observable objects
/// The clock animation logic is executed by using a time to pass 1/60th of a circle's value
/// every second into the CircularPercentIndicator widget's percent parameter, located
/// under animated_clock.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wakelock/wakelock.dart';
import 'package:work_break/controllers/text_to_speech_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:work_break/utilities/ad_helper.dart';
import 'package:work_break/utilities/constants.dart';
import 'package:work_break/utilities/messages.dart';

class WorkBreakController extends GetxController {
  WorkBreakController() {
    if (Platform.isAndroid) {
      enableBackgroundMode();
      _initGoogleMobileAds();
      loadBanner();
    }
    clockAnimateTimer();
    Wakelock.enable();
  }

  final TextToSpeechController _textToSpeechController =
      Get.put(TextToSpeechController());

  TextEditingController _workTimeInputController = new TextEditingController();
  TextEditingController _breakTimeInputController = new TextEditingController();
  get workTimeInputController => _workTimeInputController;
  get breakTimeInputController => _breakTimeInputController;

  var _workOptions = WORK_OPTIONS;
  var _intervalOptions = INTERVAL_OPTIONS;

  get workOptions => _workOptions;
  get intervalOptions => _intervalOptions;

  onSelectedWorkInterval(selected) {
    setIntervalTime = selected;
  }

  onSelectedWorkTime(String selected) {
    setWorkTime = selected;
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  enableBackgroundMode() async {
    await FlutterBackground.hasPermissions;
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Work break",
      notificationText: "Work break is running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon:
          AndroidResource(name: 'background_icon', defType: 'drawable'),
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
    await FlutterBackground.enableBackgroundExecution();
  }

  BannerAd _ad;
  get ad => _ad;

  loadBanner() {
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('Ad load success');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad.load();
  }

  RxString _remainingTime = ''.obs;
  get remainingTime => _remainingTime.value;
  set setRemainingTime(int val) {
    String remVal = convertTimeToHoursAndMinutesForClock(val);
    print(remVal);
    _remainingTime.value = remVal;
  }

  RxString _remainingInterval = ''.obs;
  get remainingInterval => _remainingInterval.value;
  set setRemainingInterval(int val) {
    String remVal = convertTimeToHoursAndMinutesForClock(val);
    _remainingInterval.value = remVal;
  }

  RxDouble _secondsForAnimation = 0.0.obs;
  RxDouble _secondsForAnimation2 = 0.0.obs;
  RxString _currentTimeToDisplay = ''.obs;
  RxString _amPmToDisplay = ''.obs;
  get currentTimeToDisplay => _currentTimeToDisplay.value;
  get secondsForAnimation => _secondsForAnimation.value;
  get secondsForAnimation2 => _secondsForAnimation2.value;
  get amPmToDisplay => _amPmToDisplay.value;

  Timer _selectedWorkTimer;
  Timer _selectedIntervalTimer;
  Timer _clockTimer;
  Timer _countDownTimer;

  RxBool _clockThemeTrigger = false.obs;
  get clockThemeTrigger => _clockThemeTrigger.value;
  set setClockThemeTriggerValue(val) {
    _clockThemeTrigger.value = val;
  }

  RxBool _checkBoxValue = false.obs;
  get checkBoxValue => _checkBoxValue.value;
  set setCheckBoxValue(val) {
    if (val == false) {
      _workTimeInputController.text = '';
      _breakTimeInputController.text = '';
    }
    _checkBoxValue.value = val;
  }

  RxBool _buttonChange = false.obs;
  get buttonChange => _buttonChange.value;
  set setButtonChange(val) {
    _buttonChange.value = val;
  }

  RxString _workTimeInput = '5'.obs;
  get workTimeInput => _workTimeInput.value;
  setWorkTimeInput(val) {
    _workTimeInput.value = val;
  }

  RxString _breakTimeInput = '1'.obs;
  get breakTimeInput => _breakTimeInput.value;
  setBreakTimeInput(val) {
    _breakTimeInput.value = val;
  }

  RxString _selectedWorkTime = ''.obs;
  RxString _selectedWorkInterval = ''.obs;
  get selectedWorkTime => _selectedWorkTime.value;
  get selectedWorkInterval => _selectedWorkInterval.value;
  set setWorkTime(val) {
    _selectedWorkTime.value = val;
  }

  set setIntervalTime(val) {
    _selectedWorkInterval.value = val;
  }

  clockAnimateTimer() {
    _clockTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _secondsForAnimation.value = DateTime.now().second / 60;
      _secondsForAnimation2.value = 1 - DateTime.now().second / 60;
      _currentTimeToDisplay.value = DateFormat('hh:mm').format(DateTime.now());
      _amPmToDisplay.value = DateFormat(' a').format(DateTime.now());
    });
  }

  clockAnimateCountDown(workTime, breakTime) {
    int _remTime = int.parse(workTime.toString().split(' ')[0]);
    int _remInterval = int.parse(breakTime.toString().split(' ')[0]);
    int _intRemTime = _remTime * 60;
    int _intRemInterval = _remInterval * 60;
    int _totTime = _intRemTime + _intRemInterval;
    int _startTimerCount = 0;

    if (_clockTimer != null) {
      _clockTimer.cancel();
    }

    if (_countDownTimer != null) {
      _countDownTimer.cancel();
    }

    _countDownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // print(intRemTime.toString());
      // print(totTime);
      // print(i);
      if (_startTimerCount == 0) {
        setRemainingTime = _intRemTime;
      }
      if (_startTimerCount++ + 1 == _totTime) {
        if (_countDownTimer != null) {
          _countDownTimer.cancel();
        }
        print('timer cancelled');
        clockAnimateCountDown(workTime, breakTime);
      }
      if (_intRemTime >= 0) {
        setRemainingTime = _intRemTime--;
      }
      if (_intRemTime == -1) {
        if (_intRemInterval >= 0) {
          setRemainingInterval = _intRemInterval--;
        }
      }
    });
  }

  String convertTimeToHoursAndMinutes(int value) {
    final int _hour = value ~/ 60;
    final int _minutes = value % 60;
    return '${_hour.toString()}:${_minutes.toString()}';
  }

  String convertTimeToHoursAndMinutesForClock(int value) {
    final int _hour = value ~/ 60;
    final int _minutes = value % 60;
    return '${_hour.toString()}.min&${_minutes.toString()},sec';
  }

  onClickStartWork(workTime, breakInterval) async {
    if (workTime == '' || breakInterval == '') {
      Get.snackbar(
        'Oops',
        'Please select both work and break times',
        duration: Duration(seconds: 2),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } else {
      setClockThemeTriggerValue = true;
      Get.snackbar(
        'Success',
        _buttonChange.value == false
            ? 'Start Working'
            : 'Your new settings have been applied',
        duration: Duration(seconds: 2),
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );

      clockAnimateCountDown(workTime.toString(), breakInterval.toString());

      if (_selectedWorkTimer != null) {
        _selectedWorkTimer.cancel();
      }
      if (_selectedIntervalTimer != null) {
        _selectedIntervalTimer.cancel();
      }
      setButtonChange = true;
      await setUpTimer(_selectedWorkTime.value, _selectedWorkInterval.value);
    }
  }

  bool isValidNumber(String string) {
    final validCharacters = RegExp(r'^[0-9]+$');
    return validCharacters.hasMatch(string);
  }

  setCustomTime() async {
    if (!isValidNumber(_workTimeInputController.text.toString()) ||
        !isValidNumber(_breakTimeInputController.text.toString())) {
      Get.snackbar(
        'Error',
        'Enter a valid work and break time',
        duration: Duration(seconds: 2),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } else {
      int _workTime = int.parse(_workTimeInput.value.toString());
      int _breakTime = int.parse(_breakTimeInput.value.toString());
      if (_workTime < 5 || _breakTime < 1) {
        Get.snackbar(
          'Error',
          'Enter atleast 5 minutes work and 1 minute of break time',
          duration: Duration(seconds: 2),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      } else {
        setWorkTime = _workTimeInput.value.toString() + ' mins';
        setIntervalTime = _breakTimeInput.value.toString() + ' mins';
        await onClickStartWork(
            _selectedWorkTime.value, _selectedWorkInterval.value);
      }
    }
  }

  startTimer(int duration, String message, bool triggerFn) async {
    return Timer.periodic(Duration(minutes: duration), (Timer timer) async {
      triggerFn
          ? setUpTimer(_timeForWorkTimer, _timeForIntervalTimer)
          : print('No need to trigger ******');
      triggerFn ? _selectedIntervalTimer.cancel() : _selectedWorkTimer.cancel();
      await _textToSpeechController.speak(message);
    });
  }

  String _finalAnnounceTime = '';
  int _timeForWorkTimer, _timeForIntervalTimer;

  setUpTimer(workTimeReminder, breakIntervalReminder) async {
    if (workTimeReminder.toString().contains('min')) {
      _timeForWorkTimer = int.parse(workTimeReminder.toString().split(' ')[0]);
    } else {
      _timeForWorkTimer = workTimeReminder;
    }
    if (breakIntervalReminder.toString().contains('min')) {
      _timeForIntervalTimer =
          int.parse(breakIntervalReminder.toString().split(' ')[0]);
    } else {
      _timeForIntervalTimer = breakIntervalReminder;
    }
    print('timer set workTime****' + _timeForWorkTimer.toString());
    print('timer set intervalTime****' + _timeForIntervalTimer.toString());

    String _convertedTime = convertTimeToHoursAndMinutes(_timeForWorkTimer);

    if (_convertedTime.split(':')[1] == '0') {
      if (_convertedTime.split(':')[0] == '1') {
        _finalAnnounceTime = '1 hour';
      } else {
        _finalAnnounceTime = _convertedTime.split(':')[0] + ' hours';
      }
    } else if (_convertedTime.split(':')[0] == '0') {
      _finalAnnounceTime = _convertedTime.split(':')[1] + ' minutes';
    } else {
      if (_convertedTime.split(':')[0] == '1') {
        _finalAnnounceTime =
            '1 hour and ' + _convertedTime.split(':')[1] + ' minutes';
      } else {
        _finalAnnounceTime = _convertedTime.split(':')[0] +
            ' hours and ' +
            _convertedTime.split(':')[1] +
            ' minutes';
      }
    }
    String _randomMessage = RandomMessage.getRandomMessage();
    print('You have worked for ' + _finalAnnounceTime + '. $_randomMessage.');

    _selectedWorkTimer = await startTimer(
        _timeForWorkTimer,
        'You have worked for ' + _finalAnnounceTime + '. $_randomMessage.',
        false);

    _selectedIntervalTimer = await startTimer(
        _timeForWorkTimer + _timeForIntervalTimer,
        _timeForIntervalTimer.toString() == '60'
            ? 'You have taken a break for 1 hour. Lets get back to work.'
            : 'You have taken a break for ' +
                _timeForIntervalTimer.toString() +
                ' minutes. Lets get back to work',
        true);
  }
}
