import 'dart:math' as dart_math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:playground/components/buttons/dark_mode_button.dart';
import 'package:playground/components/buttons/language_button.dart';
import 'package:playground/components/dialogues.dart';
import 'package:playground/components/gradient_components/gradient_background.dart';
import 'package:playground/components/gradient_components/gradient_circular_progress_indicator.dart';
import 'package:playground/views/register_pages/login_information.dart';
import 'package:playground/components/rotating_widget.dart';
import 'package:playground/components/rounded_background.dart';
import 'package:playground/globals/style.dart';
import 'package:playground/models/register_data.dart';
import 'package:playground/providers/dark_theme_provider.dart';
import 'package:playground/views/home_page.dart';
import 'package:playground/views/login_redirect_page.dart';
import 'package:playground/views/register_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final double iconSize = 40;
  final double gapSize = 20;

  final formKey = GlobalKey<FormState>();
  final RegisterData data = RegisterData();

  bool isLoggingIn = false;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size innerSize = Size(dart_math.max(size.width * 0.25, 300), size.height * 0.80);
    Color backgroundColor = DarkThemeProvider.isDarkTheme ? Style.backgroundColorDark : Style.backgroundColor;
    
    return Scaffold(
      body: GradientBackground(
        gradient: DarkThemeProvider.isDarkTheme ? Style.gradientDark : Style.gradient,
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
                        "Log in",
                        style: Style.createTextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          textColor: DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor
                        )
                      ),
                      const SizedBox(height: 40),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoginInformation(formKey: formKey, data: data, emailController: emailController),
                            SizedBox(height: gapSize),
                            RoundedBackground(
                              width: double.infinity,
                              height: 40,
                              gradient: DarkThemeProvider.isDarkTheme ? Style.gradientDark : Style.gradient,
                              child: TextButton(
                                child: Text(
                                  "LOGIN",
                                  style: Style.createTextStyle(
                                    textColor: DarkThemeProvider.isDarkTheme ? Style.textColor : Style.textColorWhite
                                  )
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate() == false) {
                                    return;
                                  }

                                  setState(() {
                                    isLoggingIn = true;
                                  });

                                  FirebaseAuth.instance
                                    .signInWithEmailAndPassword(email: data.email!.trim(), password: data.password!.trim())
                                    .then((value) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoginRedirectPage()),
                                        (route) => false
                                      );
                                    })
                                    .onError((error, stackTrace) {
                                      if (error is FirebaseAuthException) {
                                        Dialogues.showNoticeDialogue(
                                          context,
                                          title: Text("Error: ${error.code}", style: Style.textStyle),
                                          content: Text(error.message ?? "Login failed", style: Style.textStyle),
                                          footer: const Text("close", style: Style.textStyle)
                                        );
                                      }
                                    })
                                    .whenComplete(() {
                                      setState(() {
                                        isLoggingIn = false;
                                      });
                                    });
                                },
                              )
                            ),
                            SizedBox(height: gapSize),
                            Text("OR", style: Style.createTextStyle(textColor: Style.textColorGray, fontSize: Style.textSmallSize)),
                            SizedBox(height: gapSize),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RoundedBackground(
                                  color: const Color.fromARGB(255, 66, 103, 178),
                                  width: iconSize,
                                  height: iconSize,
                                  child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset("assets/icons/facebook-logo.png"),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isLoggingIn = true;
                                      });
                                      FacebookAuth.instance.login(
                                        permissions: ["email", "public_profile"]
                                      ).then((result) {
                                        print(result.status);
                                        if (result.status != LoginStatus.success) {
                                          throw Exception("canceled");
                                        }

                                        final facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);

                                        FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then((value) {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                        }).onError((error, stackTrace) {

                                        }).whenComplete(() {
                                          setState(() {
                                            isLoggingIn = false;
                                          });
                                        });
                                      }).whenComplete(() {
                                        setState(() {
                                          isLoggingIn = false;
                                        });
                                      });
                                    },
                                  )
                                ),

                                const SizedBox(width: 5),

                                RoundedBackground(
                                  color: Colors.redAccent,
                                  width: iconSize,
                                  height: iconSize,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.nfc_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      //TODO
                                      setState(() {
                                        isLoggingIn = true;
                                      });
                                      print("awaiting uid");
                                      var response = await http.get(Uri.http("127.0.0.1:8000", "/readuid", {
                                        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
                                        "Content-Type": "application/json",
                                        "Accept": "application/json"
                                      }));
                                      print(response.statusCode);
                                      print(response.body);
                                      if (response.statusCode == 200) {
                                        String uid = response.body;
                                        setState(() {
                                          emailController.text = uid;
                                        });
                                        
                                      }
                                      setState(() {
                                        isLoggingIn = false;
                                      });
                                    },
                                  ),
                                )

                                /* const SizedBox(width: 5),

                                RoundedBackground(
                                  width: iconSize,
                                  height: iconSize,
                                  child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.asset("assets/icons/apple-logo-black.png"),
                                    ),
                                    onTap: () => {

                                    },
                                  )
                                ),

                                const SizedBox(width: 5),

                                RoundedBackground(
                                  width: iconSize,
                                  height: iconSize,
                                  child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.asset("assets/icons/google-logo.png"),
                                    ),
                                    onTap: () async {
                                      setState(() {
                                          isLoggingIn = true;
                                      });

                                      final googleSignIn = GoogleSignIn();

                                      googleSignIn.signIn().then((googleAccount) {
                                        googleAccount?.authentication.then((authentication) {
                                          final AuthCredential authCredential = GoogleAuthProvider.credential(
                                            accessToken: authentication.accessToken,
                                            idToken: authentication.idToken);

                                          FirebaseAuth.instance.signInWithCredential(authCredential).then((value) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                          });
                                        });

                                      }).onError((error, stackTrace) {
                                        if (error is FirebaseAuthException) {
                                          //Dialogues.showNoticeDialogue(context, title: error.code, message: error.message ?? "Error");
                                        }
                                        print(error);
                                      })
                                      .whenComplete(() {
                                        setState(() {
                                          isLoggingIn = false;
                                        });
                                      });
                                    },
                                  )

                                ) */
                              ]
                            ),

                            SizedBox(height: gapSize),

                            TextButton(
                              child: Text(
                                "SIGN UP",
                                style: Style.createTextStyle(
                                  textColor: DarkThemeProvider.isDarkTheme ? Style.textColorWhite: Style.textColor,
                                  fontSize: Style.textSmallSize,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(pageBuilder: (context, animation1, animation2) => const RegisterPage(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero
                                ));
                              },
                            )
                          ],
                        ),
                    ),
                    TextButton(
                      child: Text("Impressum", style: Style.createTextStyle(textColor: Style.textColorGray, fontSize: Style.textSmallSize)),
                      onPressed: () => {

                      },
                    )
                ]),
                )
              ),

              Container(
                width: innerSize.width,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DarkModeButton(onPressed: () {
                      setState(() {
                        
                      });
                    }),

                    LanguageButton(
                      backgroundColor: DarkThemeProvider.isDarkTheme ? Style.backgroundColorDark : Style.backgroundColor,
                      onPressed: () {
                        setState(() {
                          
                        });
                      }
                    )
                  ],
                )
              ),

              isLoggingIn == false ? const SizedBox.shrink() : AnimatedOpacity(
                opacity: isLoggingIn ? 1 : 0,
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
          ), 
        ),
      )
    );
  }
}
