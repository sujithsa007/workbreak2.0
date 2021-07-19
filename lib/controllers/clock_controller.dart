/// Author : Sujith S A
/// Created on : 27th Apr 2021

/// This class acts as the controller class for both clock widget and the Home screen
/// It contains both Static and Observable objects
/// The clock animation logic is executed by using a time to pass 1/60th of a circle's value
/// every second into the CircularPercentIndicator widget's percent parameter, located
/// under clock.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wakelock/wakelock.dart';
import 'package:work_break/controllers/text_to_speech_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:work_break/utilities/ad_helper.dart';
import 'package:work_break/utilities/messages.dart';

class ClockController extends GetxController {
  ClockController() {
    _enableBackgroundMode();
    _initGoogleMobileAds();
    _loadBanner();
    _clockAnimateTimer();
    Wakelock.enable();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  _enableBackgroundMode() async {
    await FlutterBackground.hasPermissions;
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Work break",
      notificationText: "Work break is running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
    await FlutterBackground.enableBackgroundExecution();
  }

  BannerAd _ad;

  get ad => _ad;

  _loadBanner() {
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

  RxInt _remainingTime = 0.obs;

  get remainingTime => _remainingTime.value;

  set setRemainingTime(int val) {
    _remainingTime.value = val;
  }

  RxInt _remainingInterval = 0.obs;

  get remainingInterval => _remainingInterval.value;

  set setRemainingInterval(int val) {
    _remainingInterval.value = val;
  }

  final TextToSpeechController _textToSpeechController =
      Get.put(TextToSpeechController());

  RxDouble _secondsForAnimation = 0.0.obs;
  RxString _currentTimeToDisplay = ''.obs;
  RxString _amPmToDisplay = ''.obs;
  get currentTimeToDisplay => _currentTimeToDisplay.value;
  get secondsForAnimation => _secondsForAnimation.value;
  get amPmToDisplay => _amPmToDisplay.value;

  Timer _selectedWorkTimer;
  Timer _selectedIntervalTimer;
  Timer _testTimer;
  Timer _clockTimer;
  Timer _countDownTimer;

  String _finalAnnounceTime = '';

  RxBool _firstLoad = true.obs;

  set setFirstLoad(val) {
    _firstLoad.value = val;
  }

  RxBool _clockThemeTrigger = false.obs;
  get clockThemeTrigger => _clockThemeTrigger.value;

  set setClockThemeTriggerValue(val) {
    _clockThemeTrigger.value = val;
  }

  RxBool _checkBoxValue = false.obs;
  get checkBoxValue => _checkBoxValue.value;

  set setCheckBoxValue(val) {
    _checkBoxValue.value = val;
  }

  RxBool _buttonChange = false.obs;
  get buttonChange => _buttonChange.value;

  set setButtonChange(val) {
    _buttonChange.value = val;
  }

  TextEditingController _workTimeInputController = new TextEditingController();
  TextEditingController _breakTimeInputController = new TextEditingController();

  get workTimeInputController => _workTimeInputController;
  get breakTimeInputController => _breakTimeInputController;

  RxString _workTimeInput = '5'.obs;
  get workTimeInput => _workTimeInput.value;

  RxString _breakTimeInput = '1'.obs;
  get breakTimeInput => _breakTimeInput.value;

  setWorkTimeInput(val) {
    _workTimeInput.value = val;
  }

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

  int _timeForWorkTimer, _timeForIntervalTimer;

  _clockAnimateTimer() {
    _clockTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _secondsForAnimation.value = DateTime.now().second / 60;
      _currentTimeToDisplay.value = DateFormat('hh:mm').format(DateTime.now());
      _amPmToDisplay.value = DateFormat(' a').format(DateTime.now());
    });
  }

