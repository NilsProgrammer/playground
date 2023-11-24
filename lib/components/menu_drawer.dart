import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:playground/components/rounded_background.dart';
import 'package:playground/firebase/firebase_login.dart';
import 'package:playground/providers/dark_theme_provider.dart';
import 'package:playground/views/login_page.dart';
import 'package:playground/views/terms_conditions.dart';

import '../globals/style.dart';

class MenuDrawer extends StatefulWidget {
  final Duration duration;
  final List<MenuDrawerItem>? drawerItems;
  final List<Widget>? footerItems;
  final Duration delayDuration;
  final Duration slideDuration;
  final Duration staggerDuration;
  final Duration footerDelayDuration;
  final Duration footerAppearTime;
  final double widthScale;
  final Color backgroundColor;
  final double slideDistance;
  final AnimationController? controller;
  final Map<int, VoidCallback>? callbacks;

  const MenuDrawer({
    this.duration = const Duration(milliseconds: 1500),
    this.drawerItems,
    this.footerItems,
    this.delayDuration = const Duration(milliseconds: 50),
    this.slideDuration = const Duration(milliseconds: 150),
    this.staggerDuration = const Duration(milliseconds: 50),
    this.footerDelayDuration = const Duration(milliseconds: 150),
    this.footerAppearTime = const Duration(milliseconds: 500),
    this.widthScale = 0.9,
    this.backgroundColor = Style.backgroundColor,
    this.slideDistance = 150,
    this.controller,
    this.callbacks,

    Key? key
    }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Interval> _itemSlideIntervals = [];
  late final Duration _animationDuration;
  Interval _footerInterval = const Interval(1, 2);

  String _appVersion = "0";

  List<MenuDrawerItem> _drawerItems = [];
  List<Widget> _footerItems = [];

  @override
  void initState() {
    //Get version number and set it to _appVersion
    PackageInfo.fromPlatform().then((PackageInfo info) {
      _setVersion(info);
    });

    _controller = widget.controller ?? AnimationController(
      duration: widget.duration,
      vsync: this
    )..forward();

    super.initState();
  }

  void _setVersion(PackageInfo info) {
    setState(() {
      _appVersion = info.version;
    });

    _setDrawerItems();
  }

  void _setDrawerItems() {
    setState(() {
      _drawerItems = widget.drawerItems ?? [

        MenuDrawerItem(
          text: "How we use your data",
          onTapped: () {},
        ),

        MenuDrawerItem(
          text: "Terms and Conditions",
          onTapped: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsConditions(),
              ),
            );
          },
        ),

        MenuDrawerItem(
          text: "Contact",
          onTapped: () {},
        ),

        MenuDrawerItem(
          text: "Settings",
          onTapped: () {
            
          },
        ),

        MenuDrawerItem(
          text: "Logout",
          onTapped: () {
            FirebaseLogin.logout().whenComplete(() {
            
              
              Navigator.pushAndRemoveUntil(
                context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                (route) => false
              );
            });
          },
        ),
      ];

      _animationDuration = widget.delayDuration + (widget.staggerDuration * _drawerItems.length) + widget.footerDelayDuration + widget.footerAppearTime;

      _itemSlideIntervals.clear();
      //Create animation intervals
      for (var i = 0; i < _drawerItems.length; ++i) {
        final startTime = widget.delayDuration + (widget.staggerDuration * i);
        final endTime = startTime + widget.slideDuration;
        _itemSlideIntervals.add(
          Interval(
            startTime.inMilliseconds / _animationDuration.inMilliseconds,
            endTime.inMilliseconds / _animationDuration.inMilliseconds,
          ),
        );
      }

      _setFooterItems();
    });
  }

  void _setFooterItems() {
    setState(() {
      _footerItems = widget.footerItems ?? [
        Text("Version: $_appVersion", style: Style.createTextStyle(textColor: Style.textColorHint)),
        
        Text("Playground", style: Style.createTextStyle(fontSize: Style.textContentSize))
      ];

      final buttonStartTime = Duration(milliseconds: (_drawerItems.length * 50)) + widget.footerDelayDuration;
      final buttonEndTime = buttonStartTime + widget.footerAppearTime;

      _footerInterval = Interval(
        buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
        buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    
    super.dispose();
  }

  ///This will build all the list items from widget.children
  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _drawerItems.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_controller.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * widget.slideDistance;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: _drawerItems[i]
        ),
      );
    }
    return listItems;
  }

  ///This will build all the stuff that comes AFTER the list items
  Widget _buildFooter() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final animationPercent = Curves.elasticOut.transform(
              _footerInterval.transform(_controller.value.clamp(0.0, 1.0))
            );
            final opacity = animationPercent.clamp(0.0, 1.0);
            final scale = (animationPercent * 0.5) + 0.5;

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          child: Column(
            children: _footerItems
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * widget.widthScale;

    return Container(
      width: width,
      color: DarkThemeProvider.isDarkTheme ? Style.backgroundColorDark : Style.backgroundColor,
      padding: const EdgeInsets.all(Style.pagePadding),
      child: ListView(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 30),
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._buildListItems(),
                  
                Align(alignment: Alignment.bottomCenter, child: _buildFooter())
              ],
            )
          ),
        ],
      ),
    );
  }
}

class MenuDrawerItem extends StatelessWidget {
  final String text;
  final Widget? action;
  final void Function()? onTapped;

  const MenuDrawerItem({
    this.text = "",
    this.action,
    this.onTapped,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: RoundedBackground(
        color: DarkThemeProvider.isDarkTheme ? Style.darkColorDark : Style.textBoxBackgroundColor,
        borderRadius: 5,
        child: TextButton(
          onPressed: onTapped,
          child: Row(
            children: [
              Text(
                text,
                style: Style.createTextStyle(),
              ),
              action ?? const SizedBox.shrink()
            ]
          ) 
        ),

      )
    );
  }
}