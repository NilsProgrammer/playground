import 'dart:math' as dart_math;

import 'package:flutter/material.dart';
import 'package:playground/components/gradient_components/gradient_background.dart';
import 'package:playground/components/gradient_components/gradient_circular_progress_indicator.dart';
import 'package:playground/views/register_pages/basic_information.dart';
import 'package:playground/views/register_pages/login_information.dart';
import 'package:playground/components/rotating_widget.dart';
import 'package:playground/components/rounded_background.dart';
import 'package:playground/globals/style.dart';
import 'package:playground/models/register_data.dart';
import 'package:playground/providers/dark_theme_provider.dart';
import 'package:playground/views/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>  {
  final double gapSize = 20;
  final formKey = GlobalKey<FormState>();
  final RegisterData data = RegisterData();
  final List<Widget> pages = [];
  final List<GlobalKey<FormState>> keys = List<GlobalKey<FormState>>.generate(
    2, (index) => GlobalKey<FormState>(), growable: false
  );
  final List<String> pageNames = [
    "Info",
    "Login"
  ];

  bool isRegistering = false;
  int page = 0;

  @override
  void initState() {
    pages.addAll({
      BasicInformation(
        formKey: keys.elementAt(0),
        data: data,
      ),
      LoginInformation(
        formKey: keys.elementAt(1),
        data: data,
      )
    });
    super.initState();
  }

  void changePage(int nextPage) {
    assert(nextPage >= 0 && nextPage < pages.length);

    keys.elementAt(page).currentState!.validate();
    
    setState(() {
      page = nextPage;
    });
  }

  void incrementPage(int dir) {
    assert(dir == 1 || dir == -1);
    int nextPage = page + dir;

    if (nextPage < 0 || nextPage >= pages.length) { return; }

    changePage(nextPage);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size innerSize = Size(dart_math.max(size.width * 0.25, 300), size.height * 0.80);
    Color backgroundColor = DarkThemeProvider.isDarkTheme ? Style.backgroundColorDark : Style.backgroundColor;
    
    return GradientBackground(
      gradient: DarkThemeProvider.isDarkTheme ? Style.gradientDark : Style.gradient,
      child: SafeArea(
        child: Center(
          child: Stack(
            children: [
              RoundedBackground(
                elevation: 10,
                borderRadius: 10,
                width: innerSize.width,
                height: innerSize.height,
                color: backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 10),
                  child: Column(
                    children: [
                      Text(
                        "Sign up",
                        style: Style.createTextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          textColor: DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor
                        )
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: innerSize.width,
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(keys.length, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(children: [
                                RoundedBackground(
                                  elevation: page == index ? 5 : 0,
                                  borderRadius: 100,
                                  width: 30,
                                  height: 30,
                                  gradient: page == index ? (DarkThemeProvider.isDarkTheme ? Style.gradientDark : Style.gradient) : null,
                                  child: InkWell(
                                    onTap: () {
                                      if (index > page && keys[page].currentState!.validate() == false) {
                                        return;
                                      }
                                      changePage(index);
                                    },
                                    child: Center(
                                      child: Text(
                                        (index + 1).toString(),
                                        style: Style.createTextStyle(
                                          textColor: page == index ? Style.textColorWhite : Style.textColor
                                        ),
                                      ),
                                    )
                                  )
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  pageNames[index],
                                  style: Style.createTextStyle(
                                    fontSize: Style.textSmallSize,
                                    textColor: page == index
                                      ? (DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor)
                                      : Style.textColorHint
                                  )
                                )
                              ])
                            );
                          })
                        )
                      ),

                      const SizedBox(height: 40),

                      Expanded(child: pages[page]),

                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        child: RoundedBackground(
                          width: double.infinity,
                          height: 40,
                          gradient: DarkThemeProvider.isDarkTheme ? Style.gradientDark : Style.gradient,
                          child: TextButton(
                            child: Text(
                              (page == keys.length - 1) ? "SIGNUP" : "NEXT",
                              style: Style.createTextStyle(
                                textColor: DarkThemeProvider.isDarkTheme ? Style.textColor : Style.textColorWhite
                              )
                            ),
                            onPressed: () {
                              if (page == keys.length - 1) {
                                //sign up
                                for (var key in keys) {
                                  if (key.currentState != null && key.currentState!.validate() != true) {
                                    return;
                                  }
                                }

                                /* setState(() {
                                  isRegistering = true;
                                }); */

                                http.post(Uri.http("127.0.0.1:8000", "/register", {
                                  "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
                                  "Content-Type": "application/json",
                                  "Accept": "application/json"
                                }), body: jsonEncode(data.toMap())).then((response) {
                                  print(response.body);
                                });

                                return;
                              }

                              //next register page
                              if (keys[page].currentState!.validate()) {
                                incrementPage(1);
                              }
                            }
                          ),
                        )
                      )
                    ]
                  )
                )
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (context, animation1, animation2) => const LoginPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero
                    ),
                    (route) => false
                  );
                },
                child: Text(
                  "BACK",
                  style: Style.createTextStyle(
                    fontSize: Style.textSmallSize,
                    fontWeight: FontWeight.bold,
                    textColor: DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor
                  )
                )
              ),

              isRegistering == false ? const SizedBox.shrink() : AnimatedOpacity(
                opacity: isRegistering ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: RoundedBackground(
                  elevation: 0,
                  borderRadius: 10,
                  width: innerSize.width,
                  height: innerSize.height,
                  color: const Color.fromARGB(200, 30, 30, 30),
                  child: Center(
                    child: RotatingWidget(
                      child: GradientCircularProgressIndicator(
                        gradientColors: DarkThemeProvider.isDarkTheme ? Style.gradientDark.colors : Style.gradient.colors
                      ),
                    )
                  )  
                )
              )
            ],
          )
        )
      )
    );
  }
}