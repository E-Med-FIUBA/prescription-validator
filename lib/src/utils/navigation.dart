import 'package:flutter/material.dart';

void navigate(Widget screen, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}
