import 'package:flutter/material.dart';
import 'package:playground/components/menu_drawer.dart';
import 'package:playground/globals/style.dart';
import 'package:playground/providers/dark_theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // final GlobalKey<MatchTabState> _matchTabKey = GlobalKey();
  final List<String> pageTitles = [
    "Match",
    "Chat",
    "Favorites",
    "Views",
    "My Profile"
  ];
  final List<Widget> pages = [];

  int page = 0;
  Future<bool>? hasUserDataFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = DarkThemeProvider.isDarkTheme ? Style.backgroundColorDark : Style.backgroundColor;

    return Scaffold(
      appBar: AppBar(
        //flexibleSpace: GradientBackground(),
        backgroundColor: const Color.fromARGB(255, 204, 0, 0),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                DarkThemeProvider().setDark(!DarkThemeProvider.isDarkTheme);
              });
            },
            icon: const Icon(Icons.light_mode_outlined)
          )
        ],
      ),
      drawer: MenuDrawer(
        widthScale: 0.25,
      ),
    );
  }
}