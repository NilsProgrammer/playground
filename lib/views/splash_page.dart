import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playground/components/gradient_components/gradient_mask.dart';
import 'package:playground/globals/style.dart';
import 'package:playground/providers/dark_theme_provider.dart';
import 'package:playground/views/login_redirect_page.dart';

import '../components/gradient_components/gradient_background.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginRedirectPage()));
    });

    //Splash screen gets loaded before setting darktheme is loaded so update it after listening once
    dynamic darkListener;
    darkListener = () {
      setState(() {
        
      });
      DarkThemeProvider().removeListener(darkListener);
    };
    DarkThemeProvider().addListener(darkListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GradientBackground(
      gradient: DarkThemeProvider.isDarkTheme ? Style.gradientDark : Style.gradient,
      child: SafeArea(
        child: Center(
          child: GradientMask(
            child: Image.asset(
              "assets/images/Vue.png",
              fit: BoxFit.scaleDown,
              width: size.width * 0.5,
              height: size.height * 0.5,
              alignment: Alignment.center,
            )
          )
        )
      ),
    );
  }
}