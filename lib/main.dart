import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './routes/home_route.dart';
import './advert_ids.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  static const MobileAdTargetingInfo _targetingInfo = MobileAdTargetingInfo(
    keywords: [
      "math",
      "school",
      "books",
      "thinking",
    ],
    childDirected: false,
    testDevices: <String>["3C2BACC3B6177D291D421EFA6B1DBCE3"],
  );

  Future<void> _initAdBanner() async {
    _bannerAd = BannerAd(
      adUnitId: AdvertIds.bannerId,
      size: AdSize.fullBanner,
      targetingInfo: _targetingInfo,
    );
    await _bannerAd.load();
    await _bannerAd.show(anchorType: AnchorType.bottom);
  }

  Future<void> _initNotifications() async {
    final FirebaseMessaging fb = FirebaseMessaging();
    fb.requestNotificationPermissions();
    print(await fb.getToken());
  }

  void _initInterstitialAd() {
    _interstitialAd = InterstitialAd(
      adUnitId: AdvertIds.interstitialId,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.closed) {
          _initInterstitialAd();
        }
      },
    );
  }

  Future<void> showAd() async {
    await _interstitialAd.load();
    await _interstitialAd.show();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(
      appId: AdvertIds.appId,
    );
    _initAdBanner();
    _initInterstitialAd();

    _initNotifications();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Learn to multiply',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Color(0xFF161B21),
        accentColor: Color(0xFFF4A342),
        toggleableActiveColor: Color(0xFFF4A342),
        appBarTheme: AppBarTheme(
          color: Color(0xFF222A33),
          textTheme: TextTheme(
            title: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 22.0,
            ),
          ),
        ),
      ),
      home: HomeRoute(showAd: showAd),
    );
  }
}