  _clockAnimateCountDown(workTime, breakTime) {
    if (_clockTimer != null) {
      _clockTimer.cancel();
    }

    if (_countDownTimer != null) {
      _countDownTimer.cancel();
    }
    int remTime = int.parse(workTime.toString().split(' ')[0]);
    int remInterval = int.parse(breakTime.toString().split(' ')[0]);
    int intRemTime = remTime * 60;
    int intRemInterval = remInterval * 60;
    int totTime = intRemTime + intRemInterval;

    int i = 0;
    // int intRemTime = remTime;
    // int intRemInterval = remInterval;
    // setRemainingTime = intRemTime;
    _countDownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // print(intRemTime.toString());
      // print(totTime);
      // print(i);
      if (i == 0) {
        setRemainingTime = intRemTime;
      }
      if (i++ + 1 == totTime) {
        if (_countDownTimer != null) {
          _countDownTimer.cancel();
        }
        print('timer cancelled');
        _clockAnimateCountDown(workTime, breakTime);
      }
      if (intRemTime >= 0) {
        setRemainingTime = intRemTime--;
      }
      // print(intRemTime);
      if (intRemTime == -1) {
        if (intRemInterval >= 0) {
          setRemainingInterval = intRemInterval--;
          // print('this is running');
        }
      }
    });
  }

  String _convertTimeToHoursAndMinutes(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString()}:${minutes.toString()}';
  }

  onClickStartWork(workTime, breakInterval) async {
    // print(_convertTimeToHoursAndMinutes(180));
    if (workTime == '' || breakInterval == '') {
      Get.snackbar(
        'Oops',
        'Please select both work and break times',
        duration: Duration(seconds: 3),
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
        duration: Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
      // var remTime = workTime.toString().split(' ')[0];
      // setRemainingTime = int.parse(remTime);
      _clockAnimateCountDown(workTime.toString(), breakInterval.toString());

      if (_selectedWorkTimer != null) {
        _selectedWorkTimer.cancel();
      }
      if (_selectedIntervalTimer != null) {
        _selectedIntervalTimer.cancel();
      }
      if (_testTimer != null) {
        _testTimer.cancel();
      }
      setButtonChange = true;
      await _setUpTimer(_selectedWorkTime.value, _selectedWorkInterval.value);
      // }
    }
  }

  setCustomTime() async {
    if (_workTimeInputController.text.toString().contains('.') ||
        _workTimeInputController.text.toString().contains('-') ||
        _workTimeInputController.text.toString().contains(',') ||
        _workTimeInputController.text.toString() == '' ||
        _breakTimeInputController.text.toString().contains('.') ||
        _breakTimeInputController.text.toString().contains('-') ||
        _breakTimeInputController.text.toString().contains(',') ||
        _breakTimeInputController.text.toString() == '') {
      Get.snackbar(
        'Error',
        'Enter a valid work and break time',
        duration: Duration(seconds: 3),
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
          duration: Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      } else {
        setWorkTime = _workTimeInput.value.toString() + ' mins';
        setIntervalTime = _breakTimeInput.value.toString() + ' mins';
        // print('Custom print' +
        //     _selectedWorkTime.value +
        //     _selectedWorkInterval.value);
        await onClickStartWork(
            _selectedWorkTime.value, _selectedWorkInterval.value);
      }
    }
  }

  _startTimer(int duration, String message, bool triggerFn) async {
    return Timer.periodic(Duration(minutes: duration), (Timer timer) async {
      triggerFn
          ? _setUpTimer(_timeForWorkTimer, _timeForIntervalTimer)
          : print('No need to trigger ******');
      triggerFn ? _selectedIntervalTimer.cancel() : _selectedWorkTimer.cancel();
      await _textToSpeechController.speak(message);
    });
  }

  _setUpTimer(workTimeReminder, breakIntervalReminder) async {
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

    String _convertedTime = _convertTimeToHoursAndMinutes(_timeForWorkTimer);

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
    // print(_convertedTime);
    // print(_finalAnnounceTime);
    var _randomMessage = RandomMessage.getARandomMessage();
    print('You have worked for ' + _finalAnnounceTime + '. $_randomMessage.');

    _selectedWorkTimer = await _startTimer(
        _timeForWorkTimer,
        'You have worked for ' + _finalAnnounceTime + '. $_randomMessage.',
        false);

    _selectedIntervalTimer = await _startTimer(
        _timeForWorkTimer + _timeForIntervalTimer,
        _timeForIntervalTimer.toString() == '60'
            ? 'You have taken a break for 1 hour. Lets get back to work.'
            : 'You have taken a break for ' +
                _timeForIntervalTimer.toString() +
                ' minutes. Lets get back to work',
        true);

    // //Tester timer
    // int i = 0;
    // _testTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
    //   print(i++);
    // });
  }
}
