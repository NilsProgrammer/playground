import 'package:flutter/material.dart';
import 'package:playground/components/input_field.dart';
import 'package:playground/globals/style.dart';
import 'package:playground/models/register_data.dart';
import 'package:playground/providers/dark_theme_provider.dart';

class BasicInformation extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final RegisterData data;
  
  const BasicInformation({
    Key? key, 
    required this.formKey,
    required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BasicInformationState();
}

class _BasicInformationState extends State<BasicInformation> {
  final TextEditingController usernameController = TextEditingController();
  final List<Gender> genders = [Gender.male, Gender.female, Gender.diverse];

  bool genderDropdownVisible = false;

  @override
  void initState() {
    usernameController.text = widget.data.username ?? "";
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
            controller: usernameController,
            counterText: "",
            hintText: "Username max. 20 characters",
            backgroundColor: backgroundColor,
            elevation: 0,
            hasPrefixIcon: true,
            prefixClickable: false,
            prefixActiveIcon: Icons.person_outlined,
            prefixInactiveIcon: Icons.person_outlined,
            prefixInactiveColor: Style.textColorHint,
            textStyle: Style.createTextStyle(
              textColor: DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor
            ),

            maxLength: 20,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field required";
              }

              widget.data.username = value;

              return null;
            },
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<Gender>(
              hint: Text("Gender", style: Style.createTextStyle(textColor: Style.textColorHint)),
              value: widget.data.gender,
              
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide.none
                ),
                errorStyle: Style.createTextStyle(textColor: Colors.redAccent)
              ),
              focusColor: backgroundColor,
              dropdownColor: backgroundColor,
              validator: (value) => value == null ? "Field required" : null,
              style: Style.createTextStyle(
                textColor: DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor
              ),
              
              /* menuStyle: MenuStyle(
                backgroundColor: MaterialStateProperty.all(backgroundColor),
                side: MaterialStateProperty.all(
                  BorderSide.none
                ),
                
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                )
              ), */
              
              items: genders.map<DropdownMenuItem<Gender>>((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(
                    e.name,
                    style: Style.createTextStyle(
                      textColor: DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor
                    )
                  ),
                );
              }).toList(),
              onChanged: (Gender? value) {
                setState(() {
                  widget.data.gender = value ?? widget.data.gender;
                });
              },
            )
          )
        ]
      ) 
    );
  }
}