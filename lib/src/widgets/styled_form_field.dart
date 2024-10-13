import 'package:flutter/material.dart';

import '../utils/validators.dart';

class StyledFormField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final Widget? suffixIcon;
  final List<Validators> validators;
  final void Function(String?)? onSaved;

  const StyledFormField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.suffixIcon,
    this.validators = const [],
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    final FormInputValidator inputValidator =
        FormInputValidator(validators, Key(labelText));
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        suffixIcon: suffixIcon,
      ),
      validator: inputValidator.validate,
      onSaved: onSaved,
    );
  }
}
