import 'package:flutter/material.dart';

void navigate(String routeName, BuildContext context, {Object? arguments}) {
  Navigator.pushNamed(
    context,
    routeName,
    arguments: arguments,
  );
}
