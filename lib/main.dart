import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './routes/home_route.dart';
import './advert_ids.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BannerAd _bannerAd;

  @override
  initState() {
    super.initState();
  }

  Future _initAdBanner() async {
    _bannerAd = BannerAd(
      adUnitId: AdvertIds.bannerId,
      size: AdSize.fullBanner,
      targetingInfo: MobileAdTargetingInfo(
        keywords: [
          "math",
          "school",
          "books",
          "thinking",
        ],
        childDirected: false,
        testDevices: <String>["3C2BACC3B6177D291D421EFA6B1DBCE3"],
      ),
    );
    await _bannerAd.load();
    await _bannerAd.show(anchorType: AnchorType.bottom);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(
      appId: AdvertIds.appId,
    );
    _initAdBanner();
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
      home: HomeRoute(),
    );
  }
}
