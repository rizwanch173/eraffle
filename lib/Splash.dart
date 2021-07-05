import 'package:eraffle/Tabs.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  afterSplash() {
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Tabs()),
      );
    });
  }

  @override
  void initState() {
    afterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                AppColor.primary,
                AppColor.secondary,
              ],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(0, 1),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: SvgPicture.asset(
            "assets/Icons/splash.svg",
          ),
        ),
      ),
    );
  }
}
