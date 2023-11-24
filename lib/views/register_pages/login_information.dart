import 'package:flutter/material.dart';
import 'package:playground/components/input_field.dart';
import 'package:playground/globals/style.dart';
import 'package:playground/models/register_data.dart';
import 'package:playground/providers/dark_theme_provider.dart';
import 'package:playground/providers/language_provider.dart';

class LoginInformation extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final RegisterData data;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  const LoginInformation({
    Key? key, 
    required this.formKey,
    required this.data,
    this.emailController,
    this.passwordController
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginInformationState();
}

class _LoginInformationState extends State<LoginInformation> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = widget.emailController ?? TextEditingController();
    passwordController = widget.passwordController ?? TextEditingController();

    emailController.text = widget.data.email ?? "";
    passwordController.text = widget.data.password ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = DarkThemeProvider.isDarkTheme ? Style.backgroundColorDark : Style.backgroundColor;

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          InputField(
            controller: emailController,
            counterText: "",
            hintText: "Type your email",
            backgroundColor: backgroundColor,
            elevation: 0,
            hasPrefixIcon: true,
            prefixClickable: false,
            prefixActiveIcon: Icons.person_rounded,
            prefixInactiveIcon: Icons.person_rounded,
            prefixInactiveColor: Style.textColorHint,
            textStyle: Style.createTextStyle(
              textColor: DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor
            ),

            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field required";
              }

              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
                return "Invalid email";
              }

              widget.data.email = value;

              return null;
            },
          ),

          const Divider(),

          InputField(
            controller: passwordController,
            counterText: "",
            hintText: LanguageProvider.translate("login-type-password"),
            backgroundColor: backgroundColor,
            elevation: 0,
            minLength: 6,
            maxLength: 20,
            isSensitive: true,
            prefixClickable: false,
            hasPrefixIcon: true,
            prefixInactiveIcon: Icons.lock_rounded,
            prefixInactiveColor: Style.textColorHint,
            textStyle: Style.createTextStyle(
              textColor: DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor
            ),

            hasSuffixIcon: true,
            suffixActiveColor: DarkThemeProvider.isDarkTheme ? Style.gradientDark.colors.first : Style.gradient.colors.first,
            suffixInactiveColor: Style.textColorHint,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LanguageProvider.translate("field-required");
              }

              widget.data.password = value;

              return null;
            },
          ),
        ]
      ) 
    );
  }
}