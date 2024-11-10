import 'package:flutter/material.dart';

void navigate(String routeName, BuildContext context, {Object? arguments}) {
  Navigator.restorablePushNamed(
    context,
    routeName,
    arguments: arguments,
  );
}
