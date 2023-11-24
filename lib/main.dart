import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:playground/firebase_options.dart';
import 'package:playground/providers/dark_theme_provider.dart';
import 'package:playground/providers/language_provider.dart';
import 'package:playground/views/splash_page.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void refresh(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    if (state != null) {
      MyApp.refresh(state.context);
    }
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool seenSplash = false;

  @override
  void initState() {
    DarkThemeProvider();
    LanguageProvider();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: MaterialApp(
          title: 'Playground',
          theme: ThemeData(canvasColor: Colors.transparent,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              minimumSize: const Size.square(80)
            )
          )
          ),
          debugShowCheckedModeBanner: false,
          home: SplashPage() //keep not const so that dark mode applies
        ));
  }
}