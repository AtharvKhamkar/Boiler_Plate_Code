import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../themes/colors.dart';
import '../utils/utils.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final Icon prefixIcon;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;
  final bool redOnly;
  final Color colorText;
  final Color hintColor;
  final int minLine;
  final List<TextInputFormatter> formatter;
  final AutovalidateMode autovalidateMode;
  final TextCapitalization textCapitalization;

  final List<String> listOfAutofill;

  const CustomInputField(
      {Key? key,
      this.colorText = Colors.black,
      required this.controller,
      required this.listOfAutofill,
      required this.labelText,
      required this.hintText,
      required this.validator,
      this.hintColor = Colors.black45,
      this.suffixIcon = false,
      this.isDense,
      this.obscureText = false,
      required this.inputType,
      required this.prefixIcon,
      this.redOnly = false,
      this.formatter = const [],
        this.autovalidateMode =  AutovalidateMode.onUserInteraction,
        this.textCapitalization = TextCapitalization.none,
      this.minLine = 1})
      : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                readOnly: widget.redOnly,
                enableSuggestions: true,
                textInputAction: TextInputAction.next,
                autofillHints: widget.listOfAutofill,
                textCapitalization: widget.textCapitalization,
                enabled: !widget.redOnly,
                autofocus: false,
                style: TextStyle(color: widget.colorText),
                keyboardType: widget.inputType,
                keyboardAppearance: Get.theme.colorScheme.brightness,
                controller: widget.controller,
                inputFormatters: widget.formatter,
                obscureText: (widget.obscureText && _obscureText),
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: getTextColor(

                          lightTheme: greyColor,
                          darkTheme: greyColor)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  errorStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon
                      ? IconButton(
                          icon: Icon(
                            !_obscureText
                                ? Icons.remove_red_eye
                                : Icons.visibility_off_outlined,
                            color: getSubTitleColor(),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null,
                  suffixIconConstraints: (widget.isDense != null)
                      ? const BoxConstraints(maxHeight: 33)
                      : null,
                ),
                autovalidateMode: widget.autovalidateMode,
                validator: widget.validator,
                maxLines: widget.minLine > 1 ? null : 1,
                minLines: widget.minLine,
              ),
            ),
          ],
        ));
  }
}

class CustomInputField2 extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final Icon prefixIcon;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;
  final bool redOnly;
  final Color colorText;
  final String errorMessage;
  final Color hintColor;
  final int minLine;
  final Function? onChanged;
  final List<String> listOfAutofill;
  final List<TextInputFormatter> formatter;
  final AutovalidateMode autovalidateMode;
  final TextCapitalization textCapitalization;

  const CustomInputField2(
      {Key? key,
      this.colorText = Colors.black,
      required this.controller,
      required this.listOfAutofill,
      required this.labelText,
      required this.hintText,
      required this.errorMessage,
      required this.validator,
      this.hintColor = Colors.black45,
      this.suffixIcon = false,
      this.isDense,
      this.onChanged,
      this.obscureText = false,
      required this.inputType,
      required this.prefixIcon,
      this.redOnly = false,
        this.formatter = const [],
        this.autovalidateMode =  AutovalidateMode.onUserInteraction,
        this.textCapitalization  = TextCapitalization.none,
      this.minLine = 1})
      : super(key: key);

  @override
  State<CustomInputField2> createState() => _CustomInputField2State();
}

class _CustomInputField2State extends State<CustomInputField2> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                textCapitalization: widget.textCapitalization,
                onChanged: widget.onChanged as void Function(String)?,
                readOnly: widget.redOnly,
                enableSuggestions: true,
                textInputAction: TextInputAction.next,
                autofillHints: widget.listOfAutofill,
                enabled: !widget.redOnly,
                autofocus: false,
                style: TextStyle(color: widget.colorText),
                keyboardType: widget.inputType,
                keyboardAppearance: Get.theme.colorScheme.brightness,
                controller: widget.controller,
                obscureText: (widget.obscureText && _obscureText),
                inputFormatters: widget.formatter,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.02),
                  labelText: widget.labelText,
                  hintStyle: TextStyle(
                      color: getTextColor(

                    lightTheme: const Color.fromARGB(236, 255, 255, 255),
                    darkTheme: const Color.fromARGB(236, 255, 255, 255),
                  )),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: kPrimaryDark),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  errorText:
                      widget.errorMessage.isEmpty ? null : widget.errorMessage,
                  errorStyle: const TextStyle(
                    color: Colors.redAccent,
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  // contentPadding: EdgeInsets.all(15.0),
                  suffixIcon: widget.suffixIcon
                      ? IconButton(
                          icon: Icon(
                            !_obscureText
                                ? Icons.remove_red_eye
                                : Icons.visibility_off_outlined,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null,
                  suffixIconConstraints: (widget.isDense != null)
                      ? const BoxConstraints(maxHeight: 33)
                      : null,
                ),
                autovalidateMode: widget.autovalidateMode,
                validator: widget.validator,
                maxLines: widget.minLine > 1 ? null : 1,
                minLines: widget.minLine,
              ),
            ),
          ],
        ));
  }
}
