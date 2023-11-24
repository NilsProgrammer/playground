import 'package:flutter/material.dart';
import 'package:playground/components/rounded_background.dart';

import '../globals/style.dart';

/// Custom text field
class InputField extends StatefulWidget {
  final double? width;
  final double? height;
  final double? elevation;
  final double? borderRadius;
  final Color? backgroundColor;
  final LinearGradient? gradient;

  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;

  final String? hintText;
  final String? counterText;

  final int minLength;
  final int maxLength;
  final int maxLines;
  final FocusNode? node;
  final TextEditingController? controller;
  final bool isSensitive;
  final bool readonly;
  final TextInputType? keyboardType;
  final void Function()? onEditingComplete;
  final void Function()? onTap;

  final bool hasSuffixIcon;
  final bool suffixClickable;
  final IconButton? suffixButton;
  final IconData suffixActiveIcon;
  final IconData suffixInactiveIcon;
  final Color suffixActiveColor;
  final Color suffixInactiveColor;
  final void Function(bool active)? onSuffixClicked;

  final bool hasPrefixIcon;
  final bool prefixClickable;
  final IconButton? prefixButton;
  final IconData prefixActiveIcon;
  final IconData prefixInactiveIcon;
  final Color prefixActiveColor;
  final Color prefixInactiveColor;
  final void Function(bool active)? onPrefixClicked;

  final String? Function(String? value)? validator;
  final void Function(String text)? onValidateSuccess;

  const InputField({
    Key? key,
    //Properties for RoundedBackground
    this.width, this.height,
    this.elevation, this.borderRadius, this.backgroundColor, this.gradient,

    //Properties for TextFormField
    this.textStyle,
    this.hintStyle,
    this.errorStyle,

    this.hintText,
    this.counterText,

    this.minLength = 0,
    this.maxLength = 25,
    this.maxLines = 1,
    this.node,
    this.controller,
    this.isSensitive = false,
    this.readonly = false,
    this.keyboardType,
    this.onEditingComplete,

    this.onTap,

    this.hasSuffixIcon = false,
    this.suffixClickable = true,
    this.suffixButton,
    this.suffixActiveIcon = Icons.remove_red_eye,
    this.suffixInactiveIcon = Icons.remove_red_eye_outlined,
    this.suffixActiveColor = Style.primaryColor,
    this.suffixInactiveColor = Style.primaryColor,
    this.onSuffixClicked,

    this.hasPrefixIcon = false,
    this.prefixClickable = true,
    this.prefixButton,
    this.prefixActiveIcon = Icons.remove_red_eye,
    this.prefixInactiveIcon = Icons.remove_red_eye_rounded,
    this.prefixActiveColor = Style.primaryColor,
    this.prefixInactiveColor = Style.primaryColor,
    this.onPrefixClicked,

    this.validator,
    this.onValidateSuccess

  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _textVisible = false;
  bool _suffixActive = false;
  bool _prefixActive = false;

  @override
  void initState() {
    if (widget.node != null) {
      widget.node!.addListener(() {
        setState(() {
          
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.node != null) {
      widget.node!.dispose();
    }

    if (widget.controller != null) {
      widget.controller!.dispose();
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.textStyle ?? Style.textStyle;

    return RoundedBackground(
      width: widget.width,
      height: widget.height,
      elevation: widget.elevation ?? Style.elevation,
      borderRadius: widget.borderRadius ?? 50,
      color: widget.backgroundColor,
      gradient: widget.gradient,

      child: TextFormField(
        keyboardType: widget.keyboardType,
        onTap: widget.onTap,
        style: textStyle,
        obscureText: widget.isSensitive ? !_textVisible : false,
        focusNode: widget.node,
        controller: widget.controller,
        maxLength: widget.maxLength,
        readOnly: widget.readonly,
        textInputAction: TextInputAction.done,
        scrollPadding: const EdgeInsets.only(bottom:40),
        onEditingComplete: widget.onEditingComplete ?? () {
          if (widget.node != null) {
            widget.node!.unfocus();
          }
        },
        cursorColor: textStyle.color,
        maxLines: !widget.isSensitive ? widget.maxLines : 1,
        
        decoration: InputDecoration(
          isDense:true,
          hintStyle: widget.hintStyle ?? Style.createTextStyle(textColor: Style.textColorHint),
          fillColor: Colors.transparent,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          errorStyle: widget.errorStyle ?? Style.createTextStyle(textColor: Colors.redAccent),
          counterText: widget.counterText,
          hintText: widget.hintText,
          counterStyle: Style.createTextStyle(
            fontSize: Style.textSmallSize
          ),

          suffixIcon: widget.hasSuffixIcon ? widget.suffixButton ?? IconButton(
            padding: const EdgeInsets.only(left: 10),
            
            icon: Icon(
              _suffixActive ? widget.suffixActiveIcon : widget.suffixInactiveIcon,
              color: _suffixActive ? widget.suffixActiveColor : widget.suffixInactiveColor,
            ),

            onPressed: !widget.suffixClickable ? null : () {
              setState(() {
                _suffixActive = !_suffixActive;
                if (widget.isSensitive) {
                  _textVisible = !_textVisible;
                }

                if (widget.onSuffixClicked != null) {
                  widget.onSuffixClicked!(_suffixActive);
                }
              });
            }
          ) : null,

          prefixIcon: widget.hasPrefixIcon ? widget.prefixButton ?? IconButton(
            padding: const EdgeInsets.only(left: 10),
            
            icon: Icon(
              _prefixActive ? widget.prefixActiveIcon : widget.prefixInactiveIcon,
              color: _prefixActive ? widget.prefixActiveColor : widget.prefixInactiveColor,
            ),

            onPressed: !widget.prefixClickable ? null : () {
              setState(() {
                _prefixActive = !_prefixActive;
                if (widget.isSensitive) {
                  _textVisible = !_textVisible;
                }

                if (widget.onPrefixClicked != null) {
                  widget.onPrefixClicked!(_prefixActive);
                }
              });
            }
          ) : null
        ),

        validator: widget.validator ?? (text) {
          if (widget.minLength > 0 && (text == null || text.isEmpty)) {
            return "Field required";
          }

          if (widget.onValidateSuccess != null) {
            widget.onValidateSuccess!(text ?? "");
          }

          return null;
        },
      )
    );
  }

}