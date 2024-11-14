import 'package:flutter/material.dart';

class LazyLoadScreen extends StatefulWidget {
  final Widget Function() builder;
  final String routeName;

  const LazyLoadScreen({
    required this.builder,
    required this.routeName,
    Key? key,
  }) : super(key: key);

  @override
  State<LazyLoadScreen> createState() => _LazyLoadScreenState();
}

class _LazyLoadScreenState extends State<LazyLoadScreen>
    with AutomaticKeepAliveClientMixin {
  late Widget child;
  bool _initialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeChild();
  }

  void _initializeChild() {
    if (!_initialized) {
      child = widget.builder();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _initialized
        ? child
        : const Center(child: CircularProgressIndicator());
  }
}
