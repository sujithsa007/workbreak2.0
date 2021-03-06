import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3470431594248807/5447716611'; // Production Ad Key
      return 'ca-app-pub-3940256099942544/6300978111'; //Test Ad Key
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw new UnsupportedError("Unsupported platform");
  }
}
