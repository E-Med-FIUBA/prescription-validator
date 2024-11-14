import 'package:flutter/material.dart';

void navigate(Widget widget, BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}
